#!groovy

import groovy.json.JsonSlurperClassic

node {

    def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
    def SF_USERNAME=env.HUB_ORG_DH
     def JWT_CRED_ID_DH=env.JWT_CRED_ID_DH
     def SF_INSTANCE_URL = env.SF_INSTANCE_URL ?: "https://login.salesforce.com"

    
println 'KEY IS'
    println SF_USERNAME
    println 'Consumer KEY IS'
    println SF_CONSUMER_KEY
    println 'URL IS'
    println SF_INSTANCE_URL

    // -------------------------------------------------------------------------
    // Check out code from source control.
    // -------------------------------------------------------------------------

    stage('checkout source') {
        checkout scm
    }

    }


