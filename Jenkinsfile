pipeline {  

    environment {
        registry = "bjgomes/python_docker"
        registryCredential = 'docker'
        deployment_name = 'flaskcontainer'
        cluster_name = 'skillstorm-eks'
        AWS=credentials('AWS_Jenkins_credentials')

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
        stage ('K8S Deploy') {
            steps {
                withKubeConfig([credentialsId: 'K8s']) {
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl rollout restart deployment maven-app-deploy'
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




