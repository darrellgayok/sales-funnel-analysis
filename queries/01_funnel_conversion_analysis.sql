SELECT * FROM user_events ue LIMIT 1000

WITH funnel_stages AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
        COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
        COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase
    FROM user_events
    WHERE datetime(event_date) >= datetime((SELECT MAX(event_date) FROM user_events),'-30 days'))

SELECT
    *,
    ROUND(stage_2_cart * 100.0 / stage_1_views, 2) AS view_to_cart_rate,
    ROUND(stage_3_checkout * 100.0 / stage_2_cart, 2) AS cart_to_checkout_rate,
    ROUND(stage_4_payment * 100.0 / stage_3_checkout, 2) AS checkout_to_payment_rate,
    ROUND(stage_5_purchase * 100.0 / stage_4_payment, 2) AS payment_to_purchase_rate
FROM funnel_stages;