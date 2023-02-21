#!groovy

import groovy.json.JsonSlurperClassic

node {

    def SF_CONSUMER_KEY=env.CONNECTED_APP_CONSUMER_KEY_DH
    def SF_USERNAME=env.HUB_ORG_DH
     def JWT_CRED_ID_DH=env.JWT_CRED_ID_DH
     def SF_INSTANCE_URL =  "https://login.salesforce.com"

    
println 'KEY IS'
    println SF_USERNAME
    println 'Consumer KEY IS'
    println SF_CONSUMER_KEY
    println 'URL IS'
    println SF_INSTANCE_URL
    println 'JWT IS'
    println JWT_CRED_ID_DH

    // -------------------------------------------------------------------------
    // Check out code from source control.
    // -------------------------------------------------------------------------

    stage('checkout source') {
        checkout scm
    }
 withEnv(["HOME=${env.WORKSPACE}"]) {
        
        withCredentials([file(credentialsId: JWT_CRED_ID_DH, variable: 'server_key_file')]) {

            // -------------------------------------------------------------------------
            // Authorize the Dev Hub org with JWT key and give it an alias.
            // -------------------------------------------------------------------------

            stage('Authorize DevHub') {
                rc = command "sfdx auth:jwt:grant --instanceurl ${SF_INSTANCE_URL} --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile ${server_key_file}"
                if (rc != 0) {
                    println "sfdx auth:jwt:grant --instanceurl ${SF_INSTANCE_URL} --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile ${server_key_file}"
                    error 'Salesforce dev hub org authorization failed.'
                }
            }

            }
           
        }
    }


