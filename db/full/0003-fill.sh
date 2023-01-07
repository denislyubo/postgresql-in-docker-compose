#!/bin/bash
set -e
export PGPASSWORD=$POSTGRES_PASSWORD;

TABLE_NAME=inventory

inventory_insert_stmt="INSERT INTO inventory VALUES"
service_insert_stmt="INSERT INTO service(inventory_number, service_date, comment) VALUES"
staff_inventory_stmt="INSERT INTO staff_inventory(inventory_number, staff_id) VALUES"

inventory_number_pref_list=("VAC" "MOC" "BUK" "CLO" "DUS" "POL" "BRO")
name_list=("Vacuum" "Cheap Auburn Vacuum" "Ugly Pink Vacuum" "Fancy Mop" "Galvanized steel bucket" "Worn Cyan Cloth" "Cheap Orange Dustpan" "Cheap Auburn Polisher")
comment_list=("" "This vacuum is auburn" "This Acuum is pink and ugly" "I like this mop!" "This bucket is very strong" "This cloth is cyan and worn" "The Dustpan is orange" "This Polisher is auburn")
date_list=("2021-01-03" "2021-01-04" "2021-01-03")
service_comment_list=("Eddie from The World Of Vacuums replaced the turbo brush" "Donnie from The Vacuum Emporium cleaned the motor" "Elsie went to Walmart and bought a replacement handle")

for i in {1..100}
do

inventory_number="${inventory_number_pref_list[$RANDOM % ${#inventory_number_pref_list[@]}]}-$(printf %05d $i)"
name=${name_list[$RANDOM % ${#name_list[@]}]}
price=$(( ( RANDOM % 90 ) + 10 ))
comment=${comment_list[$RANDOM % ${#comment_list[@]}]}
staff_id=$((1+(RANDOM % 3)))

inventory_insert_stmt+="('$inventory_number', '$name', $price, '$comment'),"

up=$(( $(shuf -i 0-32000 -n 1)%3 + 1))
echo "UP ------> $up"
for k in 1..$(seq $up)
do
  date=${date_list[$RANDOM % ${#date_list[@]}]}
  service_comment=${service_comment_list[$RANDOM % ${#service_comment_list[@]}]}
  service_insert_stmt+="('$inventory_number', '$date', '$service_comment'),"
done;

staff_inventory_stmt+="('$inventory_number', $staff_id),"
done;

inventory_insert_stmt=${inventory_insert_stmt::-1}
service_insert_stmt=${service_insert_stmt::-1}
staff_inventory_stmt=${staff_inventory_stmt::-1}

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
\connect $APP_DB_NAME $APP_DB_USER
BEGIN;
$inventory_insert_stmt;
$service_insert_stmt;
$staff_inventory_stmt;
COMMIT;
EOSQL

