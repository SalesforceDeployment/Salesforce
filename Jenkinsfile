#!groovy

import groovy.json.JsonSlurperClassic

node {

    def SF_CONSUMER_KEY=""
    def SF_USERNAME=""
    def SERVER_KEY_CREDENTALS_ID= "QA_ID"
    
    def SF_INSTANCE_URL =  "https://login.salesforce.com"

   

    stage('checkout source') {
        checkout scm
    }
    withEnv(["HOME=${env.WORKSPACE}"]) {
        
         withCredentials([sshUserPrivateKey(credentialsId: 'QA_ID', keyFileVariable: 'CED_SERVER_KEY', passphraseVariable: 'CED_CLIENT_ID', usernameVariable: 'CED_USER')]) {
            stage('Authorize DevHub') {
                rc = command "sfdx auth:jwt:grant --instanceurl https://login.salesforce.com/ --clientid 3MVG9n_HvETGhr3AOaeLfpd6RsgebHXoalEw8US3cJ7LIRfhy2CtzNqg.7epaDtfv_Ger6kolOIGMpStxWwxi --username thomasraj@mit.com --jwtkeyfile ${CED_SERVER_KEY} "
                if (rc != 0) {
                    error 'Salesforce dev hub org authorization failed.'
                }
            }
			}
			
    }
}
