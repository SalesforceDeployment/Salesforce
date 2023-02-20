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
                command "sfdx force:auth:jwt:grant --clientid 3MVG9n_HvETGhr3AOaeLfpd6RsgebHXoalEw8US3cJ7LIRfhy2CtzNqg.7epaDtfv_Ger6kolOIGMpStxWwxi --username thomasraj@mit.com --jwtkeyfile D:\ProgramFiles\JWT\server.key -d --instanceurl https://login.salesforce.com/"

                
                echo 'Deploying....'
                
               
            }
        }
    }
}
