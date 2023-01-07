#!/bin/bash
set -e
export PGPASSWORD=$POSTGRES_PASSWORD;

inventory_number_pref_list=("VAC" "MOC" "BUK" "CLO" "DUS" "POL")

for i in {1..100}
do
inventory_number="${inventory_number_pref_list[$RANDOM % ${#inventory_number_pref_list[@]}]}-$(printf %05d $i)"
name_list=("Vacuum" "Cheap Auburn Vacuum" "Ugly Pink Vacuum" "Fancy Mop" "Galvanized steel bucket" "Worn Cyan Cloth" "Cheap Orange Dustpan" "Cheap Auburn Polisher")
name=${name_list[$RANDOM % ${#name_list[@]}]}
price=$(( ( RANDOM % 90 ) + 10 ))
comment_list=("DEFAULT" "This vacuum is auburn" "This Acuum is pink and ugly" "I like this mop!" "This bucket is very strong" "This cloth is cyan and worn" "The Dustpan is orange" "This Polisher is auburn")
comment=${comment_list[$RANDOM % ${#comment_list[@]}]}
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
\connect $APP_DB_NAME $APP_DB_USER
INSERT
INTO inventory (inventory_number, name, price, comment)
VALUES ('$inventory_number', '$name', '$price', '$comment');
EOSQL
done;

echo "Data successfully inserted into table $table_name in database $db_name."

