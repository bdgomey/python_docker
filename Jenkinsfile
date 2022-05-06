pipeline {  
    
    environment {
        registry = "bjgomes/python_docker"
        registryCredential = 'dockerhub'
    }  
    agent {
        label 'docker'
    }    
        stages {
            stage('Building image') {
            steps{
                script {
                docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
    }
}


