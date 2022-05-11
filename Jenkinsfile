pipeline {

    environment {
        registry = "bjgomes/python_docker"
        registryCredential = 'docker'
        cluster_name = 'jenkins'
    }  
    agent {
        label 'docker'
    }
    stages {
        stage('SonarQube analysis') {
            steps {
                script {
                    scannerHome = tool 'SonarQube'
                }
                withSonarQubeEnv('SonarQubeScanner') {                
                    sh "${scannerHome}/bin/sonar-scanner \
                    -Dsonar.projectKey=python \
                    -Dsonar.sources=."
                }
            }
        }
        stage('Quality Gates') {
            steps {
                script{
                    timeout(time: 1, unit: 'HOURS') {
                    def qg = waitForQualityGate()
                    if(qg.status != 'OK') {
                        error "pipeline aborted due to quality gate failure ${qg.status}"
                        }
                    }
                }
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
        stage ('Check AWS STS Identity') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Jenkins_credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]){
                    sh "aws sts get-caller-identity"
                }
            }
        }
        stage ('Deploy to Kubernetes') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Jenkins_credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]){
                    sh "aws eks update-kubeconfig --region us-east-1 --name ${cluster_name}"
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




