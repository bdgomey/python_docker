pipeline {  

    environment {
        registry = "bjgomes/python_docker"
        registryCredential = 'docker'
        KUBECONFIG = "K8s"
        AWS = 'AWS_Jenkins_credentials'

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
        stage('deploy to kubernetes'){
            steps {
                script {
                    withCredentials([aws(accessKeyVariable:'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Jenkins_credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]){
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl rollout restart deployment flaskcontainer'
                    }
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



