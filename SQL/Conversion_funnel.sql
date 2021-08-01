CREATE TEMPORARY TABLE session_level_made_it_flags
SELECT 
	website_session_id,
    MAX(products_page) AS products_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM (SELECT 
    s.website_session_id,
    p.pageview_url,
    CASE WHEN p.pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
    CASE WHEN p.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
    CASE WHEN p.pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN p.pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN p.pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN p.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM
    website_sessions s
    LEFT JOIN
    website_pageviews p ON s.website_session_id=p.website_session_id
WHERE   
	s.created_at > '2012-08-05'
	AND s.created_at < '2012-09-05'
    AND s.utm_source='gsearch'
    AND s.utm_campaign='nonbrand'

ORDER BY
		s.website_session_id,
		p.created_at) AS pageview_level
        
GROUP BY
 website_session_id;
 
SELECT
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN products_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM
	session_level_made_it_flags;
    
SELECT
    COUNT(DISTINCT CASE WHEN products_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS products_click_rt,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN products_made_it = 1 THEN website_session_id ELSE NULL END) AS mrfuzzy_click_rt,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_click_rt,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_click_rt,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_click_rt,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS thankyou_click_rt
FROM
	session_level_made_it_flags;
    