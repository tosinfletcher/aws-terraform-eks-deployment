pipeline {
    parameters {
    string(name: 'BRANCH', defaultValue: 'master', description: 'Branch to Build')
    }
    agent any

    stages {
        stage('Deploy EKS Cluster') {
            steps {
                withAWS(credentials: 'aws_cred', region: 'us-east-1') {
                    sh 'terraform init'
                    sh 'terraform validate'
                    sh 'terraform plan'
                    sh 'terraform apply --auto-approve'
                }
            }
        }
        stage('Connect Kubectl Agent to EKS') {
            steps {
                withAWS(credentials: 'aws_cred', region: 'us-east-1') {
                    sh 'aws eks update-kubeconfig --region us-east-1 --name eks_cluster'
                    sh 'kubectl get svc'
                }
            }
        }
        stage('Deploy EKS int and ext Loadbalancer') {
            steps {
                withAWS(credentials: 'aws_cred', region: 'us-east-1') {
                    sh 'kubectl apply -f ./internal_and_external_loadbalancer.yml'
                }
            }
        }
    }
}