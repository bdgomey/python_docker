pipeline {  

    environment {
        registry = "bjgomes/python_docker"
        registryCredential = 'docker'
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
                    kubernetesDeploy(configs: "deployment.yaml", kubeconfigId: "K8s")
                    }
                } 
            }            
        }
        stage('Deploy to Kubernetes'){
            steps {
                script {
                    withCredentials([aws(accessKeyVariable:'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Jenkins_credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]){
                        sh 'kubectl apply -f deployment.yml'
                        sh 'kubectl rollout restart deployment ${deployment_name}'
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



