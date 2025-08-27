# PREREQUISITES:
-kubectl  
-AWS cli  
-eksctl  

# Install using Fargate:
eksctl create cluster --name demo-cluster --region us-east-1 --fargate  

# Kubeconfig download:
 aws eks update-kubeconfig  --name my-proj-cluster --region us-east-1  

#Added new context arn:aws:eks:us-east-1:287002303464:cluster/my-proj-cluster to /home/kenzm/.kube/config  
it will create kubefonfig locally of the cluster we created (without overriden->since update, you can switch b/w custers using: kubectl config use-context <context-name>)  

# Fargate Profile:
eksctl create fargateprofile \
    --cluster demo-cluster \
    --region us-east-1 \
    --name alb-sample-app \
    --namespace game-2048  

#inorder to let the app to deploy in "game-2048" namespace we have to create a fargate profile that congig "game-2048" namespace.  

# Apply Manifests:
 Deployment.yml,   
Service.yaml,  
 Ingress.yaml  

# Associate iam OIDC Provider (before alb controller):
eksctl utils associate-iam-oidc-provider --cluster my-proj-cluster --approve  

#Since ALB controller (k8s cluster) need to access Application Load Balancer of AWS account)  


# CREATE IAM POLICY & ROLE FOR ALB TO CREATE ALB AND CONFIGURE TARGET GROUP etc..:
## policy:  
download: curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.13.3/docs/install/iam_policy.json  

create iam-policy: aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json  

## create service account and attach the policy/role:
### create service account by explicitly stating role name for better control over roles  
eksctl create iamserviceaccount \
  --cluster=<your-cluster-name> \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve  
  
### create service account and let eksctl auto generate rolename also includes "--override-existing-serviceaccounts"
eksctl create iamserviceaccount \
    --cluster=<cluster-name> \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::<AWS_ACCOUNT_ID>:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --region <aws-region-code> \
    --approve  

Use the first one if you want predictable, named IAM roles (recommended for production).  
Use the second one if you just want a quick setup and don’t care about the IAM role name (common for test/dev clusters).  


# INSTALL LoadBalancer Controller
Add Repo: helm repo add eks https://aws.github.io/eks-charts  
  
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
  --set clusterName=my-proj-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=vpc-0ee8e314591b20234  
  
  
