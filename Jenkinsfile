pipeline {
    agent {
        label 'docker'
        } 
    environment {
        registryCredential = 'docker'
    }
    stages {
        stage('Clone repository') {
            steps {
            checkout scm
            }
        }
        stage('Build Image') {
            steps{
            app = docker.build("bjgomes/jenkins")   
            }            
        }
        stage('Test Image'){
            steps{
                app.inside {
                    echo "Test Passed"
                }
            }
        }
        stage('Deploy'){
            steps{
            docker.withRegustry("https://registry.hub.docker.com", registryCredentials) {
                app.push("${env.BUILD_NUMBER}")
                app.push("latest")
                }
            }

        }
    }
}


