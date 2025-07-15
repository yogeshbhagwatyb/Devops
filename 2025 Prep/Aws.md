 Q: What are your roles and responsibilities?
"In my current role, my key responsibilities include:

Designing and provisioning infrastructure on AWS and Azure using Terraform

Writing Python and Shell scripts to automate repetitive tasks and configuration

Managing CI/CD pipelines using Jenkins for automated testing and deployment

Containerizing applications using Docker and managing them in dev environments

Working with Kubernetes for container orchestration, including basic deployment, scaling, and monitoring of services

Supporting cloud migration tasks like moving workloads from on-prem or other cloud providers to AWS

Creating and managing IAM roles, VPCs, security groups, and storage (S3, EBS)

Monitoring infrastructure health using CloudWatch and setting up alerting mechanisms

Collaborating with development teams to support application releases

Managing secrets securely using AWS Secrets Manager and Azure Key Vault"

Working with Kubernetes for container orchestration, including basic deployment, scaling, and monitoring of services






I provision and manage services like EC2, VPC, EBS, Load Balancers, IAM, S3, RDS, EFS, and CloudFront to build scalable, secure, and fault-tolerant systems.

I also handle migration from on-premise to AWS using CloudEndure.

I develop reusable Terraform modules and automate infrastructure provisioning.

I manage remote state using S3 and handle dynamic tfvars, backend config, and environment-based deployments.

I design and maintain CI/CD pipelines using Jenkins to deploy containerized applications on EC2.

I integrate version control using Git/GitHub/Azure DevOps.

I manage Docker containers and use Docker Compose for multi-container applications.

I also work with Kubernetes for orchestration and deployment.

I automate tasks like provisioning, backups, log rotation, and health checks using Python and Shell scripts.

I use AWS CloudWatch, CloudTrail, and Config for monitoring and enforcing security compliance.

I also work with Azure services like VMs, Blob Storage, Azure DevOps pipelines, and Application Gateway with WAF.

---------------------------------------------------------------------------------------------------------------

1. Key types

1. RSA (Rivest–Shamir–Adleman)
Algorithm Age: Developed in 1977. One of the oldest encryption methods still in use.
Key Size: Common sizes are 2048 or 4096 bits. Larger size = more secure, but slower.
Security: Security depends on key length. RSA 2048 is secure for most purposes; 4096 is better but heavier.

2048 bits = 2048 binary digits (e.g., 010110... repeated 2048 times)
RSA key size can vary, but 2048 and 4096 are most used

Key Size	    Status / Recommendation
1024	    ❌ Not secure anymore – avoid it
2048	    ✅ Minimum recommended for good security
3072	    ✅ More secure, slightly slower
4096	    ✅ Very secure, but slower
8192	    ⚠️ Overkill in most cases, very slow

Compatibility:
Works with all SSH clients: OpenSSH, PuTTY, WinSCP, etc.
Supported by older systems and tools (good for backward compatibility).

Performance:
Slower in both key generation and connection setup.
Uses more CPU, especially with longer key sizes.

Use case:
When working with legacy systems
When compatibility with all clients is important

⚡ 2. ED25519
Algorithm Age: Introduced in 2011. Modern elliptic curve algorithm (based on Curve25519).
Key Size: Fixed size of 256 bits, but provides security equivalent to or better than RSA 3072–4096.

Security:
Resistant to modern attacks
More secure per-bit than RSA

Compatibility:
Only supported in OpenSSH 6.5+ (released 2014)
Not supported in older versions of PuTTY, or systems/tools that haven’t been updated

Performance:
Faster in both key generation and SSH connection setup
Smaller keys, lower CPU usage

Use case:
When you're working in a modern Linux/macOS environment
When you don't need compatibility with old tools

---------------------------------------------------------------------------------------------------------------
1. Route 53 concepts, how you configured AWS Route 53 for your project?

---------------------------------------------------------------------------------------------------------------

2. What is Load Balancer?
A Load Balancer is a device or service that distributes incoming network traffic across multiple servers to ensure no single server bears too 
much load. The primary purpose of a load balancer is to improve the availability and reliability of applications, websites, or services by 
distributing the workload among multiple servers, also known as a server farm or server pool. This helps prevent any single server from becoming 
a bottleneck, enhances fault tolerance, and optimizes resource utilization.
Key characteristics and features of a load balancer include:
Traffic Distribution: A load balancer evenly distributes incoming traffic across multiple servers. This distribution can be based on various 
algorithms, such as round-robin, least connections, or IP hash, depending on the specific load balancing strategy configured.
Scalability: Load balancers enable horizontal scalability by allowing additional servers to be added to the server pool. This helps handle 
increased traffic and scale the application or service as demand grows.
Fault Tolerance: If one server in the pool becomes unavailable or experiences a failure, the load balancer redirects traffic to healthy servers. 
This ensures continuity of service and minimizes the impact of server failures on users.
Session Persistence: Some applications require that a user's requests are consistently directed to the same server to maintain session 
information. Load balancers can support session persistence mechanisms to ensure continuity for users during their interactions with the 
application.
Health Monitoring: Load balancers regularly check the health of the servers in the pool by sending health checks or probes. Unhealthy servers are
automatically taken out of rotation, preventing them from receiving new requests until they recover.
SSL Termination: Load balancers can offload the task of handling Secure Sockets Layer (SSL) encryption and decryption, reducing the processing 
burden on individual servers and improving overall performance.
Global Server Load Balancing (GSLB): For distributed or geographically dispersed deployments, GSLB enables load balancing across multiple data 
centers or regions, helping to optimize user experience and ensure high availability.
Content-based Routing: Load balancers can route traffic based on the content of the requests, such as the URL path or specific headers. This 
allows for more advanced traffic routing and optimization.
Centralized Management: Load balancers often provide centralized management interfaces that allow administrators to configure settings, monitor 
performance, and make adjustments as needed.
Application Delivery Controller (ADC): In some cases, load balancers are referred to as Application Delivery Controllers, emphasizing their role
in optimizing the delivery and availability of applications.
Load balancing is a critical component in modern web and application architectures, helping to achieve high availability, scalability, and 
efficient resource utilization. Different cloud providers and network hardware vendors offer load balancing solutions tailored to various 
deployment scenarios.

