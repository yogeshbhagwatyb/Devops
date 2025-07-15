Feature	        Terraform	Ansible
Purpose	        Infrastructure provisioning: used to create, update, and manage cloud infrastructure (e.g., VMs, networks, databases, etc.)	                                     management: used to install software, configure systems, and manage application setups on already existing infrastructure


Language	Declarative using HCL (HashiCorp Configuration Language): you describe what you want, not how to do it	Procedural using YAML + Jinja2: you define how to perform each step to reach the desired state
Use Case	Best for managing cloud infrastructure lifecycle: provisioning resources on AWS, Azure, GCP, etc.	Best for post-provisioning setup: installing packages, setting up users, configuring files, restarting services
Idempotency	Built-in: Terraform knows the current state and only makes changes if needed (using the state file)	Achievable through careful design: you must write tasks in a way that they don’t re-run unnecessarily (e.g., using creates, when, changed_when)
Agentless	Yes: uses provider APIs, no agents required on target machines	Yes: uses SSH or WinRM to connect to hosts; no agents required
Execution Order	Dependency-based: Terraform figures out the order based on resource relationships	Task order is explicit and sequential — you define exactly what runs and when
State Management	Maintains a state file to track infrastructure	No state file — runs are independent unless you track state manually or with facts
Provisioning Scope	Cloud and infrastructure resources (IaaS, PaaS)	OS-level configurations and application deployments

---------------------------------------------------------------------------------------------------------------
1. What is the difference between Ansible and Terraform?

Terraform: Infrastructure provisioning – used to create, update, and manage cloud infrastructure (e.g., VMs, networks, databases, etc.)
Ansible: Configuration management – used to install software, configure systems, and manage application setups on already existing infrastructure

Feature: Language
Terraform: Declarative using HCL (HashiCorp Configuration Language) – you describe what you want, not how to do it
Ansible: Procedural using YAML + Jinja2 – you define how to perform each step to reach the desired state

Feature: Use Case
Terraform: Best for managing cloud infrastructure lifecycle – provisioning resources on AWS, Azure, GCP, etc.
Ansible: Best for post-provisioning setup – installing packages, setting up users, configuring files, restarting services

Feature: Idempotency
Terraform: Built-in – Terraform knows the current state and only makes changes if needed (using the state file)
Ansible: Achievable through careful design – you must write tasks in a way that they don’t re-run unnecessarily (e.g., using creates, when, changed_when)

Feature: Agentless
Terraform: Yes – uses provider APIs, no agents required on target machines
Ansible: Yes – uses SSH or WinRM to connect to hosts; no agents required

Feature: Execution Order
Terraform: Dependency-based – Terraform figures out the order based on resource relationships
Ansible: Task order is explicit and sequential – you define exactly what runs and when

Feature: State Management
Terraform: Maintains a state file to track infrastructure
Ansible: No state file – runs are independent unless you track state manually or with facts

Feature: Provisioning Scope
Terraform: Cloud and infrastructure resources (IaaS, PaaS)
Ansible: OS-level configurations and application deployments

---------------------------------------------------------------------------------------------------------------

2. If Terraform execution fails midway, will EC2 instance get created or not?

Answer: It depends on when and where the failure happens in the execution plan.
Terraform works in 2 major steps:
Plan Phase – Calculates what changes need to be made, but doesn’t touch real resources yet.
Apply Phase – Actually makes changes to your infrastructure, step by step.

Scenarios:
1. EC2 creation happens before the failure
Suppose your Terraform configuration contains:
    A VPC
    A security group
    An EC2 instance
    An EBS volume attached to the EC2 instance
Terraform starts applying the plan:
    VPC is created 
    Security group is created 
    EC2 instance is created
    EBS volume fails due to a typo ❌

Result:
The EC2 instance is already created in AWS. Even though the overall apply failed, partial resources are provisioned.

2. Failure occurs before EC2 step
Let’s say a dependency (like a security group) fails before EC2 creation:
    VPC is created
    Security group fails due to invalid CIDR block ❌
    EC2 creation never started ❌
Result:
No EC2 instance is created, because Terraform never reached that part of the plan.

---------------------------------------------------------------------------------------------------------------

3. If we run Terraform script again, will it create new resources or update existing ones?
Terraform checks the state file and compares it with the real infrastructure:
If nothing changed → No action
If config is changed → Terraform updates the resource
If resource is removed from config → Terraform deletes it

---------------------------------------------------------------------------------------------------------------

4. What is Terraform import and how to use it?

---------------------------------------------------------------------------------------------------------------

5. Terraform state and its purpose

The Terraform state file (terraform.tfstate) is a critical part of how Terraform works.
It stores everything Terraform knows about the infrastructure you've created.

What is terraform.tfstate?
It is a JSON file that contains:
A record of all resources Terraform manages
Their current real-world values (IDs, IPs, ARNs, etc.)
Information about resource dependencies
Outputs and data sources

