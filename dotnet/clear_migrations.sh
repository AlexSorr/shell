#!/bin/bash
migrations_path="$PWD"/Migrations

# Проверка наличия папки Migrations
if [ ! -d "$migration_path" ]; then
    echo "No migrations folder found"
    exit 0
fi
    
# Подсчёт количества видимых элементов в папке
count=$(find ./Migrations -maxdepth 1 -type f | grep -v "/\." | wc -l)

echo -e "Path: $migration_path\nElements count:$count"

if [ $count -le 0 ]; then
    echo "No migrations found"
    exit 0
fi

read -p "Continue (y/n): " choice

if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
    echo "Abort"
    exit 0
fi

echo "Deleting migrations"

rm -rvf "$migrations_path"/*

echo "Done"