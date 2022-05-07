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
            script {
                dockerImage = docker.build registry + ":$BUILD_NUMBER"
            }
        }
        stage('Deploy Stage') {
            script {
                docker.withRegistry('', registryCredential){
                    dockerImage.push(registry)
                }
            }
        }
        stage('Run Image'){
            steps {
                dockerImage.run(['-dp 5000:5000'])
            }
        }
        stage('Clean Up'){
            steps {
                sh "docker rmi $registry:$BUILD_NUMBER -f"
            }
        }
    }
}