# Updated 18-06-2025
Load Balancer (Definition):
A load balancer is a device or service that distributes incoming network traffic across multiple servers to ensure no single server becomes overwhelmed. It improves application availability, reliability, and performance by balancing the load efficiently.

Types
Application Load Balancer (ALB) – Definition:
An Application Load Balancer (ALB) is a type of load balancer that operates at Layer 7 (Application layer) of the OSI model. It makes routing decisions based on the content of the HTTP/HTTPS request, such as the URL path, hostname, headers, or query strings.

Network Load Balancer (NLB) – Definition:
A Network Load Balancer (NLB) is a type of AWS load balancer that operates at Layer 4 (Transport layer) of the OSI model. It routes traffic based on IP protocol data, such as TCP, UDP, and TLS, instead of application-level data.

For Application load balancer
1. Path-Based Routing
What it means: Route traffic based on the URL path in the browser.
Example:
User opens: example.com/app → goes to App servers
User opens: example.com/admin → goes to Admin servers
App servers and Admin servers refer to Target Groups in AWS ALB
example.com is a domain name — it’s what users type into the browser to visit a website
Used for: Microservices, APIs, separating frontend/backend.

2. Host-Based Routing
What it means: Route traffic based on the domain name.
Example:
app.example.com → goes to App target group
api.example.com → goes to API target group

main domain - example.com
subdomain - app.example.com and api.example.com we can create this route53
    Go to Route 53 > Hosted Zones > example.com
    Click "Create record"
    For subdomain app.example.com:
    Record name: app
    Record type: A (Alias to Application Load Balancer) or CNAME
    Value: The DNS name of your ALB or other target

Create two target groups:
app-target-group (e.g., for frontend EC2 instances or containers)
api-target-group (for backend services)

# Add Listener Rules
In your ALB, go to Listeners → View/Edit Rules
Click "Add Rule"
Add a rule like this:
Rule 1: For app.example.com
Condition: Host header is app.example.com
Action: Forward to app-target-group
Rule 2: For api.example.com
Condition: Host header is api.example.com
Action: Forward to api-target-group

# Request Flow for app.example.com
User enters app.example.com in the browser.
Browser sends a DNS request → This goes to Route 53 (or your DNS provider).
Route 53 resolves app.example.com to the DNS name of the Application Load Balancer (ALB).
Request goes to the ALB.
ALB receives the request and checks:
"What is the Host header?"
It sees app.example.com.
ALB finds the listener rule:
If Host = app.example.com → Forward to app-target-group
ALB forwards the request to a healthy instance in app-target-group.

Used for: Running multiple websites or apps on one load balancer

3. Query String Routing
What it means: Route traffic based on ?key=value in the URL.
Example:
example.com/page?env=dev → goes to Development servers
example.com/page?env=prod → goes to Production servers

Used for: Testing environments, A/B testing.

Example Setup
You have:
Domain name: example.com
(Your public website – registered in Route 53)

Two environments:
env=dev → for developers (testing)
env=prod → for live users

Target Groups:
Target Group Name	Purpose
dev-target-group	EC2 instances or containers for development
prod-target-group	EC2 instances or containers for production
These are registered in ALB → Target Groups.

User Request:
User enters this URL in their browser:
https://example.com/page?env=dev

What happens:
Browser sends request to example.com → goes to Route 53
Route 53 resolves the domain to your ALB
ALB receives the request, and:
Looks at the query string in the URL: ?env=dev
Matches it with the listener rule:

IF query string: env = dev → forward to dev-target-group
IF query string: env = prod → forward to prod-target-group
ALB sends traffic to the correct target group.

Real Use Case:
URL	Routed to
https://example.com/page?env=dev	dev-target-group
https://example.com/page?env=prod	prod-target-group

4. Header-Based Routing
What it means: Route traffic based on HTTP headers sent from the browser or app.
Example:
Header: X-Version: v1 → goes to v1 servers
Header: X-Version: v2 → goes to v2 servers

Website: https://example.com
ALB is created and attached to example.com
Two versions of your backend are running:
v1 → handled by v1-target-group
v2 → handled by v2-target-group

You want to route requests based on this custom HTTP header
X-Version: v1   → go to v1-target-group  
X-Version: v2   → go to v2-target-group

❗️Note: A normal browser visit won’t automatically send this.
It must be sent using tools like Postman, curl, or a custom app (mobile/web) that adds the header.

Using curl
If you want to test this from terminal:
curl -H "X-Version: v2" https://example.com

5. HTTP Method-Based Routing
What it means: Route based on the type of request: GET, POST, etc.
Example:
GET request → goes to Read server
POST request → goes to Write server
Used for: Optimizing read/write operations in APIs.

6. Source IP Routing
What it means: Route based on the user’s IP address.
Example:
Internal IP: 10.0.0.5 → goes to Private server
External IP: 103.23.45.12 → goes to Public server
Used for: Giving internal staff different experience than customers.

7. Weighted Routing (Target Groups)
What it means: Split traffic between two versions.
Example:
Send 80% of traffic to Target Group 1 (Stable version)
Send 20% of traffic to Target Group 2 (New version)
Used for: Gradual rollout, canary deployments, blue/green testing

8. Redirect / Fixed Response
Redirect: Tell the browser to go somewhere else
http://example.com → redirects to https://example.com
Fixed Response: Reply with a message
Shows a maintenance page or a 403 Forbidden error.
Used for: Redirection, blocking access, or showing maintenance notice.

