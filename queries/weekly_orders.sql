WITH distinct_orders AS (
    SELECT DISTINCT number,
                    DATE(date) AS date
    FROM orders
)

SELECT
    DATE(date, '1 DAYS', 'WEEKDAY 1', '-7 DAYS') as week,
    COUNT(*) AS num_orders
FROM distinct_orders
GROUP BY week
ORDER BY week