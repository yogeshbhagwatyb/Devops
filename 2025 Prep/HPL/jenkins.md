1. What are the Jenkins server creation prerequisites?
Java (JDK): Jenkins requires Java (usually JDK 8 or 11).
Hardware: Minimum 1 CPU, 1GB RAM (more for large builds).
OS: Linux/Windows/Mac (Linux preferred for production).
Network: Stable internet for plugin downloads.
Access: Permissions to install and run Jenkins.
Ports: Default port 8080 open.

-------------------------------------------------------------------------------------------------------------

2. If Jenkins server is down, what will you do? Debugging steps
Check Service: systemctl status jenkins (Linux) or check Windows services.
Logs: Check /var/log/jenkins/jenkins.log for errors.
Ports: Ensure port 8080 (or configured port) is not blocked.
Java: Make sure Java is installed and compatible.
Disk Space: Verify sufficient disk space.
Restart Service: Try systemctl restart jenkins.
Resource Utilization: Check CPU, memory usage.
Plugin Issues: Disable recent plugins if Jenkins fails after updates.

-------------------------------------------------------------------------------------------------------------

3. What are all plugins you’re using while integrating Jenkins for CI/CD?
Git/GitHub Plugin: For source code management.
Pipeline: For pipeline jobs (Declarative/Scripted).
Credentials Binding: For handling secrets/credentials.
Blue Ocean: Modern UI for pipelines.
Email Extension: For email notifications.
Slack/Teams Notification: For build notifications.
Docker: For Docker-based builds/deployments.
Kubernetes: For integrating with K8s.
(Customize based on your actual plugins used!)

-------------------------------------------------------------------------------------------------------------

4. What are the steps to install Jenkins?
Install Java: sudo apt install openjdk-11-jre (Debian/Ubuntu)
Add Jenkins repo: Import Jenkins key, add Jenkins repo.
Install Jenkins: sudo apt install jenkins
Start Jenkins: sudo systemctl start jenkins
Access Jenkins: Visit http://<server-ip>:8080
Unlock Jenkins: Use initial admin password from /var/lib/jenkins/secrets/initialAdminPassword
Install Plugins: As per need.

-------------------------------------------------------------------------------------------------------------

5. How to transfer Jenkins from one region to another or migrate to another server?
Backup Jenkins Home: Copy /var/lib/jenkins (jobs, plugins, configs).
Install Jenkins on New Server: Repeat installation steps.
Copy Backup: Restore Jenkins Home to new server.
Update Configs: Fix any path, credential, or network changes.
Restart Jenkins: Verify functionality.

Explanation
Step 1: Backup Jenkins Home Directory
The Jenkins home directory (commonly /var/lib/jenkins) contains all jobs, plugins, configurations, and credentials.

# Stop Jenkins to avoid changes during backup
sudo systemctl stop jenkins

# Compress the Jenkins home directory
sudo tar -czvf jenkins-backup.tar.gz /var/lib/jenkins

Step 2: Install Jenkins on the New Server

