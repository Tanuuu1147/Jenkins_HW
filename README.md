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
