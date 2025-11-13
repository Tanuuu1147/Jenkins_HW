#!/bin/bash

# Скрипт для запуска Jenkins с автотестами

echo "Запуск Jenkins для выполнения автотестов..."

# Проверяем, запущен ли уже Jenkins
if docker-compose -f docker-compose.jenkins.yml ps | grep -q "jenkins.*Up"; then
    echo "Jenkins уже запущен"
    echo "Откройте в браузере: http://localhost:8083"
else
    echo "Запуск Jenkins..."
    docker-compose -f docker-compose.jenkins.yml up -d
    
    # Ждем запуска Jenkins
    echo "Ожидание запуска Jenkins..."
    sleep 30
    
    # Получаем пароль администратора
    echo "Пароль администратора Jenkins:"
    docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
    
    echo ""
    echo "Откройте в браузере: http://localhost:8083"
    echo "Введите пароль администратора выше для настройки Jenkins"
fi