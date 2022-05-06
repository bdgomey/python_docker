pipeline {
    agent {
        label 'docker'
        } 
    stages {

        stage('SCM Checkout')
            step {
                checkout([$class: 'GitSCM', branches: [[name: '*/testing']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/bdgomey/python_docker.git']]])
            }

    }
}


