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
                
                echo 'Deploying....'
                
                sfdx force:source:deploy -x manifest/package.xml -u deployment.user@fedex.com.qa22
                 echo 'Deploying....s'
            }
        }
    }
}
