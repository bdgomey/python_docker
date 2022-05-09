pipeline {  

    environment {
        registry = "bjgomes/python_docker"
        registryCredential = 'docker'
        AWS = 'AWS_Jenkins_credentials'
        deployment_name = 'flaskcontainer'
        cluster_name = 'skillstorm-eks'

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
        stage('AWS KubeConfig'){
            steps {
                script {
                    withCredentials([aws(accessKeyVariable:'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Jenkins_credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]){
                        sh 'aws eks update-kubeconfig --region us-east-1 --name ${cluster_name}'
                    }
                } 
            }            
        }
        stage('Deploy to Kubernetes'){
            steps {
                sh 'kubectl apply -f deployment.yml'
                sh 'kubectl rollout restart deployment ${deployment_name}'
            }
        }
        stage('Clean Up'){
            steps {
                sh "docker image prune -af"
            }
        }
    }
}



