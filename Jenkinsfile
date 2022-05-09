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
        stage('Clean Up'){
            steps {
                sh "docker image prune -af"
            }
        }
    }
}




