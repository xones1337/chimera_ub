#!/bin/bash

set -e

echo "⚡ Начинаем установку..."

if ! command -v python &> /dev/null; then
    echo "Python не найден. Устанавливаем..."
    pkg install python
fi

if ! command -v pip &> /dev/null; then
    pkg install python-pip
fi

if ! command -v git &> /dev/null; then
    pkg install git
fi

git clone https://github.com/xones1337/chimera_ub .

if [ -f "requirements.txt" ]; then
    echo "Устанавливаем зависимости глобально..."
    pip install -r requirements.txt
else
    echo "Файл requirements.txt не найден. Устанавливаем основные зависимости глобально..."
    pip install telethon deep_translator mysql-connector-python requests
fi

echo "python bot.py &" >> ~/.bashrc
echo "⚡ Бот добавлен в автозагрузку. Запуск..."
python bot.py &