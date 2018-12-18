CREATE TABLE countries (
    country_code char(2) PRIMARY KEY,
    country_name text UNIQUE
);

INSERT INTO countries (country_code, country_name)
VALUES ('us', 'United States'), ('mx', 'Mexico'), ('au', 'Australia'), 
('gb', 'United Kingdom'), ('de', 'Germany'), ('ll', 'Loompalan');

DELETE FROM countries
WHERE country_code = 'll';

CREATE TABLE cities (
    name text NOT NULL,
    postal_code varchar(9) CHECK (postal_code <> ''),
    country_code char(2) REFERENCES countries,
    PRIMARY KEY (country_code, postal_code)
);

INSERT INTO cities
VALUES ('Toronto', 'M4C1B5', 'ca');

INSERT INTO cities
VALUES ('Portland', '87200', 'us');

UPDATE cities
SET postal_code = '97205'
WHERE name = 'Portland';

SELECT cities.*, country_name
FROM cities INNER JOIN countries
ON cities.country_code = countries.country_code;

CREATE TABLE venues (
    venue_id SERIAL PRIMARY KEY,
    name varchar(225),
    street_address text,
     type char(7) CHECK ( type in ('public', 'private') ) DEFAULT 'public',
    postal_code varchar (9),
    country_code char(2),
    FOREIGN KEY (country_code, postal_code)
        REFERENCES cities (country_code, postal_code) MATCH FULL
);

INSERT INTO venues (name, postal_code, country_code)
VALUES ('Crystal Ballroom', '97205', 'us');

SELECT v.venue_id, v.name, c.name
FROM venues v INNER JOIN cities c
ON v.postal_code=c.postal_code and v.country_code=c.country_code;

INSERT INTO venues (name, postal_code, country_code)
VALUES ('Voodoo Donuts', '97205', 'us') RETURNING venue_id;

CREATE TABLE events (
    event_id SERIAL PRIMARY KEY,
    title text,
    starts timestamp,
    ends timestamp,
    venue_id int REFERENCES venues
);


INSERT INTO events (title, starts, ends, venue_id)
VALUES ('LARP Club', '2012-02-15 17:30:00', '2012-02-15 19:30:00', '2');

INSERT INTO events (title, starts, ends)
VALUES ('April Fools Day', '2012-04-01', '2012-04-01 23:59:00');

INSERT INTO events (title, starts, ends)
VALUES ('Christmas Day', '2012-12-25', '2012-12-25 23:59');


SELECT e.title, v.name
FROM events e JOIN venues v
ON e.venue_id = v.venue_id;

SELECT e.title, v.name
FROM events e LEFT JOIN venues v
on e.venue_id = v.venue_id;

CREATE INDEX events_title
ON events USING hash (title);

SELECT *
FROM events
WHERE starts >= '2012-04-01';

CREATE INDEX events_starts
ON events USING btree (starts);

-- Day 1 Homework
SELECT * FROM pg_tables t
WHERE t.tableowner = current_user;

SELECT e.title, v.country_code, c.country_name
FROM events e INNER JOIN venues v
    ON e.venue_id = v.venue_id
INNER JOIN countries c
    ON v.country_code = c.country_code;

ALTER TABLE venues ADD COLUMN active BOOLEAN DEFAULT TRUE;
