1. Kubernetes (EKS) architecture and its components explanation
Amazon Elastic Kubernetes Service (EKS) architecture includes:
Control Plane (Managed by AWS): API Server, Scheduler, Controller Manager, etcd.
Worker Nodes (Managed by User): EC2 instances running kubelet, container runtime (Docker/containerd), kube-proxy, and network plugin.

# Control plane
The Control Plane in Kubernetes is a group of main parts that manage, control, and keep the Kubernetes cluster running properly. It makes sure the cluster always matches the setup chosen by the user or administrator.

1. API Server (kube-apiserver)
Acts as the front door for all Kubernetes operations.
Exposes the Kubernetes API over HTTP/HTTPS.
All kubectl, UI (Dashboard), and internal component requests go through it.
It's stateful — every change (like creating a pod, service, deployment) goes through the API Server.

Responsibilities:
Authentication & authorization.
Validating requests.
Exposing cluster state.
Communicating with etcd for storing or retrieving cluster data.
Think of it like the brain's communication hub — all commands, reads, and writes pass through here.

2. etcd
etcd is the database of Kubernetes.
It stores the entire cluster state like pods, deployments, configs, secrets, etc.
It is a key-value store, and it is highly available and secure.
If etcd is lost, Kubernetes won’t work properly.

Examples of data stored:
Current and desired state of all objects.
Configuration data.
Cluster metadata and events.
If etcd is lost, your cluster loses its memory. That’s why it's often backed up frequently.

3. Controller Manager – Simple Explanation
Controller Manager is a background process that keeps watching the cluster.
It runs many small programs called controllers.
Each controller checks if the actual state of the cluster matches the desired state.

Controller Name	                What It Does
Node Controller	                Checks if nodes are working. Marks node as "NotReady" if it stops responding.
Replication Controller 	        Ensures the right number of pod replicas are running.
/ ReplicaSet Controller
Deployment Controller	        Manages rolling updates and rollbacks for Deployments.
Job Controller	                Manages batch jobs that should run once and finish.
Service Account Controller	    Creates default accounts for pods to access the API securely.


4. Scheduler – Easy Explanation
The scheduler is assigning pods to the most appropriate nodes based on resource availability and other rules.
It works when a pod is created and is in a "Pending" state (waiting to be scheduled).
The scheduler looks at all available nodes and selects the most suitable one.

When schduling pods it chceks like

Criteria	                    What It Means
CPU & Memory	                Does the node have enough free resources?
Node Affinity	                Does the pod prefer a specific node (based on labels)?
Taints and Tolerations	        Are there any restrictions (like "do not schedule here unless allowed")?
Pod Affinity/Anti-affinity	    Should pods be placed together or kept apart?
Disk/Network	                Does the node support the required storage or networking needs?
Custom rules	                Any other rules defined in pod configuration.

# Worker Node
2. Worker Nodes (Managed by You)
What are Worker Nodes?
Worker nodes are the EC2 instances where your real applications (containers) run.
These nodes are part of the Kubernetes cluster but are not managed by AWS — you manage them.
You can:
    Launch EC2 instances manually
    Use Auto Scaling Groups for automatic scaling
    Or choose Fargate (AWS serverless option) where AWS handles the worker nodes for you

1. Launch EC2 Manually
    You can create EC2 instances manually.
    Then, install the required software (like kubelet and kube-proxy) and join them to the cluster.

2. Use Auto Scaling Groups (ASG)
    This is the most common method.
    EC2 instances are part of an Auto Scaling Group, so they can automatically scale up/down based on load.
    If one node fails, the ASG can automatically replace it.

3. Use AWS Fargate (Optional)
    If you don’t want to manage EC2 instances at all, you can use AWS Fargate.
    With Fargate, AWS automatically provisions and manages the worker nodes for you.
    You only need to define the pod — AWS runs it.    

# Main Components on Worker Nodes    

1. kubelet – Explained Simply
kubelet is a small program (agent) that runs on each worker node in a Kubernetes cluster.
It is responsible for managing the pods running on that node.

How kubelet works:
kubelet communicates with the API server.
It receives pod definitions (YAML specs) that say:
What containers to run
Which image to pull
How much CPU/memory to assign
Volume mounts, environment variables, etc.
It passes these instructions to the container runtime (like Docker or containerd) to run the containers.
kubelet then monitors those containers.

