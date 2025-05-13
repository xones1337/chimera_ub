#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}⚡ Установка Chimera Userbot в Termux...${NC}"

# Обновление пакетов Termux
pkg update && pkg upgrade -y

# Установка необходимых пакетов
echo -e "${BLUE}⚡ Установка пакетов...${NC}"
pkg install python git mysql-server -y || echo -e "${RED}❌ Ошибка установки пакетов!${NC}"

# Проверяем наличие необходимых инструментов
echo -e "${BLUE}⚡ Проверка зависимостей...${NC}"
if ! command -v git &> /dev/null; then
echo -e "${RED}❌ Git не установлен. Установка...${NC}"
pkg install git -y || { echo -e "${RED}❌ Не удалось установить Git. Прерывание.${NC}"; exit 1; }
fi
if ! command -v python &> /dev/null; then
echo -e "${RED}❌ Python не установлен. Установка...${NC}"
pkg install python -y || { echo -e "${RED}❌ Не удалось установить Python. Прерывание.${NC}"; exit 1; }
fi

# Создание виртуального окружения
echo -e "${BLUE}⚡ Создание виртуального окружения...${NC}"
python3 -m venv venv
source venv/bin/activate

# Добавляем клонирование репозитория
echo -e "${BLUE}⚡ Клонирование репозитория...${NC}"
git clone https://github.com/xones1337/chimera_ub.git temp_repo || echo -e "${RED}❌ Ошибка клонирования!${NC}"

# Копируем все файлы кроме requirements.txt
echo -e "${BLUE}⚡ Копирование файлов...${NC}"
cp -r temp_repo/* . && rm -rf temp_repo
rm -f requirements.txt
mv temp_repo/requirements.txt .

# Устанавливаем зависимости
echo -e "${BLUE}⚡ Установка зависимостей...${NC}"
pip install -r requirements.txt || { echo -e "${RED}❌ Ошибка установки зависимостей. Прерывание.${NC}"; exit 1; }

echo -e "${GREEN}✅ Установка завершена! Запуск бота...${NC}"
python3 bot.py

# Для автозапуска в Termux
echo -e "${BLUE}⚡ Для автозапуска добавьте следующую строку в ~/.profile: python3 /путь/к/bot.py${NC}"
echo "python3 $(pwd)/bot.py" >> ~/.profile
echo -e "${BLUE}⚡ Перезапустите Termux или выполните: source ~/.profile${NC}"