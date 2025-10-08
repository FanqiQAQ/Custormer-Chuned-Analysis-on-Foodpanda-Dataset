# Custormer-Churned-Analysis-on-Foodpanda-Dataset
# Foodpanda Customer Churn and Value Analysis

This repository contains a series of analyses on Foodpanda's customer data. The primary goal is to understand and predict customer churn, segment customers based on their value, and derive actionable business insights to improve customer retention and marketing strategies.

## Table of Contents
1.  [Customer Churn Prediction Analysis](#customer-churn-prediction-analysis)
2.  [Customer Segmentation and Value Analysis (RFM)](#customer-segmentation-and-value-analysis-rfm)
3.  [Customer Value and Behavioral Insights (SQL Analysis)](#customer-value-and-behavioral-insights-sql-analysis)
4.  [Overall Conclusions and Future Work](#overall-conclusions-and-future-work)

---

## Customer Churn Prediction Analysis

### 1. Research Objectives
* [cite_start]To predict the likelihood of customer churn by analyzing customer, order, and review data[cite: 3].
* [cite_start]To identify the key factors that influence customer churn[cite: 3].
* [cite_start]To provide data-driven insights for developing effective customer retention strategies[cite: 4].

### 2. Predictive Modeling and Results
[cite_start]Two machine learning models were used for churn prediction: **Logistic Regression** and **LightGBM**[cite: 6].

* [cite_start]**Logistic Regression**: Chosen as a baseline model for its interpretability and computational efficiency[cite: 8, 9, 11].
    * [cite_start]**Result**: The model's performance was poor, with a prediction accuracy of only **50%**[cite: 13]. [cite_start]The analysis of deviance showed that the model failed to capture complex patterns in the data[cite: 14, 15].

* [cite_start]**LightGBM**: A more powerful non-linear model was used to handle complex relationships in the data[cite: 17].
    * [cite_start]**Result**: The model showed only a marginal improvement, with an accuracy of **53.9%** and an AUC value of **0.537905**, which is only slightly better than a random guess[cite: 19, 20].

### 3. Analysis of Poor Model Performance
[cite_start]The poor performance of both models was attributed to insufficient feature information in the dataset[cite: 23]. [cite_start]A correlation analysis revealed almost no linear relationship between the major variables and customer churn, which explains the failure of both the linear (Logistic Regression) and the more complex non-linear (LightGBM) models[cite: 24, 25, 26].

### 4. Key Business Insights from Churn Analysis
[cite_start]Despite the low predictive accuracy, the models provided valuable business insights[cite: 31]:

* [cite_start]**Order Cancellation (`delivery_statusCancelled`)**: This is the **strongest factor** influencing customer churn[cite: 32]. [cite_start]A negative experience, especially an order cancellation, is the most direct reason for churn[cite: 34].
    * [cite_start]**Recommendation**: Prioritize investments in optimizing the order management system to reduce cancellations[cite: 35]. [cite_start]This is the most effective retention strategy[cite: 36].

* [cite_start]**Customer Rating (`rating`)**: Customer ratings have a significant impact on churn[cite: 37]. [cite_start]It's possible that loyal customers churn quickly after a single bad experience, leaving a high negative rating[cite: 39].
    * [cite_start]**Recommendation**: Establish a rapid response mechanism for low-rated orders to proactively contact customers and rebuild trust[cite: 40].

* [cite_start]**Loyalty and Frequency (`loyalty_points`, `order_frequency`)**: These variables showed a negative correlation with churn, meaning customers with high loyalty points and order frequency are less likely to churn[cite: 41, 42].
    * [cite_start]**Recommendation**: Use loyalty programs as a leading indicator for churn risk and offer customized incentives to customers whose engagement is declining[cite: 43].

---

## Customer Segmentation and Value Analysis (RFM)

### 1. Research Objectives
[cite_start]Given the limitations of predictive modeling, the focus shifted from "prediction" to "understanding" and "exploration"[cite: 50]. [cite_start]The objective was to segment users scientifically using the **RFM (Recency, Frequency, Monetary) model** and the **K-Means clustering algorithm** to better understand different user groups[cite: 51, 54].

### 2. Methodology
* [cite_start]**RFM Model**: Measures customer value based on three metrics[cite: 54]:
    * [cite_start]**Recency (R)**: Time since the last purchase (lower is better)[cite: 56, 57].
    * [cite_start]**Frequency (F)**: Number of purchases over a period (higher is better)[cite: 58, 59].
    * [cite_start]**Monetary (M)**: Total amount spent (higher is better)[cite: 60, 61].
* [cite_start]**K-Means Clustering**: An unsupervised learning algorithm used to segment customers into distinct groups based on their RFM scores[cite: 64, 65]. [cite_start]The optimal number of clusters was determined to be four using the Elbow Method[cite: 66, 68].

### 3. Customer Segments and Recommendations
Four distinct customer groups were identified:

* **Group 1: New / Low-Value Active Customers**
    * [cite_start]**Characteristics**: Purchased recently but have a low total spend[cite: 72].
    * [cite_start]**Recommendation**: Encourage repeat purchases with new-user coupons, popular recommendations, or limited-time discounts to grow their value[cite: 75].

* **Group 2: High-Value Churn Risk Customers**
    * [cite_start]**Characteristics**: High total spend but have not purchased in a while[cite: 77].
    * [cite_start]**Conclusion**: These were core customers and are now a top priority for retention[cite: 78, 79].
    * [cite_start]**Recommendation**: Immediately launch targeted retention campaigns with high-value, personalized offers or dedicated support to reactivate them[cite: 80].

* **Group 3: Low-Value Churned Customers**
    * [cite_start]**Characteristics**: Low total spend and have not purchased for a long time[cite: 82].
    * **Recommendation**: Use low-cost, bulk marketing strategies (e.g., email campaigns) to occasionally reach out. [cite_start]Retention resources should be focused on more promising groups[cite: 84, 85].

* **Group 4: Mid-Value Active Customers**
    * [cite_start]**Characteristics**: Purchased recently with a moderate total spend[cite: 87].
    * [cite_start]**Conclusion**: This group forms the stable foundation of the business, providing a consistent revenue stream[cite: 88, 89].
    * [cite_start]**Recommendation**: Encourage increased spending and frequency through loyalty programs and gamified challenges to move them into the high-value segment[cite: 90].

---

## Customer Value and Behavioral Insights (SQL Analysis)

### 1. Research Objectives
[cite_start]This analysis serves as a follow-up to the previous reports, using direct SQL queries to dive deeper into specific business metrics and gain more precise, actionable insights[cite: 100, 101, 102].

### 2. Key Business Insights from SQL Queries

* **Payment Method and Churn**:
    * [cite_start]**Finding**: The churn rate for **Cash on Delivery (11.3%)** is slightly higher than for **Credit Card (9.8%)** users[cite: 108, 109].
    * [cite_start]**Recommendation**: Encourage Cash on Delivery users to switch to online payment methods to increase their engagement and loyalty[cite: 111].

* **Service Quality and Churn**:
    * [cite_start]**Finding**: The average rating for churned customers (4.38) is slightly **higher** than for active customers (4.37)[cite: 114].
    * **Insight**: This counter-intuitive result suggests that customer churn is not solely driven by low satisfaction. [cite_start]Relying only on ratings as a churn indicator is not sufficient[cite: 115, 117]. [cite_start]Behavioral data, like a drop in order frequency, may be a more effective warning sign[cite: 118].

* **Churn and Business Growth**:
    * [cite_start]**Finding**: The number of new customers acquired each month is **equal** to the number of customers who churn[cite: 121].
    * [cite_start]**Insight**: This "zero-growth" cycle is a significant warning sign, indicating that the customer retention strategy is lacking[cite: 122].
    * [cite_start]**Recommendation**: Shift resources from pure customer acquisition to customer retention by analyzing churned customer behavior and implementing targeted retention plans[cite: 123, 124].

---

## Overall Conclusions and Future Work

### Conclusions
1.  [cite_start]**Order Cancellation is the Primary Driver of Churn**: Across all analyses, order cancellation consistently emerged as the most direct and forceful cause of customer churn[cite: 32, 127].
2.  [cite_start]**High-Value Customers Pose the Greatest Churn Risk**: The churn of high-value customers represents the most significant potential threat to the business[cite: 128].
3.  **Retention is Key to Growth**: The platform is stuck in a zero-growth cycle where new customer acquisition is cancelled out by churn. [cite_start]A strategic shift towards customer retention is critical for sustainable growth[cite: 122, 123].

### Future Work
* [cite_start]Integrate churn prediction models with customer segments to provide more accurate churn risk assessments for each group[cite: 95].
* [cite_start]Analyze the effectiveness of different marketing strategies on each customer segment[cite: 96].
* [cite_start]Utilize clustering results to provide more personalized product recommendations and ad targeting[cite: 97].
