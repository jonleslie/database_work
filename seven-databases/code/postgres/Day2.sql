INSERT INTO countries (country_code, country_name)
	VALUES ('uk', 'United Kingdom');

INSERT INTO cities (name, postal_code, country_code)
	VALUES ('Croydon', 'CR0 6TJ', 'gb');

INSERT INTO venues (name, street_address, postal_code, country_code)
	VALUES ('My Place', '21 Leslie Grove', (
		SELECT postal_code
		FROM cities
		WHERE name = 'Croydon'), (
		SELECT country_code
		FROM cities
		WHERE name = 'Croydon')
		);

INSERT INTO events (title, starts, ends, venue_id)
	VALUES ('Zara birthday', '2017-05-25', '2017-05-25 23:59', (
		SELECT venue_id FROM venues
		WHERE name = 'My Place'));

INSERT INTO events (title, starts, ends, venue_id)
	VALUES ('Daryan birthday', '2013-08-07', '2013-08-07 23:59', (
		SELECT venue_id FROM venues
		WHERE name = 'My Place')),
		('Mariam birthday', '1978-01-10', '1978-01-10 23:59', (
			SELECT venue_id FROM venues
			WHERE name = 'My Place')),
		('Jon birthday', '1972-04-09', '1972-04-09 23:59', (
			SELECT venue_id FROM venues
			WHERE name = 'My Place'));

INSERT INTO events (title, starts, ends, venue_id)
	VALUES ('Wedding', '2012-02-26 21:00:00', '2012-02-26 23:00:00', (
		SELECT venue_id FROM venues
		WHERE name = 'Voodoo Donuts')),
	('Dinner with Mom', '2012-02-26 18:00:00', '2012-02-26 20:30:00', (
		SELECT venue_id FROM venues
		WHERE name = 'My Place'));

INSERT INTO events (title, starts, ends, venue_id)
	VALUES ('Valentine''s Day', '2012-02-14', '2012-02-14 23:59:00', NULL);

UPDATE events SET event_id = '10' WHERE event_id = '11';

SELECT count(title)
FROM events
WHERE title LIKE '%Day%';

SELECT min(starts), max(ends)
FROM events INNER JOIN venues
ON events.venue_id = venues.venue_id
WHERE venues.name = 'My Place';

SELECT count(*) FROM events WHERE venue_id = 3;

-- Grouping
SELECT venue_id, count(*)
FROM events
GROUP BY venue_id;

SELECT venue_id, count(*)
FROM events
GROUP BY venue_id
HAVING count(*) >= 2 AND venue_id IS NOT NULL;

SELECT venue_id FROM events GROUP BY venue_id;
SELECT DISTINCT venue_id FROM events;

-- Window functions
SELECT title, venue_id, count(*)
FROM events
GROUP BY venue_id;

SELECT title, count(*)
	OVER (PARTITION BY venue_id) 
	FROM events;

-- Transactions
BEGIN TRANSACTION;
	DELETE FROM events;
ROLLBACK;
SELECT * FROM events;

-- Stored Procedures
SELECT add_event('House Party', '2012-05-03 23:00', 
'2012-05-04 02:00', 'Run''s House', '97205', 'us');

-- Pull the triggers
CREATE TABLE logs (
	event_id integer,
	old_title varchar(255),
	old_starts timestamp,
	old_ends timestamp,
	logged_at timestamp DEFAULT current_timestamp
	);

CREATE TRIGGER log_events
	AFTER UPDATE ON events
	FOR EACH ROW EXECUTE PROCEDURE log_event();

UPDATE events
SET ends = '2012-05-04 01:00:00'
WHERE title = 'House Party';

SELECT event_id, old_title, old_ends, logged_at
FROM logs;

-- Viewing the world
SELECT name, to_char(date, 'Month DD, YYYY') AS date
FROM holidays
WHERE date <= '2012-04-01';

ALTER TABLE events
ADD colors text ARRAY;

UPDATE holidays SET colors = '{"red", "green"}' WHERE name = 'Christmas Day';

-- What RULEs the school?
EXPLAIN VERBOSE
	SELECT *
	FROM holidays;

EXPLAIN VERBOSE
	SELECT event_id AS holiday_id,
		title AS name, starts AS date, colors
	FROM events
	WHERE title LIKE '%Day%' AND venue_id IS NULL;

CREATE RULE update_holidays AS ON UPDATE TO holidays DO INSTEAD
  UPDATE events
  SET title = NEW.name,
      starts = NEW.date,
      colors = NEW.colors
  WHERE title = OLD.name;

CREATE RULE insert_holidays AS ON INSERT TO holidays DO INSTEAD
	INSERT INTO events (title, starts, colors)
	values (NEW.name, NEW.date, NEW.colors);

-- I'll meet you at the crosstab
SELECT extract (year from starts) as year,
	extract(month from starts) as month, count(*)
FROM events
GROUP BY year, month
ORDER BY year, month;

CREATE TEMPORARY TABLE month_count(month INT);
INSERT INTO month_count VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12);

SELECT * FROM crosstab(
	'SELECT extract(year from starts) as year,
		extract(month from starts) as month, count(*)
	FROM events
	GROUP BY year, month
	ORDER BY year',
	'SELECT * FROM month_count'
) AS (
year int, jan int, feb int, mar int, apr int, may int, june int,
jul int, aug int, sep int, oct int, nov int, dec int
);


-- Homework
CREATE RULE delete_venues AS ON DELETE TO venues DO INSTEAD
	UPDATE venues
	SET active = FALSE
	WHERE name = OLD.name;

DELETE FROM venues WHERE name = 'Voodoo Donuts';


SELECT * FROM crosstab(
	'SELECT extract(year from starts) as year,
		extract(month from starts) as month, count(*)
	FROM events
	GROUP BY year, month
	ORDER BY year',
	'SELECT * FROM generate_series(1, 12)'
) AS (
year int, jan int, feb int, mar int, apr int, may int, june int,
jul int, aug int, sep int, oct int, nov int, dec int
);


SELECT * FROM crosstab(
	'SELECT extract(year from starts) as year,
		extract(month from starts) as month, 
		extract(day from starts) as day, count(*)
	FROM events
	GROUP BY year, month, day
	ORDER BY year, month',
	'SELECT * FROM generate_series(1, 7)'
) AS (
year int, month int, Sun int, Mon int, Tue int, Wed int, Thu int, Fri int, Sat int);

-- From Vichheann
SELECT *
FROM crosstab ('SELECT
               EXTRACT(week from starts) AS week,
               EXTRACT(dow from starts) AS day,
               COUNT(*) FROM events GROUP BY week, day ORDER BY week',
               'SELECT generate_series(0,6)')
AS (week int, "Sun" int, "Mon" int, "Tue" int, "Wed" int, "Thu" int, "Fri" int, "Sat" int)
ORDER BY week;
