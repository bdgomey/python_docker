node("agent1"){
    stages {
        stage('Checkout') { 
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/bdgomey/python_docker.git']]])
            }
        }
        stage('Build') { 
            steps {
                sh "docker build -t bjgomes/python ."
            }
        }
        stage('Run') { 
            steps {
                sh "docker run --rm -d -p 5000:5000 bjgomes/python"
            }
        }
    }
}

