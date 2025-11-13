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
                git branch: 'main', url: 'https://github.com/Tanuuu1147/Jenkins_HW'
            }
        }
        
        stage('Setup Selenoid') {
            steps {
                sh 'docker compose -f docker-compose.selenoid.yml up -d'
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
                        sh 'wget https://github.com/allure-framework/allure2/releases/download/2.24.0/allure-2.24.0.tgz'
                        sh 'tar -xzf allure-2.24.0.tgz'
                        sh 'export PATH=$PATH:./allure-2.24.0/bin'
                    }
                    
                    // Генерируем отчет
                    sh '''
                        if which allure > /dev/null; then
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
            sh 'docker compose -f docker-compose.selenoid.yml down || true'
            
            // Архивируем отчет Allure
            archiveArtifacts artifacts: 'allure-report/**/*', allowEmptyArchive: true
        }
    }
}
