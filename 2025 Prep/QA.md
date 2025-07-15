# Cloud Infrastructure Management: Provisioned and managed a wide range of AWS services 
including EC2, VPC, EBS, Load Balancers, Auto Scaling, Cloud Front, IAM, S3, Route 53, EFS, 
FSX, AMI, SNS, RDS, Cloud Watch, Cloud Trail, Cloud Formation, and AWS Config to build 
scalable, secure, and highly available cloud architectures.

# Q1. How do you usually provision AWS infrastructure?
A:
I primarily use Terraform to provision AWS infrastructure as code. I write reusable modules for resources like EC2, VPC, and security groups. I manage Terraform state remotely in S3 with locking via DynamoDB, and use environment-based variable files for dev/staging/prod deployments.

# Q2. Can you explain the steps you follow to launch a secure and highly available EC2 instance?
A:
Sure. I do the following:
Create a VPC with public/private subnets in multiple availability zones.
Attach a security group with only necessary inbound rules (e.g., SSH from my IP).
Launch EC2 in a private subnet with IAM roles and proper tagging.
Use an Auto Scaling Group and an ALB to distribute traffic and ensure high availability.
Use user-data scripts or Ansible to configure the instance at launch.
Monitor with CloudWatch and store logs in S3.

# Q3. How have you used Auto Scaling and Load Balancers in your projects?
A:
I’ve configured Auto Scaling Groups to launch or terminate EC2 instances based on CloudWatch alarms — for example, CPU > 70% triggers scale-out.
I’ve used Application Load Balancers to route traffic to different target groups based on path (e.g., /api vs /web) and set health checks to remove unhealthy instances

