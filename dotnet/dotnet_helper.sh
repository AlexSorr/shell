#!/bin/bash
# Хелпер для разработки на dotnet

# Запаковать старые логи
# al - archive logs
function al() {
    echo "Start logging archivation..."

    today=$(date +"%Y%m%d")
    archive_name="logs.zip"

    # Путь к каталогу с логами
    log_dir="$PWD/Logs"

    if [ ! -d "$log_dir" ]; then
        echo "No log directiory fount: $log_dir"
        exit 1
    fi

    # Перемещаемся в каталог с логами
    cd "$log_dir" || exit 1

    # Добавляем в архив все файлы, не относящиеся к сегодняшней дате
    for file in api_log*.txt; do
        # Проверяем, если файл не содержит сегодняшнюю дату - добавляем в архив
        if [[ $file != *"$today"* ]]; then
            zip -u "$archive_name" "$file"
            rm "$file"
        fi
    done

    echo "Done"
}

# Удалить старые миграции
# dm - drop migrations
function dm() {
    echo "Starting removing migrations..."

    migrations_path="$PWD"/Migrations

    # Проверка наличия папки Migrations
    if [ ! -d "$migrations_path" ]; then
        echo "No migrations folder found"
        exit 0
    fi
        
    # Подсчёт количества видимых элементов в папке
    count=$(find ./Migrations -maxdepth 1 -type f | grep -v "/\." | wc -l)

    echo -e "Path: $migrations_path\nElements count:$count"

    if [ $count -le 0 ]; then
        echo "No migrations found"
        exit 0
    fi

    read -p "Continue (y/n): " choice

    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        echo "Abort"
        exit 0
    fi

    echo "Deleting migrations..."

    rm -rvf "$migrations_path"/*

    echo "Done"
}

# Создать новые миграции и обновить БД
# ud - update database
function ud() {
    echo "Database updating started..."

    migration_path=$PWD/Migrations

    if [ ! -d "$migration_path" ]; then 
        echo -n "Migrations directory not found"
        exit 1
    fi

    migration_name="migration-$(date +'%Y-%m-%d_%H-%M-%S')"
    echo -n "Creating migration $migration_name" 

    # Добавить миграцию, обновить БД
    dotnet ef migrations add "$migration_name" > /dev/null

    if [ $? -ne 0 ]; then
        echo "Creating migration error, abort"
        exit 1
    fi

    dotnet ef database update
}

if [[ -z "$1" ]]; then
    echo "No commands found $1"
    exit 1
fi

# Выбор команды в зависимости от аргумента
case "$1" in
    -al)
        al
        ;;
    -dm)
        dm
        ;;
    -ud)
        ud
        ;;
    *)
        echo "No commands found $1"
        exit 1
        ;;
esac
