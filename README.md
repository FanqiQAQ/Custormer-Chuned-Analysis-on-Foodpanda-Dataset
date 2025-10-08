# Custormer-Churned-Analysis-on-Foodpanda-Dataset
Customer Churn Prediction Analysis
1. Research Objectives
The goal of this analysis is to predict the likelihood of customer churn by analyzing Foodpanda's customer, order, and review data, and to deeply explore the key factors that influence churn. Our aim is to provide data-driven insights to the platform and its merchants to develop more effective customer retention strategies.
2. Predictive Modeling Process and Results Analysis
We employed two mainstream machine learning models to predict customer churn: Logistic Regression and LightGBM.
1. Logistic Regression
We chose Logistic Regression as the baseline model for binary classification prediction. The main reasons for this choice were:
Easy to understand and interpret: The coefficients of a logistic regression model can be directly interpreted as the effect of an independent variable on the log-odds of the dependent variable. This allows for a clear understanding of which factors are related to customer churn.
High computational efficiency:
For most medium-sized datasets, logistic regression trains very quickly.
Model Results:
Despite a low prediction accuracy of approximately 50% on the test set, the diagnostic results provided valuable insights. The model's fit, as indicated by the Residual Deviance of 7935.4, showed only a limited improvement over the Null Deviance of 8366.1. This suggests that the model failed to adequately capture the complex patterns in the data.
3. LightGBM Model
Considering the linear limitations of logistic regression, we next attempted a more powerful non-linear model, LightGBM, which handles complex non-linear relationships by constructing multiple decision trees.
Model Results:
The accuracy of the LightGBM model showed only a marginal improvement, at approximately 53.9%. The model's AUC value was 0.537905, which is only slightly better than a random guess. This indicates that the problem may not be simply a matter of model selection.
4. Analysis of Poor Model Performance
The poor performance of both models points to the root of the problem likely being insufficient feature information in the original dataset.
Correlation Analysis: A correlation analysis of all major variables against the customer churn status revealed almost no linear relationship between them. Since logistic regression is a linear model, this directly explains its poor performance.
Non-linear Model Limitations: Even a powerful non-linear model like LightGBM struggles to find valuable patterns when the features themselves lack strong predictive signals. This re-emphasizes that the quality and representativeness of data features are critical to successful modeling.
Conclusion: Although we were unable to build a highly accurate predictive model, this process was still valuable. It highlighted that, beyond model complexity, deeper data insights and robust feature engineering are central to solving the problem.

5. Business Insights from Key Variables
Despite the low predictive accuracy, the significance analysis from the logistic regression model allowed us to extract key variables that have a notable impact on customer churn, providing the following actionable business conclusions:
Order Cancellation (delivery_statusCancelled): This is the strongest factor influencing customer churn. The logistic regression model showed a very high coefficient, indicating an extremely strong positive correlation between order cancellations and the likelihood of a customer becoming "Inactive."
Business Insight: A negative customer experience, especially an order cancellation, is the most direct and forceful reason for churn. The platform should prioritize investments in optimizing its order management system to reduce cancellations due to inventory, delivery riders, or other issues. This is the most effective customer retention strategy.
Customer Rating (rating): Customer ratings also have a significant impact on churn.
Business Insight: The relationship between rating and churn needs further analysis. A potential explanation is that some loyal customers, after a single bad experience, give a high negative rating and churn quickly. The platform should establish a rapid response mechanism for low-rated orders, proactively contacting customers to rebuild trust.
Loyalty Points (loyalty_points) and Order Frequency (order_frequency): These two variables showed some statistical significance and a negative correlation with churn.
Business Insight: This aligns with intuition. Customers with high loyalty points or high order frequency are typically more stable and less likely to churn. This means the platform can use customer loyalty programs as a leading indicator of churn and offer customized incentives to customers whose points or order frequency are declining.
These conclusions provide a clear direction for the platform and its merchants, helping them better understand and manage user churn, ultimately enhancing customer satisfaction and business value.
________________________________________
Customer Segmentation and Value Analysis
1. Research Background and Objectives
This part is a further exploration of the data following our previous customer churn prediction modeling using Logistic Regression and LightGBM. In that analysis, we found that despite using powerful predictive models, the accuracy was not ideal. This led us to understand that the complexity of customer churn may stem from a lack of strong linear or non-linear predictive signals in the data itself.
Therefore, we are shifting our focus from "prediction" to "understanding" and "exploration." Our main objective is to use the RFM model and the K-Means clustering algorithm to scientifically segment our users. This will help the platform and its merchants better understand the characteristics, purchasing behaviors, and potential value of different user groups, providing a solid foundation for developing refined marketing and customer retention strategies.
2. Analysis Method: The RFM Customer Value Model
We use the RFM (Recency, Frequency, Monetary) model to measure customer value. The three key metrics of the RFM model are as follows:
R (Recency) - Time Since Last Purchase: How long ago was the customer's last purchase? This metric reflects customer engagement; a smaller value means the customer is more active.
F (Frequency) - Purchase Frequency: The number of purchases a customer has made over a period. This metric reflects customer loyalty; a larger value means the customer is more loyal.
M (Monetary) - Monetary Value: The total amount of money a customer has spent. This metric reflects the customer's spending power; a larger value means a higher customer value.
By calculating the RFM values for each customer, we can compress complex customer behavior data into three easily analyzable dimensions, which serves as a foundation for subsequent cluster analysis.
3. Model Selection and Cluster Results Analysis
We used the K-Means clustering algorithm to segment the RFM data. K-Means is a common unsupervised learning algorithm that automatically assigns data points to the most similar groups. To determine the optimal number of clusters (K), we employed the Elbow Method. This method finds the "elbow point" in a plot of the total within-cluster sum of squares for different K values, which indicates the optimal number of clusters.
Based on our analysis, we segmented customers into four groups. The visualization of the clustering results is as follows:

