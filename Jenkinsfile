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
        stage('deploy to kubernetes'){
            steps {
                script {
                    kubernetesDeploy configs: 'deployment.yaml', 
                    kubeconfigId: 'K8s-config',
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



