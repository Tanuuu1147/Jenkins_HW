pipeline {
    agent any
    
    parameters {
        string(name: 'SELENOID_URL', defaultValue: 'http://selenoid:4444/wd/hub', description: 'Адрес Selenoid executor')
        string(name: 'OPENCART_URL', defaultValue: 'http://opencart:8080', description: 'Адрес приложения Opencart')
        choice(name: 'BROWSER', choices: ['chrome', 'firefox'], description: 'Браузер для тестирования')
        string(name: 'BROWSER_VERSION', defaultValue: 'latest', description: 'Версия браузера')
        string(name: 'THREAD_COUNT', defaultValue: '1', description: 'Количество потоков')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: '.'
            }
        }
        
        stage('Setup Selenoid') {
            steps {
                sh 'docker-compose -f docker-compose.selenoid.yml up -d'
                sh 'sleep 10' // Ждем запуска Selenoid
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }
        
        stage('Run Tests') {
            steps {
                sh """
                    pytest tests/ \
                        --browser=${params.BROWSER} \
                        --base-url=${params.OPENCART_URL} \
                        -n ${params.THREAD_COUNT} \
                        --alluredir=allure-results || true
                """
            }
            post {
                always {
                    // Генерируем Allure отчет даже если тесты упали
                    publishHtml target: [
                        allowMissing: true,
                        alwaysLinkToLastBuild: false,
                        keepAll: true,
                        reportDir: 'allure-results',
                        reportFiles: 'index.html',
                        reportName: "Allure Report"
                    ]
                }
            }
        }
        
        stage('Generate Allure Report') {
            steps {
                // Устанавливаем Allure если его нет
                sh 'wget https://github.com/allure-framework/allure2/releases/download/2.24.0/allure-2.24.0.tgz'
                sh 'tar -xzf allure-2.24.0.tgz'
                
                // Генерируем отчет
                sh '''
                    export PATH=$PATH:./allure-2.24.0/bin
                    allure generate allure-results --clean -o allure-report || echo "Failed to generate Allure report"
                '''
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
            sh 'docker-compose -f docker-compose.selenoid.yml down || true'
            
            // Архивируем результаты тестов
            archiveArtifacts artifacts: 'allure-results/**/*', allowEmptyArchive: true
            archiveArtifacts artifacts: 'allure-report/**/*', allowEmptyArchive: true
        }
    }
}