9. Sticky Sessions (Session Affinity)
What it means: A user gets sent to the same server every time.
Example:
User A → always goes to Server 1
User B → always goes to Server 2
Used for: Apps that store session in memory (like shopping carts).

---------------------------------------------------------------------------------------------------------------

3. When will we go for ALB or NLB?

---------------------------------------------------------------------------------------------------------------

4. During Blue–Green Deployment, how does the API calls transactions spread across the load balancers, how does the transition happen across end points

This is asking two related things about Blue–Green deployment
a. How does the API call transactions spread across the load balancers?
This means:
When both Blue (old version) and Green (new version) environments are running, how are incoming API requests handled?
Specifically, how are they distributed across the old and new environments using the load balancer?

The answer involves understanding how load balancers like ALB (Application Load Balancer) handle traffic shifting, such as:
Routing all traffic to Blue initially.
Then gradually shifting traffic to Green using weight-based routing (e.g., 80% to Blue, 20% to Green).
Until 100% goes to Green.

b. How does the transition happen across end points?"
This means:
How does the system switch from Blue endpoints to Green endpoints?
How does the cutover (transition) happen in production, ensuring no downtime or errors?

You need to explain:
Use of load balancer listener rules to direct traffic.
Possibly using DNS changes or Route 53 routing.
Ensuring session persistence or stickiness if needed.
How old endpoints are disabled after the Green version is verified.

Explanation:
Environment	Status
Blue	✅ Already live, running old version
Green	🔄 Newly deployed with the new version for testing and gradual traffic shift

What is Blue–Green Deployment?
Blue–Green Deployment is a release technique where:
Blue is your current live version (production).
Green is your new version (new release).
You run both environments in parallel, then switch traffic gradually or instantly from blue to green

a. Transition Happens via Load Balancer (like ALB)
Case 1: ALB with Single Listener Rule and Weighted Target Groups
This is the most common and safe pattern.
You attach Green TG to the same listener rule as Blue.
Use traffic weights to gradually shift traffic:
Start: Blue 100%, Green 0%
Start: Blue 95%, Green 5%
Validation
Use monitoring tools, alerts, user feedback to ensure the new version (Green) is healthy.
If any issue occurs, rollback is instant by resetting weight to 100% Blue.
Then: Blue 80%, Green 20%
Eventually: Blue 0%, Green 100%


To do Blue–Green Transition:
Deploy the Green environment (new version) with a new ALB.
Go to Route 53 → Hosted Zone → ezdevops.shop
Create a new record for Green:
Field	        Value
Record name	    api.ezdevops.shop (same as Blue)
Type	        A or Alias
Alias Target	Green ALB DNS (select from dropdown)
Routing Policy	Weighted
Weight	        10
Set ID	        Green-ALB
TTL	            60 seconds

Green ALB DNS (select from dropdown)" refers to the new Application Load Balancer you created for the Green (new) environment.
Use CloudWatch, ALB logs, or app-level metrics to monitor how Green is performing
and gradually incraese the weight

---------------------------------------------------------------------------------------------------------------

5. How to debug Load balancing if there's a failure during transition?

a. Check Target Group Health
Check Green TG:
Are instances showing as healthy?
If not, check:
Port number
Health check path (/health, /, etc.)
Protocol (HTTP vs HTTPS)
Security group allowing health check port
Application actually responding with 200 OK
❗ Even if the ALB is fine, if health checks fail, traffic won’t be forwarded.

b. Verify Listener Rules (ALB)
Ensure:
The Green TG is added to the rule
The weights are correct (e.g., Green: 10%, Blue: 90%)
No conflicting rules or incorrect path-based conditions

c. Check Route 53 Settings (If using DNS switch)
Go to Route 53 → Hosted Zone.
Confirm:
Two records for the same domain (e.g., api.example.com)
Routing policy is “Weighted”
Both Blue and Green ALB DNS names are correct
TTL is low (e.g., 60 seconds)
❗ If DNS settings are incorrect or TTL is too high, clients may not resolve the new Green target.

d. Check ALB Access Logs (if enabled)
Enable access logs (S3 bucket required).
Look for:
5xx errors (503: Service Unavailable, 504: Gateway Timeout)
Long latency
Redirect loops

e. Check Application Logs (Green Environment)
Look inside the EC2 instances / containers behind Green TG:
Is the app crashing?
Are logs showing errors?
Are ports/services actually running?

f.  CloudWatch Metrics
View metrics for:
Target response time
HTTP error codes
Unhealthy host count
Traffic distribution
Compare metrics between Blue and Green to spot issues

g. Security Groups / NACLs
Ensure:
ALB SG allows inbound traffic (HTTP/HTTPS)
Target instance SG allows traffic from ALB
NACLs are not blocking traffic

---------------------------------------------------------------------------------------------------------------

6. In which scenario you used load balancers?
# ALB
We use ALB when we are dealing with web applications or APIs that run over HTTP or HTTPS. It works at Layer 7 of the OSI model — so it can understand URLs, hostnames, and even cookies.
1. Website with Multiple Pages or Services
If my website has different paths like /login, /profile, /admin, ALB can route each to different servers or containers. This is called path-based routing.
2. One Domain, Many Microservices
If I have one domain like ezdevops.shop, and I want to route api.ezdevops.shop to one service and info.ezdevops.shop to another — I can use host-based routing with ALB.
3. Running Containers (ECS or EKS)
ALB is best when using ECS or Kubernetes, because it supports dynamic port mapping and can automatically send traffic to the right container.
4. HTTPS Support and SSL Termination
If I want to make my app secure with HTTPS, I can attach an SSL certificate to ALB and let it handle the HTTPS traffic. Internally, it forwards traffic as plain HTTP."
5. Need User Authentication
If my app needs login through Google, Facebook, or Cognito, I can set that up directly on ALB without writing extra backend code.
6. Want Redirects or Fixed Responses
For example, redirecting all HTTP traffic to HTTPS, or sending a custom 403 message — I can do this easily in ALB rules.

