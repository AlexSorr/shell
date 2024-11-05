#!/bin/bash

select_directory() {
    # тип каталога - какую папку выбираем
    local directory_type=$1

    read -e -p "Enter directory path ($directory_type): " directory_path

    while [ ! -d "$directory_path" ]; do

        if [ "$directory_path" = 'q' ]; then
            # обнуляем строку в которую писался мусор
            directory_path=""
            # пользователь вышел
            return 1
        else
            echo "Incorrect $directory_type directory path" >&2
            read -e -p "Enter correct path or 'q' to quit: " directory_path
        fi
        
    done

    echo "$directory_path"
    return 0
}

selected_path=$(select_directory "obsidian")
echo $selected_path