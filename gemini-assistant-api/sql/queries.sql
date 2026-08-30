-- View all sources
SELECT *
FROM sources;

-- View local information and its source IDs
SELECT
    id,
    title,
    information_type,
    source_id
FROM local_information;

-- View upcoming events
SELECT
    id,
    title,
    start_date,
    end_date,
    location,
    source_id
FROM community_events
WHERE end_date >= date('now')
ORDER BY start_date ASC;