I use ALB when I need advanced routing features for web applications — like path-based or host-based routing, HTTPS support, container integration with ECS or EKS, and authentication. It's best for Layer 7 traffic

# NLB
We use NLB when we need to handle high-performance, low-latency network traffic — especially for TCP, UDP, or non-HTTP traffic. It works at Layer 4 of the OSI model (Transport Layer), so it doesn't understand URLs or paths — it just forwards based on IP and port.

1. High Performance / Low Latency Apps
If I’m hosting real-time applications like gaming, video streaming, chat apps, or VoIP, I use NLB because it can handle millions of requests per second with very low latency.
2. TCP or UDP Traffic
If my application runs on TCP or UDP protocols instead of HTTP/HTTPS — like SMTP, FTP, database traffic (MySQL, PostgreSQL, etc.) — NLB is the right choice.
3. Static IP Requirement
If I need a fixed IP address for my service (like for whitelisting in firewalls), NLB supports Elastic IPs.
4. TLS Passthrough
If I want the SSL encryption to go end-to-end (from client to backend) without decrypting at load balancer, NLB supports TLS passthrough, unlike ALB.
5. Health Check at TCP Level
NLB checks if the target is alive at the TCP level — it doesn't care about HTTP responses. This is useful for low-level traffic.

I use NLB when I need to handle TCP/UDP traffic with very high performance and low latency, or when I want to use static IPs, TLS passthrough, or load balance non-HTTP services like databases or game servers. It's best for Layer 4 traffic.

---------------------------------------------------------------------------------------------------------------

7. How to do active scaling?

1. Create a Launch Template or Launch Configuration
Define:
AMI (Amazon Machine Image)
Instance type (e.g., t3.medium)
Key pair
Security group
User data (optional startup script)

2. Create an Auto Scaling Group (ASG)
Attach the launch template/configuration.
Define:
VPC and subnets
Load balancer (optional, for distributing traffic)
Min, Max, and Desired instance count
Example:
Min: 2
Max: 6
Desired: 2 (starts with 2 instances)

3. Set Up Scaling Policies
Choose between:
Target Tracking Scaling (Recommended)
Example: Maintain average CPU usage at 60%
ASG automatically adjusts instance count to stay near the target.
Step Scaling
Define steps:
If CPU > 70% → Add 1 instance
If CPU > 90% → Add 2 instances
If CPU < 40% → Remove 1 instance
Simple Scaling
Triggered by a single CloudWatch alarm
Example: If CPU > 80% for 5 minutes → Add instance

4. Create CloudWatch Alarms (if not using Target Tracking)
Metric: EC2 → CPUUtilization, RequestCount, etc.
Threshold: e.g., CPU > 70% for 5 mins
Action: Trigger scaling policy (Add/Remove instance)

5. Attach to a Load Balancer (Optional but Recommended)
Use ALB or NLB to distribute traffic to active EC2 instances.
ASG auto-registers instances with the load balancer.

# Instance warmup
When Auto Scaling launches a new EC2 instance, it doesn’t count that instance in scaling decisions immediately.
Instead, it waits for the "warm-up period" to complete — in your case, 300 seconds (5 minutes)

# Health Check Grace Period
For a newly added instance, Auto Scaling gives it some time to initialize (called the Health Check Grace Period).
After this time is over, it will start checking the health of the instance.

---------------------------------------------------------------------------------------------------------------

8. Auto scaling of load balancers?
Load balancers don’t scale manually.
ALB/NLB automatically scale based on incoming traffic.
But the Auto Scaling Group of targets (like EC2) can be scaled.

---------------------------------------------------------------------------------------------------------------

9. What is VPC?
Virtual Private Cloud (VPC) is a logically isolated network in AWS. You can launch AWS resources inside it with your custom IP range, subnets, route tables, and gateways

---------------------------------------------------------------------------------------------------------------

10. Public vs Private Subnet?
Public Subnet: Has route to Internet Gateway; used for web servers.
Private Subnet: No direct internet access; used for DBs, internal services

---------------------------------------------------------------------------------------------------------------

11. How to block an IP trying to communicate with your VPC?

1. Use Network ACLs (NACLs) — Best for IP Blocking
NACLs (Network Access Control Lists) operate at the subnet level and support allow/deny rules, making them perfect for blocking specific IPs.
Steps:
Go to VPC Dashboard → Network ACLs.
Select the NACL associated with your subnet.
In Inbound Rules, click Edit inbound rules.
Add a DENY rule:
Rule #: e.g., 100
Type: All traffic or specific (like HTTP)
Protocol: All or specific
Source: The IP address or CIDR to block (e.g., 203.0.113.25/32)
Action: Deny
NACL rules are evaluated in order, from lowest to highest number.

2. Use Security Groups — Limited Blocking
Security Groups are stateful and allow only "allow" rules, not deny rules.
So you can’t block an IP directly, but you can restrict access to only trusted IPs.
Example:
Instead of blocking 203.0.113.25, allow only your trusted IPs like 203.0.113.10/32

3. Use AWS WAF (for ALB, CloudFront, or API Gateway)
If the IP is targeting your ALB, CloudFront, or API Gateway, use AWS WAF to block it.

Steps:
Go to AWS WAF.
Create a Web ACL and associate it with your ALB.
Add a rule to:
Match source IP
Action: Block

4. Use Firewall Manager (for org-wide control)
For enterprises managing many accounts, use AWS Firewall Manager to apply IP blocking policies across multiple VPCs or ALBs.

---------------------------------------------------------------------------------------------------------------

12. About AWS RDS and DynamoDB – uses?

