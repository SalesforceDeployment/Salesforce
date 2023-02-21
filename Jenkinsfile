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
                

                echo ""

                
                
                
                echo 'Deploying.... by Thomas'
                
               
            }
        }
    }
}
