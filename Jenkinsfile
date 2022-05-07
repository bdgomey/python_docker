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
                    dockerImage = docker.build registry
                }
            }

        }
        stage('Deploy Stage') {
            steps {
                script {
                    docker.withRegistry('', registryCredential){
                        dockerImage.push(registry)
                    }
                }
            }
            
        }
        stage('Run Image'){
            steps {
                script{
                    dockerImage.run(['-dp 5000:5000'])
                }
                
            }
        }
        stage('Clean Up'){
            steps {
                sh "docker rmi $registry -f"
            }
        }
    }
}