1. Structured Data
Definition: Data formatted in rows and columns, stored in relational databases where each field has a defined type (e.g. integer, date, string).

Examples:
Customer table: ID | Name | Email | SignupDate
Sales records: OrderID | ProductID | Quantity | Price | OrderDate
Sensor readings: SensorID | Timestamp | Temperature | Humidity

What is RDS?
RDS (Relational Database Service) is a service by AWS that helps you store and manage data in a structured way using databases like:
MySQL
PostgreSQL
Oracle
SQL Server
Amazon Aurora
AWS manages everything for you: setup, backups, updates, and scaling.

AWS manages everything for you: setup, backups, updates, and scaling” –
This is what makes Amazon RDS a “managed service”. That means you don’t have to do manual work — AWS does it for you.

1. Setup
When you create a database using RDS:
You don’t install software (like MySQL, PostgreSQL) manually.
You just choose options in the AWS Console (e.g., DB type, storage, region).
AWS launches the database in a few clicks.

Example:
Instead of downloading MySQL and installing it on your server, AWS gives you a ready-to-use database in minutes.

2. Backups
AWS automatically takes daily backups of your RDS database.
This helps you:
Restore your data if something goes wrong.
Go back to a previous day’s data (called Point-in-Time Recovery).

Example:
If your app accidentally deletes data, you can restore the DB as it was yesterday.


2. Unstructured Data
Definition: Data with no predefined format or organization. It’s often text-heavy and requires additional processing to extract meaning.

Examples:
Emails: full text messages, including subject, body, attachments
Social media posts: status updates, tweets, comments
Documents: PDFs, Word files, scanned images
Media files: Photos, videos, audio recordings




About AWS RDS Service
AWS RDS (Relational Database Service) is a managed service for relational databases like MySQL, PostgreSQL, MariaDB, Oracle, and SQL Server.
Key Features: Automated backups, patching, monitoring, scaling, high availability (Multi-AZ), and managed maintenance.
Use Cases:
Web and mobile applications
E-commerce platforms
Any application that needs a reliable, managed SQL database

About DynamoDB
AWS DynamoDB is a fully managed NoSQL database service that provides fast and predictable performance with seamless scalability.
Key Features: Serverless, highly available, automatic scaling, supports key-value and document data structures.
Use Cases:
Real-time applications (gaming, IoT, messaging)
Applications requiring massive scalability (millions of requests per second)
Shopping carts, user profiles, session management

---------------------------------------------------------------------------------------------------------------

13. Difference between SaaS, PaaS, and DaaS?

Cloud Computing Stack Layers

Layer	                        What It Is
1. Networking	        Manages internet connectivity, firewalls, IP addresses, and load balancers.
2. Storage	            Disk storage, block/object storage, backups, and file systems.
3. Servers	            Physical servers that run your applications and virtual machines.
4. Virtualization	    Hypervisors (like VMware, KVM) that create virtual machines on physical servers.
5. Operating System	    OS like Linux or Windows installed on the virtual machine.
6. Middleware	        Software between the OS and app — like web servers, messaging queues, etc.
7. Runtime	            The environment to execute code — like Python, Java, Node.js.
8. Data	                Application data, user input, database records, files — handled by your app.
9. Application	        The actual software/app that users interact with (e.g., Gmail, your Flask app).

You start from Networking (the base) and build upward toward the Application.
Each upper layer depends on the layer below it.
The Application is the final layer users directly interact with.

# Models
1. IaaS (Infrastructure as a Service)
IaaS stands for Infrastructure as a Service.
The provider manages networking, storage, servers, and virtualization.
We are responsible for managing the operating system, middleware, runtime, data, and application.
Example:
AWS EC2 (Elastic Compute Cloud)
You launch a virtual machine (VM), install Linux, set up Python, configure NGINX, and deploy your Flask app.
You manage everything from OS to your application.
Other examples:
Microsoft Azure Virtual Machines
Google Compute Engine (GCE)
DigitalOcean Droplets

2. PaaS (Platform as a Service)
PaaS stands for Platform as a Service.
The provider manages networking, storage, servers, virtualization, operating system, middleware, and runtime.
We only manage the data and application.
AWS Elastic Beanstalk
Azure App Service

3. SaaS (Software as a Service)
SaaS stands for Software as a Service.
The provider manages everything — from infrastructure to application.
We simply use the software without managing any layers.
Example:
Gmail
You simply log in and use the email service. You don’t manage any infrastructure, storage, or backend.
Other examples:
Google Docs
Zoom
Salesforce
Microsoft 365

4. DaaS (Data as a Service)
DaaS stands for Data as a Service.
The provider manages infrastructure, application, and data delivery.
We only consume the data, usually via APIs, without managing backend systems.
Example:
OpenWeatherMap API
You call an API like https://api.openweathermap.org/data/2.5/weather?q=Pune and get weather data.
You don’t manage the database or backend — you just consume the data.
Other examples:
CoinMarketCap API (for crypto data)
Google Maps API (for location and geocoding)
COVID-19 API (for latest pandemic stats)

---------------------------------------------------------------------------------------------------------------

14. Flask app - how to implement SaaS, PaaS, DaaS?

I have a Python Flask application. How will I implement SaaS, DaaS, and PaaS models?
This means the person has built a Flask web app and wants to know how they can use or design it to fit into the three different cloud models:
SaaS (Software as a Service)
DaaS (Data as a Service)
PaaS (Platform as a Service)

# SaaS (Software as a Service)
What it means: Turn your Flask app into a hosted web application that users can sign up for and use online.

How to implement:
Host your app on the cloud (e.g., AWS EC2, Heroku, or Elastic Beanstalk).
Add features like user registration, login, and dashboard.
Use multi-tenancy (separate data per user or customer).
Add billing if needed using Stripe or Razorpay.
Example: A task management app where companies can sign up and manage their teams.