Step 3: Restore Jenkins Backup on the New Server
1. Remove the default Jenkins home content
sudo rm -rf /var/lib/jenkins/*
What it does:
Deletes everything inside /var/lib/jenkins on the new server.
Why:
When you install Jenkins on a new server, it creates some default folders and files. We remove these so we can replace them with your old Jenkins data (jobs, configs, etc.) from the backup.
Note:
Only do this on the new server, not on the source (old) server!

2. Copy backup file to new server
scp jenkins-backup.tar.gz <new-server>:/tmp/
What it does:
Uses the scp command to securely copy your backup file (jenkins-backup.tar.gz) from your old server to the /tmp/ folder on the new server.
Replace <new-server> with your actual new server’s address or hostname.

3. Extract backup
sudo tar -xzvf /tmp/jenkins-backup.tar.gz -C /  
# (Why to /?
Because your backup was made as a full path backup (it contains /var/lib/jenkins inside it).
Extracting to / will re-create the /var/lib/jenkins folder and put all your Jenkins files and folders there.
)

What it does:
Unpacks (extracts) the contents of jenkins-backup.tar.gz into the root (/) directory.
Why:
Your backup contains the /var/lib/jenkins folder structure. Extracting to / will place all the contents into the correct place (/var/lib/jenkins), recreating your Jenkins data as it was on the old server.

4. Set proper ownership
sudo chown -R jenkins:jenkins /var/lib/jenkins
What it does:
Changes the ownership of all files and folders inside /var/lib/jenkins to the jenkins user and group.
Why:
Jenkins runs as the jenkins user. If the files belong to root or some other user, Jenkins won’t be able to access or use them.


Step 4: Update Configurations if Needed
Check and update:
Jenkins URL: (Manage Jenkins > Configure System)
Credentials: Some credentials may be OS/hostname dependent.
File paths: If jobs/scripts reference absolute paths, update as required.
Network/Firewall: Open port 8080 or custom Jenkins port.
Plugins: Update/verify plugin compatibility.

Step 5: Start Jenkins and Verify
sudo systemctl start jenkins

# Another way
Creating an AMI (Amazon Machine Image) of your Jenkins VM and launching it in another region is an excellent and very common way to migrate Jenkins (or any server) in AWS.

Challenges with AMI-based Jenkins Migration
1. OS Lock-in
AMI is tied to the OS: You cannot change the operating system or upgrade the OS during migration.
Inflexible: No easy way to move to a newer OS version, different Linux distribution, or Windows.

2. Cloud Platform Lock-in
AWS only: AMI works only within AWS. You cannot use the same image for Google Cloud, Azure, or on-premises servers.

3. Instance Type/Region Compatibility
Not all instance types or regions support all AMIs: Very old AMIs or those using deprecated features might not launch everywhere.
Possible errors if architecture (ARM vs x86) or virtualization type is not supported.

4. Disk Size and Volume Issues
Disk size is fixed: You get the same disk size as the original image, and resizing requires extra manual steps.
Snapshot limits: Large volumes make AMI creation/copying slower.

5. Configuration Drift
Copies everything as-is: Old logs, temporary files, and unused packages will also be present in the new server.
No clean-up: Junk or old configurations are also cloned.

6. Security & Credentials
Hardcoded secrets: Any secrets, keys, or passwords stored on the OS are copied over. This can be a risk if not cleaned up before AMI creation.

SSH keys/user accounts: All users and SSH keys on the old server are copied.

7. Networking & Hostname Issues
IP/DNS changes: The new server will have a different private/public IP and possibly a different hostname.

Hardcoded values: If Jenkins or scripts use hardcoded hostnames/IPs, you may need to update configurations.

8. Jenkins Master-Slave/Agent Setup
If using Jenkins agents (slaves), you may need to re-register agents with the new master or update their connections.

9. Licenses and Third-party Tools
Licensed software: Some third-party tools or plugins may be licensed to the original server’s MAC address or hostname.

May require re-activation after migration.

10. Downtime and Consistency
Risk of missing data: If Jenkins was running while you created the AMI, you might miss the most recent jobs or builds.

Recommended to stop Jenkins before AMI creation for a consistent snapshot.

11. Size and Speed
Large AMIs take time: If your Jenkins server has large amounts of data (artifacts, builds, logs), AMI creation, copy, and launch can be slow.

12. IAM/Permissions
Need right permissions: Your AWS IAM user needs the ability to create, copy, and launch AMIs in both regions.


-------------------------------------------------------------------------------------------------------------

6. Which script is used in writing CI/CD pipelines?
Groovy Script: Jenkins pipelines (both Declarative and Scripted) use Groovy-based DSL.

-------------------------------------------------------------------------------------------------------------

7. Differences between Declarative Pipeline vs Scripted Pipeline
Aspect	            Declarative	                    Scripted
Syntax	            Structured, YAML-like	        Pure Groovy, flexible
Readability     	Easier, more standardized   	More complex, powerful
Error Handling  	Built-in	                    Manual
Example	            pipeline { ... }	            node { ... }

-------------------------------------------------------------------------------------------------------------

8. Pipeline syntaxes

Declarative: Uses pipeline {} block, defines agents, stages, steps.
Scripted: Uses node {} block, with explicit Groovy scripting.
Both use steps like stage, steps, sh, bat, echo, etc.

1. Declarative Pipeline Syntax
Most commonly used!
Structure:
Begins with pipeline {} and uses blocks like agent, stages, and steps.
Easy to read and maintain; less flexible but more user-friendly.
Best for: Most use-cases, especially for teams and newcomers.

pipeline {
    agent any         // Where to run the pipeline (any available node)
    environment {
        MY_VAR = "Hello, Jenkins!"
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building the project...'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying application...'
            }
        }
    }
    post {
        always {
            echo 'This always runs!'
        }
        success {
            echo 'Job succeeded!'
        }
        failure {
            echo 'Job failed!'
        }
    }
}

Key features:
agent: Defines where the pipeline runs.
stages: Contains one or more stage blocks, each with its own steps.
environment: Set environment variables.
post: Actions to run after the pipeline (like notifications).

node {
    stage('Build') {
        echo 'Building the project...'
    }
    stage('Test') {
        echo 'Running tests...'
    }
    stage('Deploy') {
        echo 'Deploying application...'
    }
    if (currentBuild.result == 'SUCCESS') {
        echo 'Build succeeded!'
    } else {
        echo 'Build failed!'
    }
}

Example: A Real-World Jenkinsfile

Declarative:
pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your/repo.git'
            }
        }
        stage('Build') {
            steps {
                sh 'make build'
            }
        }
        stage('Test') {
            steps {
                sh 'make test'
            }
        }
    }
    post {
        always {
            mail to: 'team@example.com',
                 subject: "Build ${currentBuild.fullDisplayName}",
                 body: "Check results at ${env.BUILD_URL}"
        }
    }
}


Scripted:
node {
    stage('Checkout') {
        git 'https://github.com/your/repo.git'
    }
    stage('Build') {
        sh 'make build'
    }
    stage('Test') {
        sh 'make test'
    }
    if (currentBuild.result == null || currentBuild.result == 'SUCCESS') {
        mail to: 'team@example.com',
             subject: "Build Success",
             body: "Check results at ${env.BUILD_URL}"
    } else {
        mail to: 'team@example.com',
             subject: "Build Failed",
             body: "Check results at ${env.BUILD_URL}"
    }
}

-------------------------------------------------------------------------------------------------------------

9. How to establish automation from repository to CI/CD pipelines?
Webhooks: Set up SCM webhooks (e.g., GitHub/GitLab) to trigger Jenkins on code push.
SCM Polling: Jenkins polls repo for changes.
Pipeline as Code: Use Jenkinsfile in repo.

-------------------------------------------------------------------------------------------------------------

10. What are the security tools used in your pipeline and how do you integrate those to Jenkins?
Static Code Analysis: SonarQube, integrated as a Jenkins build step.
Dependency Scanning: OWASP Dependency-Check, run as part of pipeline.
Container Scanning: Trivy, Aqua, or Clair, executed using Jenkins plugins or shell scripts.
Secrets Scanning: GitLeaks or custom scripts in the pipeline.

Credential Management: Use Jenkins Credentials plugin.
    Using Jenkins Credentials plugin to store access keys, secret keys, and database username/passwords is absolutely considered a security tool and best practice for "Credential Management" in Jenkins pipelines.
    Credential Management:
    Storing sensitive information like cloud access keys, secret keys, and database credentials securely using the Jenkins Credentials plugin.
    This prevents hardcoding secrets in scripts or code repositories, reducing the risk of accidental leaks.

    In our pipeline, we use the Jenkins Credentials plugin to securely manage and inject secrets such as AWS access keys, secret keys, and database credentials (username and password). This ensures that sensitive information is not exposed in the code or logs, and only authorized jobs and users can access these credentials through the Jenkins UI.

-------------------------------------------------------------------------------------------------------------

11. What are the security measures used for Jenkins?
1. Restrict access using Role-Based Access Control (RBAC)
What it means: Assign specific roles and permissions to users or groups, so that only authorized people can perform sensitive actions.
How to implement: Use plugins like Role-based Authorization Strategy or integrate with LDAP/Active Directory.
Example: Developers can only see their jobs, admins can manage system settings, and deployers can only trigger deployments.

2. Use HTTPS (TLS) for UI and API
What it means: Secure Jenkins web interface and REST API by encrypting all data in transit.
How to implement: Set up an SSL certificate (self-signed or from a CA) and configure Jenkins (or its reverse proxy, like Nginx/Apache) to serve over https:// instead of http://
Why: Prevents password and token theft via network sniffing.

3. Keep Jenkins and plugins up-to-date
What it means: Always run the latest stable versions of Jenkins core and installed plugins.
How to implement: Regularly check the Jenkins "Manage Jenkins > Updates" section, and update plugins/core when security patches are available.
Why: Vulnerabilities are frequently found and fixed in Jenkins and its plugins. Running old versions exposes your server to known exploits.

4. Use strong admin credentials
What it means: Admin users should use long, complex passwords and/or multi-factor authentication.
How to implement: Enforce password policies, and never use default credentials. Use single sign-on (SSO) or connect to corporate identity providers when possible.
Why: Protects Jenkins from brute-force or credential stuffing attacks.

5. Store credentials in Jenkins secrets, never in plain text
What it means: Use Jenkins’ built-in Credentials storage to manage all sensitive info (API keys, DB passwords, etc.) securely.
How to implement:
Add credentials in "Manage Jenkins > Credentials".
Reference them in pipelines with the withCredentials block.
Never hardcode passwords/tokens in scripts, code, or job configs.
Why: Protects secrets from accidental leaks and keeps them encrypted at rest.

6. Limit plugin installation to trusted plugins
What it means: Only install plugins from the official Jenkins update center or from trusted sources.
How to implement:
Regularly review installed plugins and remove any not in use.
Check plugin reputation, maintenance status, and reviews before installing.
Why: Third-party plugins can introduce vulnerabilities if not properly vetted.

User creation and assign roles RBAC Role based access control
1. Admin creates user manually
Go to Manage Jenkins > Manage Users
Click Create User
Fill in:
Username: e.g., developer01
Password: (create a secure temporary password)
Full name: e.g., Dev User
Email address: e.g., developer01@example.com
Crete user

2. Install and Configure the Role-based Authorization Strategy Plugin
Install Plugin
Go to Manage Jenkins > Manage Plugins > Available
Search for Role-based Authorization Strategy
Click Install without restart
Enable Plugin
Go to Manage Jenkins > Configure Global Security
Under Authorization, select Role-Based Strategy
Click Save

3. Assign the 'developer' Role to the New User
Go to Manage Jenkins > Manage and Assign Roles > Assign Roles
Under Global roles:
In the top row, enter the new username (developer01)
Under the developer column, check the box for that user
Click Save

4. Give Credentials to the User
Send the user (e.g., developer01) the following info:
Jenkins URL (e.g., http://your-jenkins-server:8080/)
Username: developer01
Password: (the password you set)
Optional: Ask them to change their password after first login

Step	                    Action
Create user	            Manage Jenkins → Manage Users → Create User
Install plugin	        Manage Jenkins → Manage Plugins → Role-based Strategy
Enable plugin	        Manage Jenkins → Configure Global Security → Role-based
Create role	            Manage Jenkins → Manage and Assign Roles → Manage Roles
Assign role	            Manage Jenkins → Manage and Assign Roles → Assign Roles


-------------------------------------------------------------------------------------------------------------

13. What are the different ways of merging in git?
Merge: Combine branches, creates a merge commit.
Rebase: Replay commits on another branch, results in linear history.
Squash merge: Combine all changes into a single commit.
Fast-forward merge: Directly moves the branch pointer if there are no diverging changes.

-------------------------------------------------------------------------------------------------------------

14. We have Jenkins setup, and they gave security product which is in ruby language, you need to run it before deploying. How to do this?

Question Meaning (Simple Explanation)
Your Jenkins pipeline is responsible for building and deploying applications.
Your security team (or company) has given you a security scan tool (a script or app) written in Ruby.
You are required to run this Ruby-based security check automatically before deployment—so no deployment should happen unless this security check passes.

What Should You Do?
You need to:
Ensure Ruby is installed on your Jenkins build server or agent.
Add a step to your Jenkins pipeline (in Jenkinsfile or job config) that runs the Ruby script before the deployment steps.
Check if the Ruby script succeeds—if it fails, stop the deployment.

Add Ruby Script Step to Jenkinsfile
If you use a Jenkinsfile (Declarative Pipeline):

    pipeline {
    agent any
    stages {
        stage('Build') {
        steps {
            echo 'Building...'
            // your build commands here
        }
        }
        stage('Security Scan') {
        steps {
            // Replace with your real Ruby script path
            sh 'ruby /path/to/security_check.rb'
        }
        }
        stage('Deploy') {
        steps {
            // your deploy steps here
        }
        }
    }
    }

# For scripted
    node {
        stage('Build') {
            echo 'Building...'
            // your build commands here
        }
        stage('Security Scan') {
            // Replace with your real Ruby script path
            sh 'ruby /path/to/security_check.rb'
        }
        stage('Deploy') {
            // your deploy steps here
        }
    }

If Using a Freestyle Job (Not Pipeline)
    ruby /path/to/security_check.rb


-------------------------------------------------------------------------------------------------------------

15. How to integrate Kubernetes with Jenkins?
Use Kubernetes plugin to provision build agents on Kubernetes pods.
Configure Jenkins to connect to the K8s cluster (set Kubeconfig).
Deploy builds to Kubernetes using kubectl or Helm steps in the pipeline.

-------------------------------------------------------------------------------------------------------------

16. How to store credentials
Use Jenkins Credentials plugin.
Store secrets as "Username/Password", "Secret text", "SSH Key", etc.
Reference them in the Jenkinsfile using withCredentials block.

-------------------------------------------------------------------------------------------------------------

17. What approach would you take to test your code across multiple operating systems using Jenkins?
Use Jenkins agents/nodes with different OS (Windows, Linux, Mac).
Use matrix builds to run jobs on different platforms.
Or use containers with different OS images (Docker agent)


