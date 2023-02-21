def thomas
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
                

                   
                     echo "${SERVER_KEY}"
                     echo "${CLIENT_ID}"
                     echo "${USER}"
                     rc = command "sfdx auth:jwt:grant --instanceurl https://login.salesforce.com/ --clientid 3MVG9n_HvETGhr3AOaeLfpd6RsgebHXoalEw8US3cJ7LIRfhy2CtzNqg.7epaDtfv_Ger6kolOIGMpStxWwxi  --username thomasraj@mit.com --jwtkeyfile ${SERVER_KEY}"
                if (rc != 0) {
                    error 'Salesforce dev hub org authorization failed.'
                }
                }
                     
                  // sfdx force:auth:jwt:grant --clientid 3MVG9n_HvETGhr3AOaeLfpd6RsgebHXoalEw8US3cJ7LIRfhy2CtzNqg.7epaDtfv_Ger6kolOIGMpStxWwxi --username thomasraj@mit.com --jwtkeyfile ${SERVER_KEY}  -d --instanceurl https://login.salesforce.com/

                
                
                echo 'Deploying.... by Thomas'
                
               
            }
        }
    }
}