1. Host Flask app on EC2
Launch an EC2 instance (e.g., Ubuntu).
Install Python, Flask, Gunicorn, NGINX.
Deploy your Flask app.
Open port 80 (HTTP) in the security group.
Now if you visit EC2 Public IP in your browser — your Flask web page will load.

2. User Registration & Login
Add features like:
/register → for new users
/login → to sign in
/dashboard → user’s private page
Use Flask extensions like:
Flask-Login (for session management)
Flask-WTF (for forms)
Flask-SQLAlchemy (for database ORM)

3. Store user data in a database
Use a DB like PostgreSQL, MySQL, or SQLite.
You can:
Host the DB on the same EC2 instance.
Or use Amazon RDS (managed database).
Store user info, passwords (hashed), dashboard data, etc.

User visits http://<your-ec2-public-ip>
They see your Flask app.
They can register → login → use dashboard.
Their data is saved in your database.
That’s a working SaaS application built on a Flask app and hosted on IaaS (EC2)!

# PaaS (Platform as a Service)
What it means: Use a cloud platform to deploy and run your Flask app without managing servers manually.
How to implement:
Deploy your Flask app to Heroku, AWS Elastic Beanstalk, or Google App Engine.
The PaaS will handle:
Server provisioning
Runtime (Python version)
Load balancing and scaling
You only need to manage your code and app logic.
Example: Just run git push heroku main and your Flask app is live.

# Note Saas vs Paas
PaaS (Beanstalk, Heroku)
You are still a developer, but now you're using a platform (PaaS) that manages the infrastructure for you.
You just push code, and the platform handles EC2, Python, NGINX, etc.
Example: eb deploy or git push heroku main
Less work than IaaS, more automation = PaaS.

SaaS (Your Flask app, for your end users)
Now, flip the role.
You are the service provider.
You have built a Flask web application and hosted it using EC2 (IaaS) or Beanstalk (PaaS).
Your end users visit your site → register → login → use the software.
For them, your app is SaaS.
So your app (hosted on EC2 or Beanstalk) becomes a SaaS for your customers.

# DaaS (Data as a Service)
What it means: Use Flask to serve data via REST APIs to other apps or clients.
How to implement:
Create Flask routes like /api/users, /api/products, etc.
Return JSON data (use flask.jsonify()).
Protect endpoints with API keys or tokens (JWT or OAuth).
Host the app using a cloud provider.
Example: A COVID-19 stats API or weather info API that returns data when requested.



---------------------------------------------------------------------------------------------------------------
15. Measures to Secure EC2 Instances?
1. Use Key Pairs Securely
Use SSH key pairs for Linux instances instead of passwords.
Use EC2 Instance Connect or Session Manager to avoid managing keys manually.
Never share or expose your private key (.pem file)

2. Configure Security Groups (SG) Carefully
Only open required ports (e.g., 22 for SSH, 80/443 for HTTP/HTTPS).
Restrict access using specific IPs or CIDR ranges, not 0.0.0.0/0.
For example:
SSH access only from office IP
HTTPS for everyone

3. Use Network ACLs
Add another layer of filtering at the subnet level.
Block specific IPs or allow only trusted ranges.

4. Assign Least Privilege IAM Roles
Attach IAM roles to EC2 with only required permissions.
Avoid using overly permissive policies like AdministratorAccess.

5. Keep EC2 OS Updated
Regularly patch the OS and installed software.
Use automation tools (like SSM Patch Manager) to apply security updates.

6. Enable Monitoring and Logging
Enable CloudTrail to log API actions.
Enable VPC Flow Logs to capture network traffic.
Install CloudWatch Agent for system metrics and logs.

7. Use AWS Systems Manager (SSM)
Disable direct SSH access and use SSM Session Manager.
This improves security and removes the need to manage key pairs.

8. Encrypt Data
EBS Volumes: Enable encryption for root and data volumes.
Data in Transit: Use HTTPS or SSH for secure communication.

9. Set Up Alarms and Alerts
Use CloudWatch alarms to notify on CPU spikes, unauthorized login attempts, etc.
Integrate with SNS or email notifications.

10. Backups and Recovery
Use Amazon Machine Images (AMI) and EBS snapshots for backup.
Enable recovery options in case of failure.

---------------------------------------------------------------------------------------------------------------

16. How to grant user access to EC2?
Attach user to IAM group with EC2 access policy.
Or use SSM Session Manager to give access without key pairs.
For SSH, upload their public key to ~/.ssh/authorized_keys.

# SSH access
1. Create an IAM User:
        Go to IAM in the AWS Console.
        Click Users → Add users.
        Set username and select “Programmatic access” or “AWS Management Console access”.

2. Attach Permissions:
        Attach an existing policy like AmazonEC2FullAccess or a custom policy with specific EC2 actions (e.g., Start, Stop, Describe).

3. (Optional) Add to IAM Group:
        You can add the user to an IAM group that already has EC2 permissions.

4. Provide SSH Access (for login to EC2 instances):
        If you want the user to log in to EC2 Linux instances:
        Share the instance's public IP and ensure their public SSH key is added to the instance’s ~/.ssh/authorized_keys.

4. Ask the User for Their Public SSH Key
Ask the user to generate their SSH key pair and send you their public key (id_rsa.pub or similar, never the private key).

5. Add the Public Key to the EC2 Instance
Option A: Add to the default user (e.g., ec2-user or ubuntu)
Add the new user’s public key to ~/.ssh/authorized_keys on the instance if you want to grant them SSH access.

Option B: Craete new user and add directory for them
Create a home directory (if not created by default).
Create a .ssh directory under their home.
Add their public key to /home/newuser/.ssh/authorized_keys with the right permissions.


Option B: Create a New Linux User Account:
SSH into the EC2 instance.
Create a new user:
sudo adduser newuser

