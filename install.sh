#!/bin/bash

set -e

echo "⚡ Начинаем установку..."

# Функция для установки пакетов
install_package() {
    if ! command -v "$1" &> /dev/null; then
        echo "$1 не найден. Устанавливаем..."
        pkg install -y "$1"
    else
        echo "$1 уже установлен."
    fi
}

# Установка необходимых инструментов
install_package python
install_package python-pip
install_package git
install_package rust

# Удаление предыдущей версии проекта, если она существует
if [ -d "chimera_ub" ]; then
    rm -rf "chimera_ub"
fi

# Клонирование репозитория
git clone https://github.com/xones1337/chimera_ub.git temp_dir
mv temp_dir/* ./
rm -rf temp_dir

# Установка зависимостей из requirements.txt
if [ -f "requirements.txt" ]; then
    echo "Проверяем и устанавливаем зависимости..."
    while read -r package; do
        if ! pip show "$package" > /dev/null 2>&1; then
            echo "Устанавливаем $package..."
            pip install "$package"
        else
            echo "$package уже установлен."
        fi
    done < requirements.txt
else
    echo "Файл requirements.txt не найден. Устанавливаем основные зависимости..."
    pip install telethon deep_translator mysql-connector-python requests asyncio logging pycryptodome
fi

# Добавление команды для запуска бота в .bashrc
BASHRC="$HOME/.bashrc"
if ! grep -q "python bot.py" "$BASHRC"; then
    echo -e '\n# Автозапуск бота' >> "$BASHRC"
    echo "cd $(pwd) && python bot.py" >> "$BASHRC"
    echo "⚡ Бот добавлен в автозагрузку и запустится при следующем запуске"
fi

echo "⚡ Установка завершена!"