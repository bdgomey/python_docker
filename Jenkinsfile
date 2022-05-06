pipeline {  

    environment {
        registry = "bjgomes/python_docker"
        registryCredential = 'docker'
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
        stage('Deploy') {
            steps{
                script{
                    docker.withRegistry('https://registry.hub.docker.com', registryCredential){
                        def myImage = docker.build(registry)
                        myImage.push()
                    }
                }
            }

        }
    }
}


