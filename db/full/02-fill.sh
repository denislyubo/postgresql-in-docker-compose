#!/bin/bash
set -e
export PGPASSWORD=$POSTGRES_PASSWORD;

insert_stmt="INSERT INTO inventory VALUES"

inventory_number_pref_list=("VAC" "MOC" "BUK" "CLO" "DUS" "POL")
name_list=("Vacuum" "Cheap Auburn Vacuum" "Ugly Pink Vacuum" "Fancy Mop" "Galvanized steel bucket" "Worn Cyan Cloth" "Cheap Orange Dustpan" "Cheap Auburn Polisher")
comment_list=("DEFAULT" "This vacuum is auburn" "This Acuum is pink and ugly" "I like this mop!" "This bucket is very strong" "This cloth is cyan and worn" "The Dustpan is orange" "This Polisher is auburn")

for i in {1..100}
do
inventory_number="${inventory_number_pref_list[$RANDOM % ${#inventory_number_pref_list[@]}]}-$(printf %05d $i)"
name=${name_list[$RANDOM % ${#name_list[@]}]}
price=$(( ( RANDOM % 90 ) + 10 ))
comment=${comment_list[$RANDOM % ${#comment_list[@]}]}

insert_stmt+="('$inventory_number', '$name', $price, '$comment'),"
done;
insert_stmt=${insert_stmt::-1}

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
\connect $APP_DB_NAME $APP_DB_USER
$insert_stmt
EOSQL

echo "Data successfully inserted into table $table_name in database $db_name."

