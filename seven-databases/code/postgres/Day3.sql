SELECT title FROM movies WHERE title ILIKE 'stardust%';

SELECT title FROM movies WHERE title ILIKE 'stardust_%';

SELECT COUNT(*) FROM movies WHERE title !~* '^the.*';

CREATE INDEX movies_title_pattern ON movies (lower(title) text_pattern_ops);

SELECT levenshtein('bat', 'fads');

SELECT levenshtein('bat', 'fad') fad,
levenshtein('bat', 'fat') fat,
levenshtein('bat', 'bat');

SELECT movie_id, title FROM movies
WHERE levenshtein(lower(title), lower('a hard day nght')) <= 3;

SELECT show_trgm('Avatar');

CREATE INDEX movies_title_trigram ON movies
USING gist (title gist_trgm_ops);

SELECT title
FROM movies
WHERE title % 'Avatre';

-- Full-text fun
SELECT title
FROM movies
WHERE title @@ 'night & day';

SELECT to_tsvector('A Hard Day''s Night'), to_tsquery('english', 'night & day');

