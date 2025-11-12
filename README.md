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
- `Jenkinsfile` - pipeline для Jenkins (будет создан позже)

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
