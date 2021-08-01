CREATE TEMPORARY TABLE first_pv_1
SELECT 
    p.website_session_id, MIN(website_pageview_id) AS min_pageview_id
FROM
    website_pageviews p
    INNER JOIN
    website_sessions s
    ON p.website_session_id=s.website_session_id
    AND p.created_at > '2012-06-19' 
    AND p.created_at <'2012-07-28' 
    AND s.utm_source ='gsearch' 
    AND s.utm_campaign ='nonbrand'
GROUP BY p.website_session_id;

CREATE TEMPORARY TABLE landing_page_1
SELECT 
	w.pageview_url AS landing_page,
    f.website_session_id
FROM 
	first_pv_1 f 
	LEFT JOIN 
    website_pageviews w ON f.min_pageview_id = w.website_pageview_id
WHERE w.pageview_url IN ('/home','/lander-1');

CREATE TEMPORARY TABLE bounced_sessions_1
SELECT
	l.website_session_id,
    l.landing_page,
    COUNT(w.website_pageview_id) AS pages_viewed
FROM
	landing_page_1 l
    LEFT JOIN
    website_pageviews w ON l.website_session_id=w.website_session_id
GROUP BY
	l.website_session_id,
    l.landing_page
HAVING
	pages_viewed = 1;
    
SELECT
	l.landing_page,
	COUNT(DISTINCT l.website_session_id) AS sessions,
    COUNT(DISTINCT b.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT b.website_session_id)/COUNT(DISTINCT l.website_session_id) AS bounce_rate
FROM
	landing_page_1 l
    LEFT JOIN
    bounced_sessions_1 b ON l.website_session_id=b.website_session_id
GROUP BY
 l.landing_page
ORDER BY
	l.website_session_id;