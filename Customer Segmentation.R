#install.packages(c("dplyr", "lubridate", "factoextra", "cluster"))
library(lubridate)
library(factoextra)
library(cluster)
library(DBI)
library(RMySQL)
library(dplyr)
library(ggplot2)

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

original_data <- dbReadTable(con, "`foodpanda analysis dataset 4`")
dbDisconnect(con)
# Calculate the RFM index
rfm_data <- original_data %>%
  mutate(order_date = ymd(order_date),
         last_order_date = ymd(last_order_date)) %>%
  na.omit() %>%
  group_by(customer_id) %>%
  summarise(
    Recency = as.numeric(Sys.Date() - max(last_order_date)),
    Frequency = max(order_frequency),
    Monetary = sum(price),
    churned_status = first(churned),
    .groups = 'drop'
  )

print(head(rfm_data))
# Standardization
rfm_scaled <- rfm_data %>%
  select(Recency, Frequency, Monetary) %>%
  scale()

# Elbow Method
fviz_nbclust(rfm_scaled, kmeans, method = "wss")

# The optimal K value derived from the elbow method is 4
set.seed(2505153)
kmeans_result <- kmeans(rfm_scaled, centers = 4, nstart = 25)

# Add the clustering results and loss status to the RFM data frame
rfm_segmented <- rfm_data %>%
  mutate(cluster = as.factor(kmeans_result$cluster),
         churned = as.factor(churned_status))

# Check the characteristics of each subgroup
cluster_summary <- rfm_segmented %>%
  group_by(cluster) %>%
  summarise(
    count = n(),
    avg_recency = mean(Recency),
    avg_frequency = mean(Frequency),
    avg_monetary = mean(Monetary),
    churn_rate = sum(churned == "Inactive") / n()
  )

print("Summary of customer segmentation groups：")
print(cluster_summary)

# visualization
ggplot(rfm_segmented, aes(x = Recency, y = Monetary, color = cluster, shape = churned)) +
  geom_point(alpha = 0.6) +
  labs(title = "Visualization of customer RFM segmentation and churn status",
       x = "Recent consumption days",
       y = "Total consumption amount",
       color = "Customer group",
       shape = "churned status") +
  theme_minimal()