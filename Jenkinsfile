pipeline {  

    environment {
        registry = "bjgomes/python_docker"
        registryCredential = 'docker'
        kubeConfig = 'K8s'

    }  
    agent {
        label 'docker'
    }    
    stages {
        stage('Initializing Credentials') {
            steps {
                bat "powershell Copy-Item ${kubeConfig} -Destination home/ubuntu/.kube"
            }
        }
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
                sh "kubectl apply -f deployment.yaml"
                sh "kubectl rollout restart deployment flaskcontainer"
            }
        }
        stage('Clean Up'){
            steps {
                sh "docker image prune -af"
            }
        }
    }
}



