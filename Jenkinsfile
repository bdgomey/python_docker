pipeline {  

    environment {
        registry = "bjgomes/python_docker"
        registryCredential = 'docker'
        KUBECONFIG = "K8s"

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
                    withKubeConfig([
                        credentialsId: 'K8s',
                        namespace: 'default'
                    ]) {
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



