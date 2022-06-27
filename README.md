# aws-terraform-eks-deployment

Prerequisite:

1.  Install terraform and configure aws cli on your local linux distribution machine
    1.  Terraform
    2.  AWS CLI

Usage:
 
2.  Initialize terraform
    
        terraform init

2.  Format terraform files
    
        terraform fmt
    
3.  Validate that the terraform files were configured correctly
    
        terraform validate

4.  Issue terraform plan to preview the infrastructure plan that will be deployed to AWS
    
        terraform plan

5.  Issue terraform apply to deploy the infrastructure to AWS
    
        terraform apply

6.  Once terraform has finished deploying the infrastructure, install kubectl agent on you local linux distribution machine
      
        $ curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl
        
        $ chmod +x ./kubectl
        
        $ mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
        
        $ kubectl version --short --client
      
7.  Connect your local linux distribution machine to the aws eks cluster
        
        $ aws eks update-kubeconfig --region <region> --name <eks_cluster_name>
        
8.  Download the internal_and_external_loadbalancer.yml file and Use kubectl to configure the internal and external loadbalancer which can be used to access application deployed in eks

        $ kubectl apply -f internal_and_external_loadbalancer.yml
