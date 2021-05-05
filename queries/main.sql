WITH distinct_orders AS (
    SELECT DISTINCT number,
                    DATE(date) AS date
    FROM orders
),

weekly_orders AS (
    SELECT
           DATE(date, '1 DAYS', 'WEEKDAY 1', '-7 DAYS') as week,
           COUNT(*) AS num_orders
    FROM distinct_orders
    GROUP BY week
),

recent_7_day_orders AS (
    SELECT
           orders.week,
           COUNT(recent_orders.number) AS order_count
    FROM weekly_orders orders
    JOIN distinct_orders recent_orders
        ON recent_orders.date < orders.week
        AND recent_orders.date >= DATE(orders.week, '-7 DAYS')
    GROUP BY orders.week
),

recent_30_day_orders AS (
    SELECT
        orders.week,
        COUNT(recent_orders.number) AS order_count
    FROM weekly_orders orders
    JOIN distinct_orders recent_orders
        ON recent_orders.date < orders.week
        AND recent_orders.date >= DATE(orders.week, '-30 DAYS')
    GROUP BY orders.week
),

labels AS (
    SELECT
        orders.week,
        COUNT(label_orders.number) as order_count
    FROM weekly_orders orders
    JOIN distinct_orders label_orders
        ON label_orders.date >= orders.week
        AND label_orders.date < DATE(orders.week, '7 DAYS')
    GROUP BY orders.week
)

SELECT
    orders.week,
    COALESCE(recent_7_day_orders.order_count, 0) AS order_count_7_day,
    COALESCE(recent_30_day_orders.order_count, 0) AS order_count_30_day,
    COALESCE(labels.order_count, 0) AS label
FROM weekly_orders orders
    LEFT JOIN  recent_7_day_orders
        ON recent_7_day_orders.week = orders.week
    LEFT JOIN recent_30_day_orders
        ON recent_30_day_orders.week = orders.week
    LEFT JOIN labels
        ON labels.week = orders.week
WHERE  orders.week >= '2016-01-01'



