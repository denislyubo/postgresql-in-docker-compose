#!/bin/bash
set -e
export PGPASSWORD=$POSTGRES_PASSWORD;
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';
  CREATE DATABASE $APP_DB_NAME;
  GRANT ALL PRIVILEGES ON DATABASE $APP_DB_NAME TO $APP_DB_USER;
  \connect $APP_DB_NAME $APP_DB_USER

  BEGIN;

  CREATE TABLE IF NOT EXISTS inventory (
          inventory_number VARCHAR(100) NOT NULL PRIMARY KEY,
          name VARCHAR(200) NOT NULL,
          price NUMERIC(12,2) NOT NULL,
          comment VARCHAR(200)
      );

  CREATE TABLE service (
    service_id BIGSERIAL NOT NULL PRIMARY KEY,
    inventory_number VARCHAR(100) NOT NULL REFERENCES inventory,
    service_date DATE NOT NULL,
    comment VARCHAR(200) NOT NULL
  );

  CREATE TABLE IF NOT EXISTS staff (
      staff_id BIGSERIAL NOT NULL PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      title VARCHAR(100) NOT NULL,
      reports_to BIGINT
    );

  CREATE TABLE IF NOT EXISTS staff_inventory (
    staff_id BIGINT NOT NULL REFERENCES staff,
    inventory_number VARCHAR(100) NOT NULL REFERENCES inventory,
    PRIMARY KEY (staff_id, inventory_number),
    UNIQUE(inventory_number, staff_id)
  );

  COMMIT;

EOSQL