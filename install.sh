#!/bin/bash

set -e

echo "⚡ Начинаем установку..."

if ! command -v python &> /dev/null; then
    echo "Python не найден. Устанавливаем..."
    pkg install -y python
fi

if ! command -v pip &> /dev/null; then
    echo "pip не найден. Устанавливаем..."
    pkg install -y python-pip
fi

if ! command -v git &> /dev/null; then
    echo "git не найден. Устанавливаем..."
    pkg install -y git
fi

if ! command -v rustc &> /dev/null; then
    echo "Rust не найден. Устанавливаем..."
    pkg install -y rust
fi

if [ -d "chimera_ub" ]; then
  rm -rf "chimera_ub"
fi

git clone https://github.com/xones1337/chimera_ub.git temp_dir
mv temp_dir/* ./
rm -rf temp_dir

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
    pip install telethon deep_translator mysql-connector-python requests pycryptdome
fi

if ! grep -q "python bot.py" ~/.bashrc; then
    echo "python bot.py" >> ~/.bashrc
    echo "⚡ Бот добавлен в автозагрузку. Запустите его вручную командой: python bot.py"
fi