Set up the .ssh directory:
sudo mkdir /home/newuser/.ssh
sudo chmod 700 /home/newuser/.ssh

echo "user_public_key" | sudo tee /home/newuser/.ssh/authorized_keys
sudo chmod 600 /home/newuser/.ssh/authorized_keys
sudo chown -R newuser:newuser /home/newuser/.ssh

If user dont have Public and private key then 
Generate a key pair on your machine add public key and give private to user

# Granting EC2 Access with SSM Session Manager (as Admin)
Step 1: Check/Attach SSM Agent and Role on EC2
Make sure the EC2 instance has the SSM agent installed (Amazon Linux 2/Ubuntu AMIs usually do).
Attach the IAM role with the policy AmazonSSMManagedInstanceCore to the EC2 instance.

Step 2: Grant the User SSM Permissions
In the AWS Console, go to IAM → Users.
Select the user you want to give access to.
Attach the policy AmazonSSMFullAccess (or a more restricted custom policy with ssm:StartSession and ec2:DescribeInstances).

Step 3: The User Connects Using SSM
The user logs into the AWS Console, goes to Systems Manager → Session Manager.
They select the EC2 instance and click Start session.
Or, the user can use the AWS CLI: aws ssm start-session --target <instance-id>

---------------------------------------------------------------------------------------------------------------

17. What is NACL (Network Access Control List)?
A Network ACL (NACL) is a stateless firewall used in AWS to control inbound and outbound traffic at the subnet level.

Key Points:
Stateless
This means: if you allow traffic in, you must also explicitly allow it out.
Every inbound and outbound rule is evaluated separately.

Applies to Subnets
NACLs are attached to subnets, so they affect all resources (EC2, RDS, etc.) inside that subnet.

Allow or Deny Rules
NACLs support both:
Allow rules
Deny rules
This makes them useful for blocking specific IPs or ranges, which Security Groups cannot do (SGs allow only "allow" rules).

Rule Evaluation Order
Rules are evaluated in ascending order based on rule number.
Once a match is found, further rules are not evaluated.

---------------------------------------------------------------------------------------------------------------

18. I want to set up infrastructure with high availability, security, and reliability. What key factors and best practices should be considered in the design and implementation?

To set up infrastructure with high availability, security, and reliability, consider these key factors and best practices:

1. High Availability
Multi-AZ/Region Deployment: Distribute resources across multiple availability zones or regions to avoid single points of failure.
Load Balancing: Use load balancers to distribute traffic evenly and automatically fail over in case of server outages.
Auto Scaling: Enable automatic scaling of resources based on demand to handle traffic spikes and hardware failures.

2. Security
Network Segmentation: Use VPCs, subnets, and security groups to isolate and protect workloads.
Identity and Access Management (IAM): Implement least-privilege access, strong authentication, and role-based permissions.
Encryption: Encrypt data at rest and in transit using strong encryption standards.
Patch Management: Regularly update and patch all systems to address vulnerabilities.
Monitoring and Logging: Enable logging, monitor security events, and set up alerts for suspicious activity.

3. Reliability
Backups and Disaster Recovery: Regularly back up data and test restore processes. Implement disaster recovery plans.
Health Checks: Use automated health checks for services and applications.
Redundancy: Duplicate critical components (e.g., databases, servers) to ensure service continuity if one fails.
Automated Failover: Configure systems for automatic failover to healthy resources during outages.

4. Best Practices
Infrastructure as Code (IaC): Use tools like Terraform or CloudFormation for repeatable, version-controlled deployments.
Continuous Monitoring: Monitor resource usage, application health, and security metrics.
Testing: Regularly test failover, backup, and recovery procedures.
Documentation: Document all architecture decisions, procedures, and configurations.

---------------------------------------------------------------------------------------------------------------

19. Which monitoring tools have you worked with, and what has been your experience using them for infrastructure or application monitoring?

I have installed and configured the CloudWatch agent on my VM.

For infrastructure monitoring, I use CloudWatch to monitor the health of the VM, including:

CPU usage (to see if the server is busy or idle)
Alarm: Trigger if CPU usage > 80% for 5 minutes

Memory usage (to check if the server is running out of RAM)
Alarm: Trigger if available memory < 500 MB for 5 minutes

Disk space (to make sure storage is not getting full)
Alarm: Trigger if disk space usage > 80%

Network traffic (to monitor how much data the server is sending or receiving)
Alarm: Trigger if network in/out suddenly drops to 0, indicating possible network issues

For application monitoring, I monitor the NGINX web server by:

Sending NGINX access and error logs to CloudWatch Logs

Checking if users are getting errors from NGINX
Alarm: Trigger if more than 10 errors (e.g., 5xx responses) occur in 5 minutes

Tracking how many requests are coming to NGINX

Monitoring the response time (latency) of NGINX
Alarm: Trigger if average response time > 2 seconds for 5 minutes

Watching for frequent “404 not found” or “500 error” messages in the logs
Alarm: Trigger if more than 20 “404” errors or more than 5 “500” errors in 5 minutes

With this setup, I can effectively monitor both the server’s health and the application performance. CloudWatch alarms help me take quick action if any critical resource or application metric crosses safe limits, which is important for production environments.


# What Happens When a CloudWatch Alarm is Triggered?
Alarm State Changes
The alarm state changes from OK to ALARM.

Notification is Sent
CloudWatch sends a notification to the action you set.
Usually, this is an Amazon SNS topic (Simple Notification Service).
    SNS can send you:
    An email alert
    An SMS (text) message
    A notification to a chat app like Slack or Teams
    Or trigger another AWS service (like Lambda for auto-remediation).

Optional: Automated Actions
You can configure actions such as:
    Restart the EC2 instance
    Scale up/down resources (like adding more servers)
    Run a Lambda function (for custom automated responses)

You (or your team) take action
After you get the notification, you can check what’s wrong and fix the problem.

