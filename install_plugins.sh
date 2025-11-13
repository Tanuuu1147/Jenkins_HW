#!/bin/bash

# Скрипт для установки плагинов Jenkins в случае проблем с SSL

echo "Установка плагинов Jenkins..."

# Останавливаем Jenkins если он запущен
echo "Остановка Jenkins..."
./stop_jenkins.sh

# Создаем директорию для плагинов если её нет
mkdir -p /Users/tanuuu/Jenkins_HW/jenkins_home/plugins

# Скачиваем плагины
echo "Скачивание плагинов..."
cd /Users/tanuuu/Jenkins_HW/jenkins_home/plugins

# Скачиваем Allure Jenkins Plugin
curl -L -O https://updates.jenkins.io/latest/allure-jenkins-plugin.hpi

# Скачиваем HTML Publisher Plugin
curl -L -O https://updates.jenkins.io/latest/htmlpublisher.hpi

# Скачиваем Git Plugin
curl -L -O https://updates.jenkins.io/latest/git.hpi

# Переименовываем файлы в .jpi
mv allure-jenkins-plugin.hpi allure-jenkins-plugin.jpi
mv htmlpublisher.hpi htmlpublisher.jpi
mv git.hpi git.jpi

echo "Плагины скачаны и установлены"

# Запускаем Jenkins
echo "Запуск Jenkins..."
./start_jenkins.sh

echo "Установка завершена. Откройте Jenkins в браузере: http://localhost:8083"