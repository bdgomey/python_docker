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
        stage ('Check sts identity') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Jenkins_credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]){
                    sh "aws sts get-caller-identity"
                }
            }
        }
        stage ('Deploy to Kubernetes') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Jenkins_credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]){
                    sh "kubectl apply -f deployment.yaml"
                    sh "kubectl rollout restart deployment flaskcontainer"
                }
            }
        }            
        stage('Clean Up'){
            steps {
                sh "docker image prune -af"
            }
        }
    }
}




