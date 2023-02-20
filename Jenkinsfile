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
                   command "sfdx force:auth:jwt:grant -d --instanceurl https://login.salesforce.com/ --clientid ${CED_CLIENT_ID} --jwtkeyfile ${CED_SERVER_KEY} --username thomasraj@mit.com" 
                }
                echo ""

                
                
                
                echo 'Deploying.... by Thomas'
                
               
            }
        }
    }
}
