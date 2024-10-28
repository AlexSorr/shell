#!/bin/bash

# Имя скрипта и пути
SCRIPT_NAME="obsidian_backup"
SCRIPT_SOURCE="./$SCRIPT_NAME"
INSTALL_DIR="$HOME/bin"
ZSHRC="$HOME/.zshrc"

# Проверка зависимостей
DEPENDENCIES=("zenity")

for dep in "${DEPENDENCIES[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
        echo "Утилита $dep не установлена."
        read -p "Хотите установить $dep? (y/n): " answer
        if [[ "$answer" == "y" ]]; then
            if command -v brew &> /dev/null; then
                echo "Устанавливаю $dep через Homebrew..."
                brew install "$dep"
            else
                echo "Homebrew не найден. Установите $dep вручную."
                exit 1
            fi
        else
            echo "Установка прервана. $dep необходим для работы скрипта."
            exit 1
        fi
    fi
done

# Создание каталога $HOME/bin, если его нет
mkdir -p "$INSTALL_DIR"

# Копирование скрипта в $HOME/bin
cp "$SCRIPT_SOURCE" "$INSTALL_DIR"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo "$SCRIPT_NAME скопирован в $INSTALL_DIR."

# Добавление команды в .zshrc, если ее там нет
if ! grep -q "$INSTALL_DIR/$SCRIPT_NAME" "$ZSHRC"; then
    echo "Добавляю команду в $ZSHRC для вызова $SCRIPT_NAME..."
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$ZSHRC"
    echo "alias $SCRIPT_NAME=\"$INSTALL_DIR/$SCRIPT_NAME\"" >> "$ZSHRC"
    echo "Команда для вызова добавлена в $ZSHRC. Перезапустите терминал или выполните 'source ~/.zshrc'."
else
    echo "Команда для вызова уже добавлена в $ZSHRC."
fi

echo "Установка завершена."
