pipeline {
    agent {
        label 'docker'
        } 
    environment {
        registryCredential = 'docker'
    }
    stages {
        stage('Clone repository') {

            checkout scm
        }
        stage('Build Image') {
            app = docker.build("bjgomes/jenkins")
        }
        stage('Test Image'){
            app.inside {
                echo "Test Passed"
            }
        }
        stage('Deploy'){
            docker.withRegustry("https://registry.hub.docker.com", registryCredentials) {
                app.push("${env.BUILD_NUMBER}")
                app.push("latest")
            }
        }
    }
}


