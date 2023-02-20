pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
               
            }
        }
        stage('Test') {
            steps {
                echo ' before Testing..'
                
            }
        }
        stage('Deploy') {
            steps {
                 withCredentials([sshUserPrivateKey(credentialsId: 'QA_ID', keyFileVariable: 'CED_SERVER_KEY', passphraseVariable: 'CED_CLIENT_ID', usernameVariable: 'CED_USER')])
                {
                    echo CED_SERVER_KEY
                }
                echo ""

                
                echo 'Deploying.... by Thomas'
                
               
            }
        }
    }
}
