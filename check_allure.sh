#!/bin/bash

# Скрипт для проверки установки Allure

echo "Проверка установки Allure..."

# Проверяем, установлен ли Allure в системе
if command -v allure &> /dev/null
then
    echo "Allure установлен:"
    allure --version
else
    echo "Allure не найден в системе"
fi

# Проверяем, установлены ли плагины в Jenkins
echo "Проверка плагинов Jenkins..."
if [ -f "/Users/tanuuu/Jenkins_HW/jenkins_home/plugins/allure-jenkins-plugin.jpi" ]; then
    echo "Плагин Allure Jenkins установлен"
else
    echo "Плагин Allure Jenkins НЕ установлен"
fi

if [ -f "/Users/tanuuu/Jenkins_HW/jenkins_home/plugins/htmlpublisher.jpi" ]; then
    echo "Плагин HTML Publisher установлен"
else
    echo "Плагин HTML Publisher НЕ установлен"
fi

if [ -f "/Users/tanuuu/Jenkins_HW/jenkins_home/plugins/git.jpi" ]; then
    echo "Плагин Git установлен"
else
    echo "Плагин Git НЕ установлен"
fi

echo "Проверка завершена"