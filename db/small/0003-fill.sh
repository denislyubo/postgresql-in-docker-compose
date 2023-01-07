#!/bin/bash
set -e
export PGPASSWORD=$POSTGRES_PASSWORD;
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
\connect $APP_DB_NAME $APP_DB_USER

BEGIN;

INSERT
INTO inventory(inventory_number, name, price, comment)
VALUES ('VAC-0001', 'Vacuum', 50.00, DEFAULT),
('MOP-0001', 'Fancy Mop', 15.00, 'I like this mop'),
('BUC-0001', 'Galvanized steel bucket', 15.00, 'This bucket is very strong');

INSERT
INTO service(inventory_number, service_date, comment)
VALUES ('VAC-0001', '2021-01-03', 'Eddie from The World Of Vacuums replaced the turbo brush'),
('VAC-0001', '2021-01-04', 'Donnie from The Vacuum Emporium cleaned the motor'),
('MOP-0001', '2021-01-03', 'Elsie went to Walmart and bought a replacement handle');

COMMIT;

EOSQL