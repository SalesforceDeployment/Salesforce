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
                sfdx force:auth:jwt:grant --clientid 3MVG9n_HvETGhr3AOaeLfpd6RsgebHXoalEw8US3cJ7LIRfhy2CtzNqg.7epaDtfv_Ger6kolOIGMpStxWwxi --username thomasraj@mit.com --jwtkeyfile D:\ProgramFiles\JWT\server.key -d --instanceurl https://login.salesforce.com/

                echo 'Testing..'
                
                echo "** List of org connections"
                sfdx force:org:list
                echo "** List of org connections after "
            }
        }
        stage('Deploy') {
            steps {
                
                echo 'Deploying....'
                
                sfdx force:source:deploy -x manifest/package.xml -u deployment.user@fedex.com.qa22
                 echo 'Deploying....s'
            }
        }
    }
}
