pipeline {  

    environment {
        registry = "bjgomes/python_docker"
        registryCredential = 'docker'
    }  
    agent {
        label 'docker'
    }    
    stages {
        stage('Build and Push Image') {
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


