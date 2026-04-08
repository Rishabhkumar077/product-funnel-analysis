-- Funnel Stage Count
SELECT event, COUNT(DISTINCT user_id) AS users
FROM events
GROUP BY event;

-- Conversion Rate (Visit → Purchase)
SELECT 
  COUNT(DISTINCT CASE WHEN event = 'purchase' THEN user_id END) * 1.0 /
  COUNT(DISTINCT CASE WHEN event = 'visit' THEN user_id END) 
AS conversion_rate
FROM events;

-- Drop-off Analysis
SELECT 
  event,
  COUNT(DISTINCT user_id) AS users
FROM events
GROUP BY event
ORDER BY users DESC;

-- Step-wise Funnel Conversion
WITH funnel AS (
  SELECT 
    user_id,
    MAX(CASE WHEN event = 'visit' THEN 1 ELSE 0 END) AS visit,
    MAX(CASE WHEN event = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart,
    MAX(CASE WHEN event = 'purchase' THEN 1 ELSE 0 END) AS purchase
  FROM events
  GROUP BY user_id
)
SELECT 
  COUNT(*) AS total_users,
  SUM(add_to_cart) * 1.0 / SUM(visit) AS visit_to_cart_rate,
  SUM(purchase) * 1.0 / SUM(add_to_cart) AS cart_to_purchase_rate
FROM funnel;