What kubelet does daily:
Task	                        Description
Check pod health	        Ensures all containers are running properly
Restart failed containers	If a container crashes, kubelet will restart it
Sync pod specs	            Keeps the actual state of the pod same as the desired state
Report status	            Sends pod and node status to the API server

2. Kube proxy
kube-proxy is a network tool that runs on every worker node. It helps to send traffic between pods and services. It creates network rules using iptables or IPVS. When a pod tries to access a service, kube-proxy forwards the request to the correct pod. It also balances the traffic if there are many pods behind the service



             +---------------------+
             |   Pod A (frontend)  |
             +---------------------+
                       |
                       | 1. Pod sends request to Service (e.g., http://my-backend)
                       v
            +------------------------+
            |  Service: my-backend   |
            |  ClusterIP: 10.0.0.10  |
            +------------------------+
                       |
                       | 2. kube-proxy intercepts request
                       v
          +------------------------------+
          |  kube-proxy on Worker Node   |
          |  Looks at iptables/IPVS rules|
          +------------------------------+
                       |
                       | 3. Forwards request to one backend pod
                       v
        +------------------+     +------------------+     +------------------+
        |  Pod B (backend) |     |  Pod C (backend) |     |  Pod D (backend) |
        |   10.0.1.2       |     |   10.0.2.3       |     |   10.0.3.4       |
        +------------------+     +------------------+     +------------------+
                 ^                       ^                          ^
                 \_______________________|_________________________/
                             |
                             | 4. kube-proxy load balances traffic

Flow Summary:
Pod A sends a request to a Service (like http://my-backend).
kube-proxy sees this request using its rules.
kube-proxy chooses one of the backend pods (B, C, or D).
The request is routed to that pod.
If another request comes, kube-proxy may choose a different pod (for load balancing).

Tips
kube-proxy is like a traffic manager on each node.
It knows which pod IPs are behind which service.
It helps ensure smooth communication inside the cluster.

3. The container runtime is the tool that runs the actual containers in Kubernetes. When kubelet receives instructions from the API server, it tells the container runtime to pull the image and start the container. Kubernetes commonly uses containerd or Docker as the runtime.


4. CNI Plugin – Easy Explanation
What is CNI?
CNI stands for Container Network Interface.
It is a plugin that handles networking for pods in Kubernetes.
It decides how pods get IP addresses, and how they communicate with each other and with the outside world.

What CNI does:
Gives an IP address to each pod
Connects the pod to the node's network
Makes sure the pod can:
Talk to other pods (on the same or different nodes)
Talk to services
Talk to the internet (if allowed)

In Amazon EKS: VPC CNI Plugin
In EKS, AWS uses the Amazon VPC CNI Plugin.
This plugin assigns a real VPC IP address to each pod.
That means:
Each pod behaves just like an EC2 instance on the VPC network.
You can control pod traffic using Security Groups, Route Tables, and VPC Peering.

---------------------------------------------------------------------------------------------------------------

2. How does Kubernetes handle a pod failure?

How does Kubernetes handle a pod failure?
Kubernetes constantly checks the health of every pod running inside the cluster. It has multiple ways to handle pod failures:
1. Automatic Pod Restart:
Every node in Kubernetes has a component called Kubelet.
Kubelet continuously watches the pods running on that node.
If a pod stops working (crashes or exits), the Kubelet notices this immediately.
It automatically restarts the failed pod on the same node.

Example:
If your web application crashes inside the pod, Kubelet detects this and immediately restarts your pod to bring your application back online quickly.


2. Pod Replacement (by Deployment or ReplicaSet):
Pods are usually managed by controllers like Deployment or ReplicaSet.
These controllers define how many pods should run at any given time (the "desired state").
If a node itself becomes unhealthy, Kubernetes cannot run pods there anymore.
The controller sees fewer pods running than expected and automatically creates new pods on other healthy nodes.

Example:
If one node crashes or shuts down, Kubernetes will notice that pods are missing. It will then launch replacement pods on other available nodes, ensuring your application stays running without manual intervention.

---------------------------------------------------------------------------------------------------------------

3. Difference between kubectl apply and kubectl create

1. kubectl create
Creates new resources only.
If the resource you want to create already exists, kubectl create will fail and show an error.
kubectl create -f my-deployment.yaml

2. kubectl apply
Creates or updates resources.
If the resource doesn't exist, it will create it.
If the resource already exists, it will update the resource based on the changes you've made to the YAML file.
It is idempotent, meaning you can run it multiple times safely—it will only apply new changes or maintain the resource’s desired state without causing errors.

Commonly used to manage resources consistently and reliably.
kubectl apply -f my-deployment.yaml

When to use:
Use kubectl create when you want to ensure you're creating a completely new resource and expect it should not already exist.

Use kubectl apply for ongoing resource management and updates, especially useful in automated deployments and continuous integration setups.

---------------------------------------------------------------------------------------------------------------

4. How does Kubernetes handle networking?

1. Each Pod Gets a Unique IP:
Every pod is assigned its own IP address.
This makes communication between pods simpler (they can use IP addresses directly).
Pods can talk to each other freely across nodes without any need for port mapping or Network Address Translation (NAT).

2. Flat Network Model
All pods can talk to all other pods across nodes without NAT (Network Address Translation).
It’s like putting all pods on a single giant network, even if they are on different VMs.
This is achieved using CNI plugins like:
Flannel – simple overlay network.
Calico – supports routing and network policies.
Weave – another overlay with encryption and DNS.
Amazon VPC CNI – assigns actual VPC IPs to pods in EKS (very efficient).

3. Service Networking (Stable Access)
While pods can change IPs (e.g., when recreated), Services give a stable IP and a DNS name.
Services act as a load balancer over a group of pods (like all pods of an app).
Types of services:
ClusterIP – accessible inside the cluster only.
NodePort – exposes service on a static port on each node.
LoadBalancer – provisions an external load balancer (in cloud).
Headless – no cluster IP, used for direct pod discovery.

4. DNS in Kubernetes
Each service gets a DNS name like my-service.default.svc.cluster.local.
Applications can use these names instead of IPs.
This is managed by CoreDNS, running inside the cluster.

---------------------------------------------------------------------------------------------------------------

5. Difference between StatefulSet vs Deployment

A Deployment in Kubernetes is a controller that manages your application (containerized app) running in Pods.
It helps you with:
Starting pods
Updating them safely
Restarting failed ones
Scaling the app up or down

You define what you want (e.g., 3 replicas of your app), and Kubernetes keeps it running that way.

Field	                                Description
replicas	                        How many pod copies to run
image	                            Which Docker image to run
ports.containerPort	                Port inside container
env	                                Set environment variables
resources	                        Set memory/CPU limits
livenessProbe, readinessProbe	    Health checks
volumeMounts, volumes	            Attach persistent storage
strategy	                        Configure rolling updates

What can a Deployment do?
Create Pods
It creates the app for you using Pods. For example, you can say:
"Hey Kubernetes, I want 3 copies of my app running."
Deployment will create 3 Pods.

Restart Automatically if Crashed
If any Pod crashes or stops, Deployment will create a new one automatically.

Scale Easily
Want to go from 3 Pods to 5? Just change the number, and Deployment will handle the rest.

Update App without Downtime
If you want to change your app version (e.g., v1 to v2), Deployment will replace the old pods one by one — without stopping your app.

# Stateless
What is Stateless?
Stateless App:
Does not remember anything between requests.
Each request is independent.
You can destroy and recreate a pod anytime — no problem.

Examples:
Web servers (like NGINX, Apache)
REST APIs (like Flask, Express.js)
Frontend apps (React, Angular)
Kubernetes Deployment is used for these

# Stateful
What is Stateful?
Stateful App:
Needs to remember something between requests.
Each pod has unique identity and persistent data.
If a pod is deleted, it must come back exactly the same.

Examples:
Databases (MySQL, MongoDB, PostgreSQL)
Messaging apps (Kafka, RabbitMQ)
Kubernetes StatefulSet is used for these

# Stateless App – NGINX Web Server
You request the homepage.
NGINX just serves a static HTML file.
No session, no user-specific data.
You can delete and restart the pod — it works the same.

# Stateful App – MySQL Database
It stores your user data, cart info, order details.
If the MySQL pod restarts, the data must still be there.
So it uses a Persistent Volume.
The pod name must stay the same (mysql-0) so apps can connect to the right one.

Summary:
If the app does not care who you are, or what you did last time → Stateless
If the app needs to remember your data, session, or store information → Stateful

# What is a StatefulSet?
A StatefulSet is a special Kubernetes object used to manage stateful applications — apps that need to remember things, have fixed identities, and use persistent storage.

What Does a StatefulSet Do?
A StatefulSet ensures:
Feature	                            Description
Stable Pod Names	            Each pod has a fixed name like mysql-0, mysql-1, mysql-2
Stable Storage	                Each pod gets its own storage (PVC), and it doesn’t get deleted if the pod crashes
Ordered Startup/Shutdown	    Pods start and stop in order, one by one
Same Identity After Restart	    The pod name and volume stay the same even if the pod restarts

# Difference between StatefulSet vs Deployment

Deployment is for stateless apps (no need to remember data)
StatefulSet is for stateful apps (needs to remember data and identity)

Detailed Comparison Table
Feature                 	Deployment (Stateless)	                    StatefulSet (Stateful)

Use case	            Stateless apps like web servers, APIs	    Stateful apps like databases, Kafka
Pod names	            Random (e.g. nginx-76d4d6d5f5-abcde)	    Fixed (e.g. mysql-0, mysql-1, mysql-2)
Pod identity	        No stable identity	                        Each pod has a stable network ID and hostname
Storage	                Shared or no storage	                    Each pod has its own PersistentVolumeClaim (PVC)
Storage persistence	    Not guaranteed — pods can come/go	        Storage stays even if pod is deleted or restarted
Start/Stop order	    Random, parallel	                        Starts and stops pods in order, one at a time
Scaling behavior	    Fast, parallel scaling	                    Slower, scales in order (pod-0 before pod-1, etc.)
Pod replacement	        Any pod can replace any other	            Only that same pod (pod-0) can be replaced as pod-0
Network Identity (DNS)	Shared service name	                        Each pod gets a unique DNS entry (e.g., mysql-0)

---------------------------------------------------------------------------------------------------------------

6. Rolling updates in Kubernetes and what happens when a node goes down

1. What is a Rolling Update in Kubernetes?
Simple Meaning:
A rolling update is when Kubernetes updates your application by gradually replacing old pods with new ones — without stopping your app.

How it works:
Imagine you want to update your app from version v1 to v2 using a Deployment.
Instead of:
Deleting all old pods first (which would cause downtime ❌)
And then starting new pods

Kubernetes does this step-by-step:
Start 1 new pod with v2
Wait until it’s healthy
Delete 1 old pod with v1
Repeat...
This is called a Rolling Update — like changing tires one at a time on a moving car 🚗

These two fields in your Deployment YAML
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 1

Field	            Meaning
maxSurge	        How many new pods can run in addition to the desired number
maxUnavailable	    How many old pods can be taken down at a time

First, Kubernetes creates 1 extra new pod (v2) → Now total = 4 pods
It checks if that pod is healthy
If healthy ✅ → Kubernetes deletes 1 old pod (v1) → Back to 3 pods
Repeats the process until all pods run the new version (v2)

2. What happens when a node goes down?
Scenario:
You have a cluster with 3 nodes and 6 pods. Suddenly, one node crashes (e.g., AWS EC2 instance stops).

What Kubernetes does:
Controller (Deployment/ReplicaSet) notices some pods are gone.
Kubernetes waits for a bit (default ~5 minutes) to confirm the node is NotReady.
Once confirmed:
    Those pods are marked as failed.
    Scheduler creates new pods on other available nodes.
If you’re using Persistent Volume (EBS/PVC):
    Kubernetes can reattach the storage to the new pod (if configured properly).

---------------------------------------------------------------------------------------------------------------

7. What protocol is used between kubectl and Kubernetes cluster?

1. What is kubectl?
kubectl is the command-line tool used to control and manage Kubernetes.

Example:
kubectl get pods
kubectl apply -f myapp.yaml
These commands send requests to the Kubernetes API Server, which is the brain of the cluster

So… how does kubectl communicate?
Protocol used:
HTTPS (HyperText Transfer Protocol Secure)
It’s like regular HTTP (web browsing) but encrypted and secure.
Prevents data from being seen or modified during communication.

2. What is happening behind the scenes?

Step	        Description
1️⃣	        kubectl reads your kubeconfig file (usually in ~/.kube/config) to find the API server address, cluster info, and authentication tokens
2️⃣	        It connects to the API Server via HTTPS
3️⃣	        The API Server authenticates who you are (via token, certificate, etc.)
4️⃣	        Then it checks if you're authorized to perform the action (RBAC check)
5️⃣	        If allowed, API Server processes the request and sends back the response (e.g., list of pods)
6️⃣	        kubectl displays the response to you in the terminal

---------------------------------------------------------------------------------------------------------------

8. Kubernetes security best practices

1. RBAC (Role-Based Access Control)
What it means:
RBAC controls who can do what inside the cluster.

It lets you define:
Who (user, service account)
Can perform what actions (get, list, create)
On which resources (pods, deployments, secrets)

Example:
You can allow a user to:
Only view pods
But not delete or create them

YAML Example:
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: dev
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]


-----------------------------------------

kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-pods
  namespace: dev
subjects:
- kind: User
  name: devuser
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io

Why it matters:
Limits what users/services can access and protects your cluster from accidental or malicious changes.

2. Namespaces
What it means:
Namespaces provide logical separation of environments inside a Kubernetes cluster.
Think of them like folders or containers to isolate:
Dev, staging, production environments
Different teams or projects
Example:
You can deploy the same app (nginx) into dev and prod namespaces with different configs.

kubectl create namespace dev
kubectl create namespace prod

Prevents one team’s app from interfering with another. Works well with RBAC.

3. Network Policies
What it means:
Network Policies control which pods can talk to which other pods — like a firewall inside Kubernetes.

By default, all pods can talk to each other. Network policies allow you to restrict traffic.

Example:
Allow only frontend pods to talk to backend pods.

YAML Example:
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: app
spec:
  podSelector:
    matchLabels:
      role: backend
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend

Stops attackers from moving sideways between pods and improves internal security.

4. Secrets Management
What it means:
Sensitive data like passwords, tokens, API keys should not be hardcoded in YAML or environment variables.
Use Kubernetes Secrets to store and inject this data securely.

Example
kubectl create secret generic db-password --from-literal=password=MySecurePassword123
Creates a Kubernetes Secret named db-password, storing your database password securely.

Option 1: Mount Secret as an Environment Variable
apiVersion: v1
kind: Pod
metadata:
  name: secret-env-pod
spec:
  containers:
  - name: app
    image: nginx
    env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-password        # Secret name
          key: password            # Key inside the secret

Option 2: Mount Secret as a Volume (File)
apiVersion: v1
kind: Pod
metadata:
  name: secret-volume-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: secret-volume
      mountPath: "/etc/secret"
      readOnly: true
  volumes:
  - name: secret-volume
    secret:
      secretName: db-password

---------------------------------------------------------------------------------------------------------------

9. kubeconfig user authentication
kubeconfig file contains:
Cluster information (API server endpoint)
User credentials (token, client cert, etc.)
Context (which cluster and user)

Authentication methods:
TLS client certificates
Bearer tokens (IAM with EKS)
OIDC (for enterprise identity integration)

---------------------------------------------------------------------------------------------------------------

10. kubectl API protocol
kubectl interacts with the Kubernetes API server using RESTful API over HTTPS.

Supports all HTTP verbs:
GET (read)
POST (create)
PUT/PATCH (update)
DELETE (remove)

---------------------------------------------------------------------------------------------------------------

11. Running Pipelines in Docker

Code is stored in a Git repository, and includes:
- app.py               # Main Python app (e.g., Flask)
- Dockerfile           # Instructions to build Docker image
- requirements.txt     # Python dependencies
- tests/               # Directory with test files (e.g., pytest)
- Jenkinsfile          # CI/CD pipeline definition

CI/CD Pipeline Stages (in Jenkins):
Checkout Code
→ Pull the latest code from Git repository.

Build Docker Image
→ Use Dockerfile to build a container image of the app.

Run Tests
→ Run automated tests (e.g., pytest) inside the Docker container.

Push Docker Image to Registry
→ Push the built image to Docker Hub (or ECR, etc.).

Deploy Application
→ Deploy the new Docker image to the target environment (Kubernetes, VM, etc.).


Jenkinsfile (End-to-End CI/CD using Docker)
pipeline {
  agent any

  environment {
    IMAGE_NAME = "yourdockerhubusername/sampleapp"
    DOCKER_CREDENTIALS_ID = "dockerhub-credentials"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          dockerImage = docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
        }
      }
    }

    stage('Run Tests') {
      steps {
        sh 'docker run --rm ${IMAGE_NAME}:${BUILD_NUMBER} pytest tests/'
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
            dockerImage.push("${BUILD_NUMBER}")
            dockerImage.push("latest")
          }
        }
      }
    }

    stage('Deploy') {
      steps {
        echo "Deploying Docker image ${IMAGE_NAME}:${BUILD_NUMBER}..."
        // Here you can replace with your actual deploy command
        // e.g., `kubectl set image`, `docker-compose up -d`, `scp` to server, etc.
      }
    }
  }

  post {
    success {
      echo "Pipeline completed successfully!"
    }
    failure {
      echo "Pipeline failed!"
    }
  }
}

