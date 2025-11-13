pipeline {
    agent any
    
    parameters {
        string(name: 'SELENOID_URL', defaultValue: 'http://localhost:4444/wd/hub', description: 'Адрес Selenoid executor')
        string(name: 'OPENCART_URL', defaultValue: 'http://localhost:8080', description: 'Адрес приложения Opencart')
        choice(name: 'BROWSER', choices: ['chrome', 'firefox'], description: 'Браузер для тестирования')
        string(name: 'BROWSER_VERSION', defaultValue: 'latest', description: 'Версия браузера')
        string(name: 'THREAD_COUNT', defaultValue: '1', description: 'Количество потоков')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Tanuuu1147/Jenkins_HW'
            }
        }
        
        stage('Setup Selenoid') {
            steps {
                sh 'echo "Проверка доступности Docker..."'
                sh 'docker info || echo "Docker недоступен"'
                sh 'echo "Запуск Selenoid..."'
                sh 'docker compose -f docker-compose.selenoid.yml up -d'
                sh '''
                    echo "Ждем запуска Selenoid..."
                    for i in {1..30}; do
                        if curl -s http://localhost:4444/status > /dev/null; then
                            echo "Selenoid успешно запущен"
                            break
                        fi
                        echo "Ожидание Selenoid... ($i/30)"
                        sleep 2
                    done
                '''
                sh 'docker ps' // Показываем запущенные контейнеры
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'echo "Установка зависимостей..."'
                sh 'pip install -r requirements.txt'
                sh 'echo "Проверка установленных пакетов..."'
                sh 'pip list | grep pytest-xdist || echo "pytest-xdist не найден"'
                sh 'echo "Зависимости успешно установлены"'
            }
        }
        
        stage('Run Tests') {
            steps {
                sh '''
                    echo "Запуск тестов..."
                    echo "Проверка доступности Selenoid..."
                    if curl -s http://localhost:4444/status > /dev/null; then
                        echo "Selenoid доступен"
                    else
                        echo "Selenoid недоступен"
                        exit 1
                    fi
                    
                    mkdir -p allure-results
                    
                    pytest tests/ \\
                        --browser=${params.BROWSER} \\
                        --base-url=${params.OPENCART_URL} \\
                        -n ${params.THREAD_COUNT} \\
                        --alluredir=allure-results || true
                '''
            }
            post {
                always {
                    script {
                        // Проверяем, есть ли результаты Allure
                        def resultsExist = sh(script: 'ls allure-results/*.json || echo "no results"', returnStdout: true).trim()
                        if (resultsExist != "no results") {
                            echo "Allure results found, will generate report"
                        } else {
                            echo "No Allure results found"
                        }
                    }
                    // Архивируем результаты Allure
                    archiveArtifacts artifacts: 'allure-results/**/*', allowEmptyArchive: true
                }
            }
        }
        
        stage('Generate Allure Report') {
            steps {
                script {
                    // Проверяем наличие Allure commandline
                    def allureExists = sh(script: 'which allure || echo "not found"', returnStdout: true).trim()
                    if (allureExists == "not found") {
                        echo "Allure commandline not found, installing..."
                        // Устанавливаем Allure если его нет
                        sh '''
                            wget https://github.com/allure-framework/allure2/releases/download/2.24.0/allure-2.24.0.tgz
                            tar -xzf allure-2.24.0.tgz
                            export PATH=$PATH:$(pwd)/allure-2.24.0/bin
                            echo "Allure установлен"
                        '''
                    }
                    
                    // Генерируем отчет
                    sh '''
                        export PATH=$PATH:$(pwd)/allure-2.24.0/bin
                        if which allure > /dev/null; then
                            echo "Генерация Allure отчета..."
                            allure generate allure-results --clean -o allure-report || echo "Failed to generate Allure report"
                        else
                            echo "Allure commandline not available, skipping report generation"
                        fi
                    '''
                }
            }
            post {
                always {
                    publishHTML([
                        allowMissing: true,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'allure-report',
                        reportFiles: 'index.html',
                        reportName: 'Allure Report'
                    ])
                }
            }
        }
    }
    
    post {
        always {
            // Останавливаем Selenoid
            sh 'echo "Остановка Selenoid..."'
            sh 'docker compose -f docker-compose.selenoid.yml down || true'
            
            // Архивируем отчет Allure
            archiveArtifacts artifacts: 'allure-report/**/*', allowEmptyArchive: true
            
            // Публикуем Allure-отчёт
            script {
                allure([
                    includeProperties: false,
                    jdk: '',
                    properties: [],
                    reportBuildPolicy: 'ALWAYS',
                    results: [[path: 'allure-results']]
                ])
            }
        }
    }
}