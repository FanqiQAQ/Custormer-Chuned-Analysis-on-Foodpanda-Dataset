library(DBI)
library(RMySQL)
library(dplyr)
library(rsample)
library(caret)
library(yardstick)

# load data from database
con <- dbConnect(RMySQL::MySQL(),
                 dbname = "foodpanda",
                 host = "localhost",
                 port = 3306,
                 user = "root",
                 password = "your password")
original_data <- dbReadTable(con, "`foodpanda analysis dataset 4`")
dbDisconnect(con)

numeric_cols <- c("quantity", "price", "order_frequency", "loyalty_points", "rating")
categorical_cols <- c("gender", "age", "city", "restaurant_name", "dish_name", "category", "payment_method", "delivery_status")

# Filter out the rating columns that contain too many missing values
processed_data <- original_data %>%
  filter(!is.na(rating))

# transfer loyalty_points to numeric
processed_data$loyalty_points <- as.numeric(processed_data$loyalty_points)

# PCA
numeric_data <- processed_data %>% select(all_of(numeric_cols))

# Centralization and standardization
pca_preprocessing <- caret::preProcess(numeric_data, method = c("center", "scale", "knnImpute"))
numeric_data_processed <- predict(pca_preprocessing, numeric_data)
pca_result <- prcomp(numeric_data_processed)

pca_result$sdev
# Select the first five principal components
pca_data <- as.data.frame(pca_result$x[, 1:5])

# Perform unique heat encoding on categorical features
categorical_data <- processed_data %>% select(all_of(categorical_cols))
dmy <- dummyVars("~ .", data = categorical_data, fullRank = TRUE)
encoded_data <- data.frame(predict(dmy, newdata = categorical_data))

# combine the PCA results, encoded category features and dependent variables
final_data <- bind_cols(pca_data, encoded_data)
final_data$churned <- as.factor(processed_data$churned)

#split into train and test set
set.seed(2505153)
data_split_original <- initial_split(final_data, prop = 0.8, strata = churned)
train_data_original <- training(data_split_original)
test_data_original <- testing(data_split_original)

# Train the initial model on the full dataset
glm_fit_full <- glm(
  churned ~ .,
  data = train_data_original,
  family = binomial()
)
summary(glm_fit_full)
# Use the step() function for bidirectional selection to find the best model
glm_fit_step <- step(glm_fit_full, direction = "both", trace = FALSE)
summary(glm_fit_step)


# predict using the optimized model
glm_predictions_step_prob <- predict(
  glm_fit_step,
  newdata = test_data_original,
  type = "response"
) %>%
  as_tibble() %>%
  rename(probability = value)

# transfer the probability into classification results
glm_predictions_step_final <- glm_predictions_step_prob %>%
  mutate(predicted_class = as.factor(ifelse(probability > 0.5, "Inactive", "Active"))) %>%
  bind_cols(test_data_original %>% select(churned))

# Calculate the accuracy rate and confusion matrix
print(accuracy(glm_predictions_step_final, truth = churned, estimate = predicted_class))
print(conf_mat(glm_predictions_step_final, truth = churned, estimate = predicted_class))