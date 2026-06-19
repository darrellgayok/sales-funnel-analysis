SELECT COUNT (*) AS total_events
FROM  user_events

SELECT event_type, COUNT(*) AS total_events
FROM user_events
GROUP BY event_type 
ORDER BY total_events DESC;
