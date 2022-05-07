pipeline {  

    environment {
        registry = "bjgomes/python_docker"
        registryCredential = 'docker'
    }  
    agent {
        label 'docker'
    }    
    stages {
        stage('Build Stage') {
            steps {
                script {
                    dockerImage = docker.build(registry)
                }
            }

        }
        stage('Deploy Stage') {
            steps {
                script {
                    docker.withRegistry('', registryCredential){
                        dockerImage.push()
                    }
                }
            }
            
        }
        stage('Run Image'){
            steps {
                sh "docker stop python_docker"
                sh "docker run -d -p 5000:5000 --name python_docker bjgomes/python_docker:latest"                
            }
        }
        stage('Clean Up'){
            steps {
                sh "docker rmi $registry -f"
            }
        }
    }
}



