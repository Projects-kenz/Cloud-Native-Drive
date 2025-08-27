PREREQUISITES:
-kubectl
-AWS cli
-eksctl

Install using Fargate:
eksctl create cluster --name demo-cluster --region us-east-1 --fargate

Kubeconfig download
 aws eks update-kubeconfig  --name my-proj-cluster --region us-east-1
#Added new context arn:aws:eks:us-east-1:287002303464:cluster/my-proj-cluster to /home/kenzm/.kube/config
it will create kubefonfig locally of the cluster we created (without overriden->since update, you can switch b/w custers using: kubectl config use-context <context-name>)