Example:
If CPU usage is over 80% for 5 minutes, you get an email alert.
You check the server, find the issue (maybe a runaway process), and resolve it.
Once the metric goes back to normal, the alarm state returns to OK.

---------------------------------------------------------------------------------------------------------------

20. If users report slowness while accessing an application or website, how would you go about investigating and resolving the issue?

Check CloudWatch Alarms and Notifications:
First, I check if any CloudWatch alarms have been triggered (for example, high CPU, low memory, or application errors).
I review any notifications received (email, SMS, etc.) to get an initial clue about the possible cause.

Review Infrastructure Metrics:
I look at CloudWatch metrics for the EC2 instance to check for high CPU, memory usage, disk space issues, or abnormal network activity.
If any resource is under pressure (like CPU > 80%), I investigate which processes are consuming resources.

Analyze Application Logs:
I review NGINX access and error logs in CloudWatch Logs.
I look for a spike in error responses (like 5xx or 404 errors), high response times, or unusual patterns during the period when slowness was reported.

Check NGINX Response Time and Request Rate:
I check if there’s an increase in response time (latency) or if there’s a sudden spike in the number of incoming requests.
If latency is consistently high (e.g., >2 seconds), I look for backend or database bottlenecks.

Investigate Recent Changes:
I check if there were any recent deployments, configuration changes, or traffic spikes around the time the slowness started.

Take Remedial Actions:
If the issue is due to high resource usage, I may increase the instance size, add more servers (scale out), or optimize resource-heavy processes.
If the application is causing errors, I work with the development team to fix bugs or optimize code.
If disk is full, I clear unnecessary files or increase disk size.

Communicate and Monitor:
I inform stakeholders about the findings and actions taken. 
I continue to monitor CloudWatch metrics and alarms to ensure the issue is resolved and doesn’t reoccur.

# Common Reasons for Application/Website Slowness
a. High Server Resource Usage
CPU is very high (server is overloaded)
Memory is almost full (RAM exhausted)
Disk is almost full or disk I/O is slow

b. High Number of Requests (Traffic Spike)
Too many users are trying to access the site at the same time, overloading the server

c. Network Issues
Slow network connection
Network in/out drops or packet loss

d. Application-Level Issues
Bugs or inefficiencies in the application code
Long-running queries or backend bottlenecks (like slow database)

e. NGINX Configuration Issues
Improper worker/process settings
Low limits on connections or timeouts

f. Too Many Errors
Frequent “500 Internal Server Error” responses
Repeated timeouts or application crashes

g. External Dependencies
Waiting for responses from APIs, databases, or other services

h. Resource Contention (Shared Infrastructure)
If running on a shared or burstable instance, other workloads might slow down your server


-------------------------------------------------------------------------------------------------

# RDS
Deployment Options Explained
1. Multi-AZ DB Cluster Deployment (3 instances)
High Availability & Read Scalability

Creates:
1 Primary instance (read/write)
2 Readable standby replicas in different AZs

Benefits:
99.95% uptime
Redundancy across Availability Zones (AZs)
Faster failover & increased read capacity
Best for: Mission-critical, high-availability production workloads
Cost: Highest (3 instances)

Traffic flow
In Multi-AZ DB Cluster (3 Instances) setup:
a. Primary Instance → Handles all writes (Insert, Update, Delete)
b. Primary Instance → Also handles read traffic
c. 2 Readable Standby Instances → Can handle read traffic only

How Traffic Flows:
a. Application sends writes (data changes) → Only Primary handles this
b. Application sends reads (fetch data) → You can distribute reads to Standby instances too
Benefit: Reduces load on Primary, improves read performance, especially in high-traffic apps

If Primary Instance fails:
a. One of the Readable Standby Instances automatically becomes the new Primary
b. AWS RDS manages this failover process
c. It happens quickly, minimizing downtime

After failover:
a. The new Primary handles all writes and reads
b. AWS replaces the failed instance to maintain 3-instance setup. AWS RDS will automatically create a new instance to replace the failed one


2. Multi-AZ DB Instance Deployment (2 instances) [Selected in your screen]
High Availability Only

Creates:
1 Primary instance (read/write)
1 Standby instance in different AZ (automatic failover) but can't serve reads

Benefits:
99.95% uptime
Redundancy across AZs
Automatic failover in case of primary failure
Standby is not readable
Best for: Production databases where high availability is required
Cost: Medium (2 instances)

3. Single-AZ DB Instance Deployment (1 instance)
Basic Setup

Creates:
1 Primary instance (read/write)

Benefits:
Lower cost
Simpler setup
Drawbacks:
No standby
99.5% uptime, no redundancy
Best for: Development, testing, non-critical workloads

-------------------------------------------------------------------------------------------------

What is a Read Replica?
A Read Replica is a copy of your primary database that is used to handle read-only queries, like:
SELECT statements
Reports
Dashboards
Analytics
It helps to reduce the load on your main database, improves performance, and provides an option for disaster recovery.


Feature	                        Details
Purpose	                To offload read traffic from primary DB
Read-Only?	        Yes, cannot run INSERT, UPDATE, DELETE
Replication Type	Asynchronous (slight delay possible)
Promotion	        You can promote replica to become a new master if needed
Cross-Region?	        Yes, you can create replicas in other regions
Multiple Replicas?	Yes, supported for engines like MySQL, PostgreSQL, Aurora


Where Read Replica is Used?

Example 1: Heavy Read Traffic
Your application has:
1 Primary RDS (e.g., MySQL)
Many user dashboards running reports
You create Read Replicas, send read queries to replicas, keep write queries on primary. Improves performance.

Example 2: Disaster Recovery
You create a Read Replica in another AWS region
If the main region fails, you can promote the replica
Replica becomes a new standalone database

-------------------------------------------------------------------------------------------------