---------------------------------------------------------------------------------------------------------------

12. EKS setup

1. Configure Cluster
Go to EKS Console → Click “Add Cluster” → “Create”
Choose Custom configuration
Leave EKS Auto Mode enabled (or disable if you want full control)

2. Configure Compute (Auto Mode)
Select built-in node pools:
general-purpose (for app workloads)
system (for Kubernetes components)

Click “Create recommended role” to auto-create an IAM role with required policies:
AmazonEKSWorkerNodePolicy
AmazonEC2ContainerRegistryReadOnly
AmazonEKS_CNI_Policy
    Cluster iam role 
      EKS - Auto Cluster - Allows access to other AWS service resources that are required to operate Auto Mode clusters managed by EKS.
        AmazonEKSBlockStoragePolicy
        AmazonEKSClusterPolicy
        AmazonEKSComputePolicy
        AmazonEKSLoadBalancingPolicy
        AmazonEKSNetworkingPolicy
Select the role after creation

3. Specify Networking
Select your VPC
Choose at least 2 private subnets across different AZs

Example: subnet-abc1, subnet-abc2
(Optional but recommended) Assign custom security group with:
Inbound: SSH (22), HTTPS (443), internal node-to-node rules
Outbound: Allow all
Choose Cluster IP family: IPv4

