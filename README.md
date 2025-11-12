# Jenkins_HW

Этот репозиторий содержит автоматизированные тесты для OpenCart и конфигурацию Jenkins для их запуска.

## Структура проекта

- `tests/` - директория с тестами
- `pages/` - Page Object'ы
- `requirements.txt` - зависимости Python
- `conftest.py` - конфигурационный файл pytest
- `Dockerfile` - для создания образа с тестами
- `docker-compose.selenoid.yml` - для запуска Selenoid
- `selenoid/` - конфигурация браузеров для Selenoid
- `Jenkinsfile` - pipeline для Jenkins
- `setup_github_repo.sh` - скрипт для отправки репозитория в GitHub

## Запуск тестов локально

1. Установите зависимости:
   ```
   pip install -r requirements.txt
   ```

2. Запустите Selenoid:
   ```
   docker-compose -f docker-compose.selenoid.yml up -d
   ```

3. Запустите тесты:
   ```
   pytest tests/
   ```

## Отправка репозитория в GitHub

Для отправки репозитория в GitHub выполните скрипт:
```
./setup_github_repo.sh
```

Следуйте инструкциям скрипта:
1. Введите имя пользователя GitHub
2. Введите название репозитория (по умолчанию: Jenkins_HW)
3. Введите токен доступа GitHub (персональный токен доступа)

## Настройка Jenkins

1. Запустите Jenkins:
   ```
   docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
   ```

2. Откройте Jenkins в браузере: http://localhost:8080

3. Создайте новую Pipeline job и укажите путь к Jenkinsfile в репозитории

4. Настройте параметры сборки:
   - Адрес Selenoid executor
   - Адрес приложения Opencart
   - Браузер
   - Версия браузера
   - Количество потоков