Why is Terraform state important?
1. Tracks real infrastructure
Terraform uses the state file to track which resources it created.
Example: If you created an EC2 instance, its instance ID is saved in the state file.
Next time you run terraform plan, it compares this state to your .tf code.

2. Detects changes
Terraform compares:
    What’s in the state file
    What’s defined in your code
    What’s running in real infrastructure (via provider APIs)
Based on this, it decides whether to:
    Create
    Update
    Destroy resources

3. Stores metadata and dependencies
State stores metadata like:
VPC ID, subnet ID, security group names, etc.
It understands which resource depends on which, so it can apply/destroy in the correct order.

4. Enables collaboration via remote backends
In teams, the state file must be shared (so everyone sees the same infrastructure state).
Remote backends like Amazon S3, Azure Blob, or Terraform Cloud allow:
Locking (to avoid conflicts)
Versioning
Centralized state

---------------------------------------------------------------------------------------------------------------

6. In your project where you stored your state file
Common options:
Local file: terraform.tfstate in the project directory (used in simple setups)
Remote backend: e.g., AWS S3 + DynamoDB (for team collaboration, locking, and history)

---------------------------------------------------------------------------------------------------------------

8. During an infrastructure upgrade using terraform apply, we realize midway that something is wrong and need to abort the process. However, some resources (e.g., servers) have already been upgraded. How would you handle rolling back the infrastructure to its previous stable state?

1. Stop Further Changes Immediately
If the issue is noticed during terraform apply, interrupt the process (Ctrl+C). This might leave some resources partially updated.

2. Analyze the Terraform State File
Inspect the terraform.tfstate file to see what changes have already been applied. This gives insight into which resources are in a modified state.

3. Use Version Control for Rollback
If the previous stable Terraform configuration is stored in version control (e.g., Git), check out the last known good commit.
Steps:
    Check your Git history
    Run git log to find the commit where everything was working correctly.

    Switch to that stable version
    Use git checkout <commit-id> or git checkout main if the stable version is on the main branch.

    Run terraform plan
    This shows what Terraform would change to bring the current (partially upgraded) infrastructure back to match the older configuration.

    Run terraform apply
    Apply the changes to restore your infrastructure to its previous, stable version.




8. How do you roll back when something goes wrong in terraform apply but partial resources are created?
Terraform has no native rollback.
Use terraform destroy to delete partially created infra (careful!).

Best practice:
Use terraform plan carefully before apply.
Use terraform workspace for safe environments.
Use version control on .tf files for rollback.


---------------------------------------------------------------------------------------------------------------

9. When to choose Terraform over Ansible and vice versa?
Use Terraform when:
You need to provision infrastructure (e.g., VPCs, EC2s, EKS, RDS).

Use Ansible when:
You need to configure servers/applications (e.g., install NGINX, update OS, deploy code).

---------------------------------------------------------------------------------------------------------------

10. What Terraform code would you use to determine the operating system of a server?

In Terraform, the operating system is usually determined at provisioning time, not "retrieved" afterward. This is typically set via the AMI (for AWS) or image reference (for Azure).

Terraform does not directly "retrieve" the OS of an existing server. But if you are creating a server using Terraform, you can determine or define the operating system through the AMI (in AWS) or image reference (in Azure).

If the server is already created, you can retrieve the OS info via data sources or remote-exec provisioner.
Example using remote-exec:
resource "null_resource" "check_os" {
  connection {
    type     = "ssh"
    host     = aws_instance.example.public_ip
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = ["uname -a"]
  }
}


2. To find out which operating system or details an AMI ID refers to, I use the aws_ami data source in Terraform.
I provide the AMI ID as a filter, and then I can output properties like the AMI name or description, which usually include the OS type.

For example:
data "aws_ami" "example" {
  filter {
    name   = "image-id"
    values = ["ami-0c55b159cbfafe1f0"]
  }
  owners = ["099720109477"] # Canonical for Ubuntu, or 'amazon' for official images
}

output "ami_name" {
  value = data.aws_ami.example.name
}
output "ami_description" {
  value = data.aws_ami.example.description
}

When I run terraform apply, it outputs the AMI’s name and description—so I can easily see which OS the instance uses.

This is especially useful when we inherit infrastructure or use parameterized AMI IDs, and we want to verify what OS or version is being launched, right from our Terraform outputs—without logging into the AWS Console.
By outputting the AMI name and description, I can confirm if, for example, the AMI is "Ubuntu 20.04 LTS", "Amazon Linux 2", or another OS, just by reading the output of the Terraform plan or apply.

To find out which operating system an AMI ID uses, I add the aws_ami data source in my Terraform code.
I give the AMI ID as a filter, and then I use outputs to show details like the AMI name or description. These usually tell me the OS type.


---------------------------------------------------------------------------------------------------------------

