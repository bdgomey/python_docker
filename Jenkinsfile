pipeline {  
    environment {
        registry = "bjgomes/python_docker"
        registryCredential = 'docker'
        cluster_name = 'skillstorm'
    }  
    agent {
        label 'docker'
    }
    stages {
        stage('SonarQube Analysis') {
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
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
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




