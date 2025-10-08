library(DBI)
library(RMySQL)
library(dbplyr)
library(dplyr)
library(rsample)
library(bonsai)
library(tidymodels)
library(caret)
library(yardstick)
con <- dbConnect(RMySQL::MySQL(),
                 dbname = "foodpanda",
                 host = "localhost",
                 port = 3306,
                 user = "root",
                 password = "your password")

if (is.null(con)) {
  stop("The database connection failed.")
} else {
  print("Successfully connected to the foodpanda database.")
}

foodpanda_df <- dbReadTable(con, "`foodpanda analysis dataset 4`")
dbDisconnect(con)

# Make sure the 'churned' column is factor type
foodpanda_df$churned <- as.factor(foodpanda_df$churned)

#Separate numerical and categorical features
numeric_cols <- c("quantity", "price", "order_frequency", "loyalty_points", "rating")
categorical_cols <- c("gender", "age", "city", "restaurant_name", "dish_name", "category", "payment_method", "delivery_status")

# Filter out the rating columns that contain too many missing values
foodpanda_df <- foodpanda_df %>%
  filter(!is.na(rating))

# transfer loyality_points to numeric type
foodpanda_df$loyalty_points <- as.numeric(foodpanda_df$loyalty_points)

# PCA
numeric_data <- foodpanda_df %>% select(all_of(numeric_cols))
# PCA requires that the data have no missing values, so here fill it with the mean
numeric_data <- caret::preProcess(numeric_data, method = c("center", "scale", "knnImpute")) %>% predict(numeric_data)
pca_result <- prcomp(numeric_data, scale = TRUE)

pca_result$sdev

pca_data <- as.data.frame(pca_result$x[, 1:5])

# Perform unique heat encoding on categorical features
categorical_data <- foodpanda_df %>% select(all_of(categorical_cols))
dmy <- dummyVars("~ .", data = categorical_data, fullRank = TRUE)
encoded_data <- data.frame(predict(dmy, newdata = categorical_data))

# combine the PCA results, encoded category features and dependent variables
processed_data <- bind_cols(pca_data, encoded_data)
processed_data$churned <- as.factor(foodpanda_df$churned)
# split data into train and test dataset
set.seed(2505153)
data_split_optimized <- initial_split(processed_data, prop = 0.8, strata = churned)
train_data_optimized <- training(data_split_optimized)
test_data_optimized <- testing(data_split_optimized)
summary(train_data_optimized)
summary(test_data_optimized)

# lightgbm
library(lightgbm)
library(themis)
# Establish a Workflow for hyperparameter optimization
# ===================================================

# 1.Establish a data preprocessing Recipe
# We use step_smote() to oversampling the training set to handle data imbalance
churn_recipe <- recipe(churned ~ ., data = train_data_optimized) %>%
  step_smote(churned, over_ratio = 1) # 将少数类别数量增加到与多数类别相同

# 2. Define the Model Specification of LightGBM
# Use tune() to specify the hyperparameters that need to be tuned
lgbm_spec <- boost_tree(
  mode = "classification",
  engine = "lightgbm",
  trees = tune(),
  learn_rate = tune(),
  tree_depth = tune(),
  min_n = tune()
)

# 3. Create a Workflow to bind the recipe and the model
lgbm_workflow <- workflow() %>%
  add_recipe(churn_recipe) %>%
  add_model(lgbm_spec)

# 4. Set the Grid for hyperparameter tuning
lgbm_grid <- grid_latin_hypercube(
  trees(),
  learn_rate(),
  tree_depth(),
  min_n(),
  size = 10
)

# 5. Cross-Validation
set.seed(2505153)
lgbm_folds <- vfold_cv(train_data_optimized, v = 5)

# 6. Perform hyperparameter tuning
lgbm_tune_results <- tune_grid(
  lgbm_workflow,
  resamples = lgbm_folds,
  grid = lgbm_grid,
  metrics = metric_set(accuracy, roc_auc)
)

show_best(lgbm_tune_results, metric = "roc_auc")
best_lgbm_params <- select_best(lgbm_tune_results, metric = "roc_auc")

# Complete the final model using the best combination of parameters
final_lgbm_workflow <- lgbm_workflow %>%
  finalize_workflow(best_lgbm_params)

# Train the final model on the entire training set
final_lgbm_fit <- fit(final_lgbm_workflow, data = train_data_optimized)
summary(final_lgbm_fit)

# prediction
final_predictions <- predict(final_lgbm_fit, new_data = test_data_optimized, type = "class") %>%
  bind_cols(test_data_optimized %>% select(churned))

# Calculate the final accuracy rate and confusion matrix
final_accuracy <- accuracy(final_predictions, truth = churned, estimate = .pred_class)
final_conf_mat <- conf_mat(final_predictions, truth = churned, estimate = .pred_class)

