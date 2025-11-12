#!/bin/bash

# Скрипт для настройки и отправки репозитория в GitHub

echo "Введите имя пользователя GitHub:"
read USERNAME

echo "Введите название репозитория (по умолчанию: Jenkins_HW):"
read REPO_NAME

# Если название репозитория не указано, используем значение по умолчанию
if [ -z "$REPO_NAME" ]; then
    REPO_NAME="Jenkins_HW"
fi

echo "Введите токен доступа GitHub (персональный токен доступа):"
read TOKEN

# Переходим в директорию проекта
cd /Users/tanuuu/Documents/Jenkins_HW

# Создаем удаленный репозиторий через GitHub API
echo "Создаем удаленный репозиторий..."
curl -u "$USERNAME:$TOKEN" https://api.github.com/user/repos -d "{\"name\":\"$REPO_NAME\",\"private\":false}"

# Добавляем удаленный репозиторий
echo "Добавляем удаленный репозиторий..."
git remote add origin https://github.com/$USERNAME/$REPO_NAME.git

# Проверяем, что ветка называется main, если нет - переименовываем
echo "Проверяем имя ветки..."
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "Переименовываем ветку в main..."
    git branch -m $CURRENT_BRANCH main
fi

# Отправляем код в удаленный репозиторий
echo "Отправляем код в удаленный репозиторий..."
git push -u origin main

echo "Репозиторий успешно создан и отправлен в GitHub!"
echo "Вы можете просмотреть его по адресу: https://github.com/$USERNAME/$REPO_NAME"
