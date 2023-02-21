pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
               
            }
        }
        stage('Test') {
            environment{
                SFDX_DETAILS = credentials("thomas")
            }
            steps {
                echo "before Testing.. ${SFDX_DETAILS_USR}"
                
                
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'QA_ID', keyFileVariable: 'SERVER_KEY', passphraseVariable: 'CLIENT_ID', usernameVariable: 'USER')]) {
                

                    echo "${QA_ID}"
                     echo "${SERVER_KEY}"
                     echo "${CLIENT_ID}"
                     echo "${USER}"
                     echo "${}"

                
                }
                
                echo 'Deploying.... by Thomas'
                
               
            }
        }
    }
}