4. Cluster Endpoint Access
Select Public and Private (for access inside and outside VPC)
Restrict access to your IP by adding your public IP in CIDR block (e.g., 203.0.113.25/32)
Avoid using 0.0.0.0/0 in production

5. Configure Observability
Enable CloudWatch metrics for application & node monitoring
Control Plane Logs (recommended):
API Server
Audit
Authenticator
(Optional) Controller Manager & Scheduler

6. Select Add-ons
Enable:
Node Monitoring Agent (node health)
CoreDNS (service discovery)
kube-proxy (pod networking)

(Optional but recommended for production):
EBS CSI Driver (for volume mounts)
AWS Load Balancer Controller (for ingress/ALB)
Metrics Server (for HPA)
VPC CNI (for custom pod networking)

7. Review and Create
Review all settings
Click “Create”
Wait 10–15 minutes for the cluster to become Active


# Adding Node

1. Go to Your EKS Cluster
Open AWS Console → EKS → Click your cluster name (status should be Active)
Go to Compute → Click “Add Node Gro

2. Configure Node Group
Node group name:
auto-scaling-nodes

Node IAM role:
Choose an existing IAM role or click "Create a new IAM role".
Required policies:
AmazonEKSWorkerNodePolicy
AmazonEKS_CNI_Policy
AmazonEC2ContainerRegistryReadOnly

