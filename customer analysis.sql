-- Customer Churn Analysis
--
-- 1. Customer behavior analysis
-- 1.1 Identify the differences in average ratings between lost customers and active customers
-- Find out whether the lost customers are generally more dissatisfied with the service.
SELECT
    churned,
    AVG(rating) AS average_rating,
    COUNT(DISTINCT customer_id) AS customer_count
FROM
    `foodpanda analysis dataset 4`
WHERE
    rating IS NOT NULL
GROUP BY
    churned;

-- 1.2 Identify the differences in payment method preferences between lost customers and active customers
SELECT
    payment_method,
    SUM(CASE WHEN churned = 'Active' THEN 1 ELSE 0 END) AS active_customers,
    SUM(CASE WHEN churned = 'Inactive' THEN 1 ELSE 0 END) AS inactive_customers,
    COUNT(customer_id) AS total_customers
FROM
    `foodpanda analysis dataset 4`
GROUP BY
    payment_method
ORDER BY
    total_customers DESC;

-- 2. Time series analysis: Monthly statistics of the number of lost and new customers
SELECT
    DATE_FORMAT(signup_date, '%Y-%m') AS month,
    COUNT(DISTINCT CASE WHEN churned = 'Inactive' THEN customer_id END) AS churned_customers,
    -- Suppose the new customer is one who has placed an order within 30 days after registration
    COUNT(DISTINCT CASE WHEN DATEDIFF(order_date, signup_date) < 30 THEN customer_id END) AS new_customers
FROM
    `foodpanda analysis dataset 4`
GROUP BY
    month
ORDER BY
    month;


-- 3. High-value customer insights: Identify the top 10% of customers in terms of spending amount and analyze their churn rate
WITH CustomerTotalMonetary AS (
    SELECT
        customer_id,
        SUM(price) AS total_monetary
    FROM
        `foodpanda analysis dataset 4`
    GROUP BY
        customer_id
), RankedCustomers AS (
    SELECT
        customer_id,
        total_monetary,
        NTILE(10) OVER (ORDER BY total_monetary DESC) AS monetary_decile
    FROM
        CustomerTotalMonetary
)
SELECT
    t1.customer_id,
    t2.total_monetary,
    t2.monetary_decile,
    -- Use an aggregate function on `churned`
    MIN(t1.churned) AS churned_status
FROM
    `foodpanda analysis dataset 4` AS t1
JOIN
    RankedCustomers AS t2 ON t1.customer_id = t2.customer_id
WHERE
    t2.monetary_decile = 1
GROUP BY
    t1.customer_id, t2.total_monetary, t2.monetary_decile -- Make sure all non-aggregated columns are in the GROUP BY
ORDER BY
    t2.total_monetary DESC;