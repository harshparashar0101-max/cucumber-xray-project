pipeline {
    agent any

    environment {
        XRAY_BASE_URL = 'https://xray.cloud.getxray.app'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/harshparashar0101-max/cucumber-xray-project.git'
            }
        }

        stage('Run Tests') {
            steps {
                bat 'mvn test'
            }
        }

        stage('Authenticate to Xray') {
            steps {
                withCredentials([
                    string(credentialsId: 'XRAY_CLIENT_ID', variable: 'XRAY_CLIENT_ID'),
                    string(credentialsId: 'XRAY_CLIENT_SECRET', variable: 'XRAY_CLIENT_SECRET')
                ]) {
                    bat '''
                    curl -H "Content-Type: application/json" ^
                         -X POST ^
                         --data "{\\"client_id\\":\\"%XRAY_CLIENT_ID%\\",\\"client_secret\\":\\"%XRAY_CLIENT_SECRET%\\"}" ^
                         %XRAY_BASE_URL%/api/v2/authenticate > xray_token.txt
                    '''
                }
            }
        }

        stage('Upload Cucumber Results to Xray') {
            steps {
                bat '''
                set /p XRAY_TOKEN=<xray_token.txt
                set XRAY_TOKEN=%XRAY_TOKEN:"=%

                curl -H "Content-Type: application/json" ^
                     -H "Authorization: Bearer %XRAY_TOKEN%" ^
                     --data @target/cucumber.json ^
                     %XRAY_BASE_URL%/api/v2/import/execution/cucumber?testExecKey=LOGI-70
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'target/cucumber.json', fingerprint: true
        }
    }
}