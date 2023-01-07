#!/bin/bash
set -e
export PGPASSWORD=$POSTGRES_PASSWORD;
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
\connect $APP_DB_NAME $APP_DB_USER

BEGIN;

INSERT
INTO staff(name, title, reports_to)
VALUES
('Elsie', 'Manager', DEFAULT),
('Donnie', 'Supervisor', 1),
('Ashley', 'Supervisor', 1),
('Alec', 'Janitor', 2),
('Barbara', 'Janitor', 2),
('Shawn', 'Janitor', 2),
('Desmond', 'Janitor', 3),
('Claire', 'Janitor', 3),
('Robin', 'Janitor', 3),
('Alice', 'Technician', 1);

COMMIT;

EOSQL