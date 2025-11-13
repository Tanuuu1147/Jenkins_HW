#!/bin/bash

# Скрипт для остановки всей системы

echo "Остановка всей системы..."

# Остановка Jenkins
echo "1. Остановка Jenkins..."
./stop_jenkins.sh

# Остановка Selenoid
echo "2. Остановка Selenoid..."
docker-compose -f docker-compose.selenoid.yml down

echo "Вся система остановлена"