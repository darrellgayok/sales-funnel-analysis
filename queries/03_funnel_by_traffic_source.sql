WITH source_funnel AS (
    SELECT
        traffic_source,
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS carts,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchases
    FROM user_events
    WHERE datetime(event_date) >= datetime((SELECT MAX(event_date) FROM user_events),'-30 days')
    GROUP BY traffic_source
)

SELECT
	traffic_source,
	views,
	carts,
	purchases,
	ROUND (carts * 100 / views) AS cart_conversion_rate,
	ROUND (purchases * 100 / views) AS purchase_conversion_rate,
	ROUND (purchases * 100 / carts, 1) AS cart_to_purchase_conversion_rate

FROM source_funnel;
ORDER BY purchases DESC

