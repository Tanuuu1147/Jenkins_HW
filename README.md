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

## Остановка Jenkins

Для остановки Jenkins выполните:
```
./stop_jenkins.sh
```

Или вручную:
```
docker-compose -f docker-compose.jenkins.yml down
```

## Быстрый запуск всей системы

Для быстрого запуска всей системы выполните:
```
./setup_and_run.sh
```

Этот скрипт автоматически:
- Проверит наличие всех необходимых инструментов
- Установит зависимости Python
- Запустит Selenoid
- Установит плагины Jenkins (если нужно)
- Запустит Jenkins
- Покажет пароль администратора

## Остановка всей системы

Для остановки всей системы выполните:
```
./stop_all.sh
```

Этот скрипт автоматически остановит и Jenkins, и Selenoid.

## Настройка Jenkins

### Вариант 1: Использование скриптов (рекомендуется)

1. Запустите Jenkins с помощью скрипта:
   ```
   ./start_jenkins.sh
   ```

2. Откройте Jenkins в браузере: http://localhost:8083

3. Введите пароль администратора (будет показан в терминале)

4. Следуйте инструкциям установщика Jenkins

5. Установите необходимые плагины:
   - Allure Jenkins Plugin
   - HTML Publisher Plugin
   - Git Plugin

   Если возникает ошибка SSL при установке плагинов:
   - Остановите Jenkins: `./stop_jenkins.sh`
   - Запустите скрипт установки плагинов: `./install_plugins.sh`
   - Запустите Jenkins снова: `./start_jenkins.sh`

6. Создайте новую Pipeline job и укажите путь к Jenkinsfile в репозитории

7. Настройте параметры сборки:
   - Адрес Selenoid executor
   - Адрес приложения Opencart
   - Браузер
   - Версия браузера
   - Количество потоков

### Вариант 2: Ручной запуск

1. Запустите Jenkins:
   ```
   docker-compose -f docker-compose.jenkins.yml up -d
   ```

2. Откройте Jenkins в браузере: http://localhost:8083

3. Создайте новую Pipeline job и укажите путь к Jenkinsfile в репозитории

4. Настройте параметры сборки:
   - Адрес Selenoid executor
   - Адрес приложения Opencart
   - Браузер
   - Версия браузера
   - Количество потоков