By analyzing the RFM characteristics of these four segmented groups, we drew the following conclusions:
Group 1 (Red): New / Low-Value Active Customers
Characteristics: These customers have purchased recently (small Recency value) but have a low total spend (small Monetary value).
Conclusion: This group represents the growth potential of your business. They are interested in the platform, but their spending habits are not yet established.
Recommendation: Encourage them to make more repeat purchases with personalized new-user coupons, popular dish recommendations, or limited-time discounts to grow them into higher-value customers.
Group 2 (Blue): High-Value Churn Risk Customers
Characteristics: This group has a very high total spend (largest Monetary value) but has not purchased in a while (large Recency value).
Conclusion: These customers were once your core revenue source but are now at risk of churning. They are the top priority for retention efforts.
Recommendation: Launch targeted retention campaigns immediately. Use high-value, personalized initiatives such as exclusive VIP offers, dedicated customer support, or direct contact to understand their reasons for not purchasing again and reactivate their engagement.
Group 3 (Green): Low-Value Churned Customers
Characteristics: These customers have a low total spend (small Monetary value) and have not purchased for a long time (largest Recency value).
Conclusion: This group has limited contribution to the business and has already churned.
Recommendation: You can use low-cost, bulk marketing strategies (such as email campaigns or push notifications) to occasionally reach out to them. The bulk of retention resources should be focused on more promising groups.
Group 4 (Purple): Mid-Value Active Customers
Characteristics: These customers have purchased recently (small Recency value) and their total spend is at a moderate level (mid-range Monetary value).
Conclusion: This group is the stable foundation of your business. They are regular users who provide a consistent stream of revenue.
Recommendation: Encourage them to increase their spending and frequency through loyalty programs, point rewards, or gamified "spending challenges" to move them toward the high-value customer group.
5. Summary and Outlook
This report, using RFM and K-Means clustering, successfully segmented the complex customer base into four easily understandable market segments. These conclusions provide a clear direction for the platform and its merchants, helping them allocate marketing and operational resources more precisely.
Future work can delve deeper by:
Integrating customer churn prediction models to provide more accurate churn risk assessments for each segment.
Combining the segmentation results with marketing campaign data to analyze the effectiveness of different strategies on each group.
Utilizing the clustering results to provide more personalized product recommendations and ad targeting for customers.
________________________________________
Foodpanda Customer Value and Behavioral Insights Report
1. Research Background and Objectives
This report serves as a follow-up to our previous analyses on Foodpanda customer churn prediction. Our goal is to dive deeper into customer behavior and potential value through direct SQL queries. While our previous analyses provided a macro view of predictive models and customer segments, this report focuses on specific business metrics to gain more precise and actionable insights. The aim is to help the platform and its merchants develop targeted retention and growth strategies.
2. Key Business Insights
We conducted a multi-dimensional analysis of key business metrics using SQL, leading to the following crucial conclusions:
1. Correlation Between Payment Method and Customer Churn
We analyzed the churn rate of customers using different payment methods, and the results show:
Payment Method	Total Customers	Churned Customers	Churn Rate
Credit Card	122	12	9.8%
Cash on Delivery	115	13	11.3%
Insight: The churn rate for customers using Cash on Delivery is slightly higher than for credit card users. This may indicate that credit card users are more likely to be regular consumers of the platform, while Cash on Delivery users tend toward one-off or occasional purchases.
Business Recommendation: The platform should encourage Cash on Delivery users to switch to online payment methods to increase their engagement and loyalty.

2. Correlation Between Customer Churn and Service Quality
We analyzed the relationship between customers' average ratings and their churn status, with a surprising result:
The average rating for churned customers (4.38) is slightly higher than for active customers (4.37).
Insight: This counter-intuitive result suggests that customer churn is not solely driven by "low satisfaction." Customers who are truly dissatisfied may simply churn without leaving negative feedback.
Business Recommendation: Do not overly rely on ratings as the sole indicator for churn warnings. More effective warning signs may be hidden in behavioral data, such as a sudden drop in order frequency or a prolonged period without a purchase.
3. The Dynamic Balance Between Churn and Business Growth
Our monthly analysis of customer churn and acquisition revealed a precise dynamic balance:
The number of new customers acquired each month is equal to the number of customers who churn.
Insight: This trend is a significant warning sign. It shows that while the platform's customer acquisition is stable, its customer retention strategy is clearly lacking, preventing overall growth of the customer base.
Business Recommendation: Shift resources from pure customer acquisition to retention. By conducting a deep analysis of churned customers' behaviors and implementing targeted retention plans, can break this zero-growth cycle.
4. Conclusion and Outlook
Through this series of SQL queries, we have validated parts of our previous report and gained more specific business insights. Order cancellation remains the most direct and forceful cause of customer churn. Furthermore, the churn of high-value customers poses the greatest potential threat to the business.
