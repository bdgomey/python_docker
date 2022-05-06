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
            step{
            app = docker.build("bjgomes/jenkins")   
            }            
        }
        stage('Test Image'){
            step{
                app.inside {
                    echo "Test Passed"
                }
            }
        }
        stage('Deploy'){
            step{
            docker.withRegustry("https://registry.hub.docker.com", registryCredentials) {
                app.push("${env.BUILD_NUMBER}")
                app.push("latest")
                }
            }

        }
    }
}


