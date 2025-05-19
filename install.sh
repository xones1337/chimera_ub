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

# Добавление бота в автозагрузку для одной сессии
AUTOSTART_SCRIPT="$HOME/.autorun_once.sh"
BASHRC="$HOME/.bashrc"

# Добавляем код для одноразового запуска в .bashrc
if ! grep -q "autorun_once.sh" "$BASHRC"; then
    echo -e '\n# Запуск бота только при первой сессии' >> "$BASHRC"
    echo 'if [ -f ~/.autorun_once.sh ]; then' >> "$BASHRC"
    echo '    bash ~/.autorun_once.sh' >> "$BASHRC"
    echo '    rm -f ~/.autorun_once.sh' >> "$BASHRC"
    echo 'fi' >> "$BASHRC"
fi

# Создаем скрипт автозапуска
if [ ! -f "$AUTOSTART_SCRIPT" ]; then
    echo "cd $(pwd) && python bot.py" > "$AUTOSTART_SCRIPT"
    chmod +x "$AUTOSTART_SCRIPT"
    echo "⚡ Бот добавлен в автозагрузку. Запустится при следующем старте Termux."
else
    echo "⚠️ Автозагрузка уже активирована. Бот запустится при следующем старте."
fi

echo "⚡ Установка завершена!"