3. Set Scaling Options
This is where you configure auto scaling behavior:

Setting	Recommended Value
Instance type	t3.medium (or based on workload)
Disk size	20 GiB or more
Desired size	2
Minimum size	1
Maximum size	5
These values define the scaling range for AWS Auto Scaling Group (ASG).

4. Select Subnets
Select at least 2 private subnets (in different Availability Zones) for high availability.

5. (Optional) SSH Access
Add SSH key pair if you want to SSH into worker nodes (for troubleshooting).

6. Review and Create
Click Next, review your settings, and click Create.
AWS will now create a Managed Node Group with auto scaling settings.

it means need to install aws cli and kubctl then i can connect then run command

aws eks --region ap-south-1 update-kubeconfig --name eks-prod

Raw

Cluster iam role 
  EKS - Auto Cluster - Allows access to other AWS service resources that are required to operate Auto Mode clusters managed by EKS.
    AmazonEKSBlockStoragePolicy
    AmazonEKSClusterPolicy
    AmazonEKSComputePolicy
    AmazonEKSLoadBalancingPolicy
    AmazonEKSNetworkingPolicy

Node iam role
  EKS - Auto Node - Allows EKS nodes to connect to EKS Auto Mode clusters and to pull container images from ECR.
    AmazonEC2ContainerRegistryPullOnly
    AmazonEKSWorkerNodeMinimalPolicy




Delete
iam role 
        AmazonRole
        Amazon2eRole


---------------------------------------------------------------------------------------------------------------