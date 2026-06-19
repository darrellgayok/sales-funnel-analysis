WITH funnel_revenue AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS total_buyers,
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_orders,
        SUM(CASE WHEN event_type = 'purchase' THEN CAST(amount AS REAL) END) AS total_revenue
    FROM user_events
    WHERE datetime(event_date) >= datetime((SELECT MAX(event_date) FROM user_events), '-30 days')
)

SELECT
    total_visitors,
    total_buyers,
    total_orders,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(total_revenue / total_orders, 2) AS avg_order_value,
    ROUND(total_revenue / total_buyers, 2) AS revenue_per_buyer,
    ROUND(total_revenue / total_visitors, 2) AS revenue_per_visitor
FROM funnel_revenue;