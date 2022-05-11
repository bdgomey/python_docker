# AWS Jenkins Pipeline to Deploy a Python Flask Web-app
---
This deployment requires the following:

1. A jenkins build server
2. a sonarqube server
3. an EKS cluster hosted on AWS


This project has a jenkinsfile that has multiple build stages.  

The main stages are a sonarqube code test stage and quality gate, docker build and push stage, and a kubernetes deploy stage.  

The focus of this project was to create a dockerized web application that can be easily repeated and modular so if it needs to be replicated, it can be in a matter of minutes.  

Next steps: I intend to add persistent storage through either EBS or EFS interfaces. 