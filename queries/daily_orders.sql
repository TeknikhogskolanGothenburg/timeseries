WITH distinct_orders AS (
    SELECT DISTINCT number,
                    DATE(date) AS date
    FROM orders
)

SELECT
    date,
    COUNT(*) AS num_orders
FROM distinct_orders
GROUP BY date
ORDER BY date