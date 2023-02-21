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
        
        withCredentials([file(credentialsId:QA_FILE, variable: 'server_key_file')]) {
            stage('Authorize DevHub') {
                rc = command "sfdx auth:jwt:grant --instanceurl ${SF_INSTANCE_URL} --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile ${server_key_file} --setdefaultdevhubusername --setalias HubOrg"
                if (rc != 0) {
                    error 'Salesforce dev hub org authorization failed.'
                }
            }
			}
			
    }
}
