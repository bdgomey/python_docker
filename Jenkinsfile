pipeline {
    agent {label 'docker'} 
    environment {
        registryCredential = 'docker'
    }
    stages {
        stage('Checkout') { 
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/bdgomey/python_docker.git']]])
            }
        }
        stage('Build') { 
            steps {
                script {
                    dockerImage = docker.build bjgomes/python_docker
                }
            }
        }
        stage('Deploy') { 
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push("$latest")

                    }
                }
            }
        }
    }
}

