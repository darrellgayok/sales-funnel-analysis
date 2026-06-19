WITH user_journey AS (
    SELECT
        user_id,
        MIN(CASE WHEN event_type = 'page_view' THEN event_date END) AS view_time,
        MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
        MIN(CASE WHEN event_type = 'purchase' THEN event_date END) AS purchase_time
    FROM user_events
    WHERE datetime(event_date) >= datetime((SELECT MAX(event_date) FROM user_events), '-30 days')
    GROUP BY user_id
    HAVING
        view_time IS NOT NULL
        AND cart_time IS NOT NULL
        AND purchase_time IS NOT NULL
)

SELECT
    COUNT(*) AS converted_users,
    ROUND(AVG((julianday(cart_time) - julianday(view_time)) * 24 * 60), 2) AS avg_view_to_cart_minutes,
    ROUND(AVG((julianday(purchase_time) - julianday(cart_time)) * 24 * 60), 2) AS avg_cart_to_purchase_minutes,
    ROUND(AVG((julianday(purchase_time) - julianday(view_time)) * 24 * 60), 2) AS avg_total_journey_minutes
FROM user_journey;