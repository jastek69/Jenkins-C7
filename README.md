# Jenkins Setup 

port 8080


https://docs.aws.amazon.com/corretto/latest/corretto-21-ug/amazon-linux-install.html
JAVA 21
sudo yum install java-21-amazon-corretto-devel -y


HW
*rebuild using Java 21 instad of 17
* script out adding jenkins plugins:
Be a Man == script out adding the jenkins plugins, so that when the server is built and ready for interaction, the necessary plugins are already installed

Mandatory plugins: 
- AWS Credentials
- Pipeline: AWS steps
- Terraform
- Snyk
- Pipeline: GCP steps
- Google Cloud Platform SDK::Auth
- Github integration
- Github Authentication
- Pipeline: Github


Jenkins User Script 

#!/bin/bash

# --------------------------------------
# Update all installed packages
# --------------------------------------
sudo yum update -y

# --------------------------------------
# Add the Jenkins repository to yum sources
# --------------------------------------
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# --------------------------------------
# Import the Jenkins GPG key to verify packages
# --------------------------------------
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# --------------------------------------
# Upgrade all packages (including those from the new Jenkins repo)
# --------------------------------------
sudo yum upgrade -y

# --------------------------------------
# Install Amazon Corretto 17 (required Java version for Jenkins)
# --------------------------------------
sudo yum install java-17-amazon-corretto -y

# --------------------------------------
# Install Jenkins
# --------------------------------------
sudo yum install jenkins -y

# --------------------------------------
# Enable Jenkins to start at boot
# --------------------------------------
sudo systemctl enable jenkins

# --------------------------------------
# Start the Jenkins service
# --------------------------------------
sudo systemctl start jenkins



# --------------------------------------
# Optional: Check the status of Jenkins (won’t display in EC2 user data logs but useful for debugging)
# --------------------------------------
sudo systemctl status jenkins
# Q to quit lol




Public Ip address of ec2 followed by 8080 http://4.88.27.89:8080
This command is for the password 
sudo cat /var/lib/jenkins/secrets/initialAdminPassword







Pipeline Plugin List
Search Available Plugins:

AWS
-AWS Credentials
-Pipeline: AWS Steps
-Amazon EC2
-Amazon Elastic Container Service (ECS) / Fargate
-AWS CodeDeploy
-AWS Lambda
-AWS CodeBuild
-Amazon S3 Bucket Credentials
-AWS Secrets Manager SecretSource
-AWS CodePipeline
-Configuration as Code AWS SSM secrets
-CloudFormation
-AWS SAM

Terraform
-Terraform

Google
-Kubernetes
-Google Cloud Storage
-Google Kubernetes Engine
-Google Cloud Platform SDK::Auth
-Pipeline: GCP Steps

DevSecOps
-Snyk Securityﾠ

Sonar
-SonarQube Scannerﾠ

Aqua
-Aqua Security Scannerﾠ
-Aqua MicroScannerﾠ
-Aqua Security Serverless Scannerﾠ

GitHub
-GitHub Integration
-GitHub Authentication
-Pipeline: GitHub
-Pipeline GitHub Notify Step

Maven
-Maven Integration
-Pipeline Maven Integration

Publish
-Publish Over SSH
