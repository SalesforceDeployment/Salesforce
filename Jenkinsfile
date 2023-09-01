pipeline {
    agent any

    environment {
        SONARQUBE_URL = 'http://localhost:9000' // Replace with your SonarQube server URL
        SONARQUBE_TOKEN = 'sqa_777211957f862209118b6b7af01eda379bf538fe' // Add your SonarQube authentication token credential ID
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // stage('Install Dependencies') {
        //     steps {
        //         script {
        //             bat 'npm install' // If you have JavaScript code
        //         }
        //     }
        // }

        stage('Run SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'sonarscanner' // Define 'SonarQube Scanner' tool in Jenkins

                    withSonarQubeEnv('sonarqube') {
                        bat """
                        ${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=Demo \
                            -Dsonar.sources=./src \
                            -Dsonar.host.url=${SONARQUBE_URL} \
                            -Dsonar.login=${SONARQUBE_TOKEN}
                        """
                    }
                }
            }
        }

        stage('Deploy to Salesforce') {
            steps {
                script {
                    bat 'ant deploy' // Use your Ant deploy target or command
                }
            }
        }
    }
}
