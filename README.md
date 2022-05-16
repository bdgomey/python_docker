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

# Set up EBS Storage for EKS 


Download an example IAM policy with permissions that allow your worker nodes to create and modify Amazon EBS volumes:

    curl -o example-iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/v0.9.0/docs/example-iam-policy.json

Create an IAM policy named Amazon_EBS_CSI_Driver:

    aws iam create-policy --policy-name AmazonEKS_EBS_CSI_Driver_Policy --policy-document file://example-iam-policy.json

View your cluster's OIDC provider URL:

    
    aws eks describe-cluster --name your_cluster_name --query "cluster.identity.oidc.issuer" --output text



### Note: In step 3, replace your_cluster_name with your cluster name.

Create the following IAM trust policy file:



    cat <<EOF > trust-policy.json
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Federated": "arn:aws:iam::YOUR_AWS_ACCOUNT_ID:oidc-provider/oidc.eks.YOUR_AWS_REGION.amazonaws.com/id/<XXXXXXXXXX45D83924220DC4815XXXXX>"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
            "StringEquals": {
            "oidc.eks.YOUR_AWS_REGION.amazonaws.com/id/<XXXXXXXXXX45D83924220DC4815XXXXX>:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
            }
        }
        }
    ]
    }
    EOF

### Note: In step 4, replace YOUR_AWS_ACCOUNT_ID with your account ID. Replace YOUR_AWS_REGION with your AWS Region. Replace XXXXXXXXXX45D83924220DC4815XXXXX with the value returned in step 3. 

Create an IAM role:

    aws iam create-role \
    --role-name AmazonEKS_EBS_CSI_DriverRole \
    --assume-role-policy-document file://"trust-policy.json"

Attach your new IAM policy to the role:

    aws iam create-role \
    --role-name AmazonEKS_EBS_CSI_DriverRole \
    --assume-role-policy-document file://"trust-policy.json"

Attach your new IAM policy to the role:

    aws iam attach-role-policy \
    --policy-arn arn:aws:iam::111122223333:policy/AmazonEKS_EBS_CSI_Driver_Policy \
    --role-name AmazonEKS_EBS_CSI_DriverRole

To deploy the Amazon EBS CSI driver, run one of the following commands based on your Region:

All Regions other than China Regions:

    kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

Annotate the ebs-csi-controller-sa Kubernetes service account with the Amazon Resource Name (ARN) of the IAM role that you created earlier:

    kubectl annotate serviceaccount ebs-csi-controller-sa \
    -n kube-system \
    eks.amazonaws.com/role-arn=arn:aws:iam::YOUR_AWS_ACCOUNT_ID:role/AmazonEKS_EBS_CSI_DriverRole



Note: Replace YOUR_AWS_ACCOUNT_ID with your account ID.

Delete the driver pods:

    kubectl delete pods \
    -n kube-system \
    -l=app=ebs-csi-controller

Test the Amazon EBS CSI driver:

You can test your Amazon EBS CSI driver with an application that uses dynamic provisioning. The Amazon EBS volume is provisioned on demand.

Clone the aws-ebs-csi-driver repository from AWS GitHub:

    git clone https://github.com/kubernetes-sigs/aws-ebs-csi-driver.git

Change your working directory to the folder that contains the Amazon EBS driver test files:

    cd aws-ebs-csi-driver/examples/kubernetes/dynamic-provisioning/

Create the Kubernetes resources required for testing:

    kubectl apply -f manifests/

### Note: The kubectl command creates a StorageClass (from the Kubernetes website), PersistentVolumeClaim (PVC) (from the Kubernetes website), and pod. The pod references the PVC. An Amazon EBS volume is provisioned only when the pod is created.

Describe the ebs-sc storage class:

    kubectl describe storageclass ebs-sc

Watch the pods in the default namespace and wait for the app pod's status to change to Running. For example:

    kubectl get pods --watch

View the persistent volume created because of the pod that references the PVC:

    kubectl get pv

View information about the persistent volume:

    kubectl describe pv your_pv_name

### Note: Replace your_pv_name with the name of the persistent volume returned from the preceding step 6. The value of the Source.VolumeHandle property in the output is the ID of the physical Amazon EBS volume created in your account.

Verify that the pod is writing data to the volume:

    kubectl exec -it app -- cat /data/out.txt

### Note: The command output displays the current date and time stored in the /data/out.txt file. The file includes the day, month, date, and time.



