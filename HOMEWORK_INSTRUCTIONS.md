# Инструкция по выполнению домашнего задания "Запуск автотестов с использованием Jenkins"

## Цель задания

Научиться поднимать Jenkins и выполнять базовую конфигурацию джобы для запуска автотестов на OpenCart.

## Что уже сделано

В этом репозитории уже подготовлены:

1. [Jenkinsfile](file:///Users/tanuuu/Jenkins_HW/Jenkinsfile) - pipeline для Jenkins с поддержкой параметров
2. [docker-compose.jenkins.yml](file:///Users/tanuuu/Jenkins_HW/docker-compose.jenkins.yml) - конфигурация для запуска Jenkins в Docker
3. [docker-compose.selenoid.yml](file:///Users/tanuuu/Jenkins_HW/docker-compose.selenoid.yml) - конфигурация для запуска Selenoid
4. Автотесты в директории [tests/](file:///Users/tanuuu/Jenkins_HW/tests/)
5. Вспомогательные скрипты для запуска и остановки Jenkins

## Шаги для выполнения задания

### 1. Подготовка репозитория

1. Убедитесь, что все изменения сохранены в вашем GitHub репозитории
2. Проверьте, что [Jenkinsfile](file:///Users/tanuuu/Jenkins_HW/Jenkinsfile) находится в корне репозитория

### 2. Запуск Jenkins

1. Откройте терминал и перейдите в директорию проекта
2. Запустите Jenkins с помощью скрипта:
   ```
   ./start_jenkins.sh
   ```
   
   Или вручную:
   ```
   docker-compose -f docker-compose.jenkins.yml up -d
   ```

3. Откройте Jenkins в браузере: http://localhost:8083

4. Введите пароль администратора (если используете скрипт, он будет показан в терминале)

### 3. Настройка Jenkins

1. Установите рекомендуемые плагины
2. Создайте учетную запись администратора
3. Установите дополнительные плагины:
   - Allure Jenkins Plugin
   - HTML Publisher Plugin
   - Git Plugin

### 4. Создание Jenkins Job

1. Нажмите "New Item"
2. Введите имя job'ы (например, "OpenCart Tests")
3. Выберите "Pipeline" и нажмите OK
4. В разделе "Build Triggers" отметьте "This project is parameterized"
5. Добавьте параметры:
   - String parameter: `SELENOID_URL` со значением по умолчанию `http://selenoid:4444/wd/hub`
   - String parameter: `OPENCART_URL` со значением по умолчанию `http://opencart:8080`
   - Choice parameter: `BROWSER` с вариантами `chrome` и `firefox`
   - String parameter: `BROWSER_VERSION` со значением по умолчанию `latest`
   - String parameter: `THREAD_COUNT` со значением по умолчанию `1`
6. В разделе "Pipeline" выберите:
   - Definition: "Pipeline script from SCM"
   - SCM: "Git"
   - Repository URL: URL вашего репозитория
   - Branches to build: `*/main` (или другая ветка, если используется)
7. Нажмите "Save"

### 5. Запуск тестов

1. Перейдите к созданной job'е
2. Нажмите "Build with Parameters"
3. При необходимости измените параметры
4. Нажмите "Build"

### 6. Проверка результатов

1. После завершения сборки перейдите к её результатам
2. Проверьте консольный вывод
3. Просмотрите отчеты Allure

## Что нужно предоставить преподавателю

1. Лог сборки Jenkins
2. Скриншоты:
   - Поднятого Jenkins с открытой джобой, в которой видны параметры
   - Выполненного прогона со сгенерированным отчётом
3. Если вы модифицировали [Jenkinsfile](file:///Users/tanuuu/Jenkins_HW/Jenkinsfile), пришлите PR или ссылку на него

## Возможные проблемы и их решения

### Проблема: Порт уже занят
Решение: Измените порт в [docker-compose.jenkins.yml](file:///Users/tanuuu/Jenkins_HW/docker-compose.jenkins.yml) в разделе ports

### Проблема: Не хватает прав для запуска Docker
Решение: Добавьте пользователя в группу docker или запустите команды с sudo

### Проблема: Jenkins не может получить доступ к Docker
Решение: Убедитесь, что в [docker-compose.jenkins.yml](file:///Users/tanuuu/Jenkins_HW/docker-compose.jenkins.yml) правильно смонтированы volumes для Docker

## Полезные команды

- Запуск Jenkins: `docker-compose -f docker-compose.jenkins.yml up -d`
- Остановка Jenkins: `docker-compose -f docker-compose.jenkins.yml down`
- Получение пароля администратора: `docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword`
- Просмотр логов Jenkins: `docker logs jenkins`