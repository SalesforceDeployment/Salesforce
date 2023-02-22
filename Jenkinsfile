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
//  withEnv(["HOME=${env.WORKSPACE}"]) {
        
//         withCredentials([file(credentialsId: JWT_CRED_ID_DH, variable: 'server_key_file')]) {

//             // -------------------------------------------------------------------------
//             // Authorize the Dev Hub org with JWT key and give it an alias.
//             // -------------------------------------------------------------------------

//             stage('Authorize DevHub') {
//                 rc = bat returnStatus: true, script:"sfdx auth:jwt:grant --instanceurl ${SF_INSTANCE_URL} --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile ${server_key_file}"
//                 if (rc != 0) {
//                     println "sfdx auth:jwt:grant --instanceurl ${SF_INSTANCE_URL} --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile ${server_key_file}"
//                     error 'Salesforce dev hub org authorization failed.'
//                 }
//             }

//             }
           
//         }
    
    
    withCredentials([file(credentialsId: JWT_CRED_ID_DH, variable: 'jwt_key_file')]) {
        stage('Authorize ORG') {
            if (isUnix()) {
                rc = sh returnStatus: true, script: "sfdx force:auth:jwt:grant --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile ${jwt_key_file} -d --instanceurl ${SF_INSTANCE_URL}"
                dc = bat returnStatus : true script "sfdx force:org:list"
            } else {
                rc = bat returnStatus: true, script: "sfdx force:auth:jwt:grant --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile \"${jwt_key_file}\" -d --instanceurl ${SF_INSTANCE_URL}"
               println 'org list'
                command "sfdx force:org:list"
                println 'Deploy'
                command "sfdx force:source:deploy -x manifest/package.xml -u thomasraj@mit.com"
            }
           
            
            if (rc != 0) {
                error 'hub org authorization failed'
            }
            if (isUnix()) {rmsg = sh returnStdout: true,  script: "sfdx force:source:deploy --manifest manifest/package.xml -u ${SF_USERNAME}"}
            else{rmsg = bat returnStdout: true, script: "sfdx force:source:deploy --manifest manifest/package.xml -u ${SF_USERNAME}"}
println 'I am rc'
            println(rc)
            println(rmsg)
    }
    }
}

