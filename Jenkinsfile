#!groovy

import groovy.json.JsonSlurperClassic

node {

//     def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
    def SF_USERNAME=env.HUB_ORG_DH
//     def JWT_CRED_ID_DH=env.JWT_CRED_ID_DH
//     def SF_INSTANCE_URL = env.SF_INSTANCE_URL ?: "https://login.salesforce.com"

    
println 'KEY IS'
    println SF_CONSUMER_KEY

    // -------------------------------------------------------------------------
    // Check out code from source control.
    // -------------------------------------------------------------------------

    stage('checkout source') {
        checkout scm
    }


   
    
    withEnv(["HOME=${env.WORKSPACE}"]) {
        
        withCredentials([file(credentialsId:JWT_CRED_ID_DH, variable: 'server_key_file')]) {

            // -------------------------------------------------------------------------
            // Authorize the Dev Hub org with JWT key and give it an alias.
            // -------------------------------------------------------------------------

            stage('Authorize DevHub') {
                rc = command "sfdx auth:jwt:grant --instanceurl ${SF_INSTANCE_URL} --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile ${server_key_file} --setdefaultdevhubusername --setalias HubOrg"
                if (rc != 0) {
                    error 'Salesforce dev hub org authorization failed.'
                }
            }

            }
           
        }
    }


