SELECT
    UserID,
    count() AS page_views
FROM homework.metrika
GROUP BY UserID
ORDER BY page_views DESC
LIMIT 1;
