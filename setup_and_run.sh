#!/bin/bash

# Финальный скрипт для настройки и запуска всей системы

echo "=========================================="
echo "Настройка и запуск Jenkins с автотестами"
echo "=========================================="

# Проверка наличия Docker
echo "1. Проверка Docker..."
if ! command -v docker &> /dev/null
then
    echo "Docker не установлен. Пожалуйста, установите Docker и повторите попытку."
    exit 1
fi

if ! command -v docker-compose &> /dev/null
then
    echo "docker-compose не установлен. Пожалуйста, установите docker-compose и повторите попытку."
    exit 1
fi

echo "Docker и docker-compose установлены"

# Проверка наличия Python и pip
echo "2. Проверка Python и pip..."
if ! command -v python3 &> /dev/null
then
    echo "Python3 не установлен. Пожалуйста, установите Python3 и повторите попытку."
    exit 1
fi

if ! command -v pip3 &> /dev/null
then
    echo "pip3 не установлен. Пожалуйста, установите pip3 и повторите попытку."
    exit 1
fi

echo "Python3 и pip3 установлены"

# Установка зависимостей Python
echo "3. Установка зависимостей Python..."
pip3 install -r requirements.txt

# Запуск Selenoid
echo "4. Запуск Selenoid..."
docker-compose -f docker-compose.selenoid.yml up -d

# Ожидание запуска Selenoid
echo "Ожидание запуска Selenoid..."
sleep 10

# Проверка статуса Selenoid
if docker ps | grep -q selenoid; then
    echo "Selenoid успешно запущен"
else
    echo "Ошибка запуска Selenoid"
    exit 1
fi

# Установка плагинов Jenkins (если нужно)
echo "5. Проверка плагинов Jenkins..."
./check_allure.sh | grep "НЕ установлен" > /dev/null
if [ $? -eq 0 ]; then
    echo "Некоторые плагины не установлены. Запуск установки..."
    ./install_plugins.sh
else
    echo "Все плагины установлены"
fi

# Запуск Jenkins
echo "6. Запуск Jenkins..."
./start_jenkins.sh

# Ожидание запуска Jenkins
echo "Ожидание запуска Jenkins..."
sleep 30

# Получение пароля администратора
echo "7. Пароль администратора Jenkins:"
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

# Инструкции для пользователя
echo "=========================================="
echo "Система успешно настроена и запущена!"
echo "=========================================="
echo ""
echo "Дальнейшие действия:"
echo "1. Откройте Jenkins в браузере: http://localhost:8083"
echo "2. Введите пароль администратора выше"
echo "3. Следуйте инструкциям установщика Jenkins"
echo "4. Создайте Pipeline job, указав путь к Jenkinsfile"
echo "5. Запустите job и проверьте результаты"
echo ""
echo "Для остановки системы выполните:"
echo "./stop_all.sh"