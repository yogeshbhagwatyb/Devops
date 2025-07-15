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

# EBS volume
An EBS volume is a type of data storage where information is saved in fixed-size blocks. These blocks are usually 512 bytes (in very old hard drives made before 2010) or 4 KB (in modern systems like EBS, NTFS, and EXT4).
Each block has its own address, but it doesn’t include any extra information like file names or folder structures.

For example:
If you store a 1 MB file, it will be split into 256 blocks, each 4 KB in size.
If you store just 1 KB of data, it will still take up one full 4 KB block. The remaining 3 KB is wasted and can’t be used by anything else. This is called internal fragmentation.

# Types of EBS volumes

SSD stands for Solid State Drive, and HDD stands for Hard Disk Drive.
SSD is faster, uses less power, is smaller and lighter, but also more expensive than HDD.
HDD is slower and has moving parts, but it's cheaper and used for storing large amounts of data.

Types of EBS Volumes:
gp2 and gp3 – General purpose SSD (used for most applications)
io1 and io2 – High-performance SSD with provisioned IOPS (used for databases)
st1 – Throughput-optimized HDD (used for big data or logs)
sc1 – Cold HDD, low-cost (used for infrequently accessed data)
standard – Old magnetic HDD (rarely used now)

# IOPS
IOPS stands for Input/Output Operations Per Second.
It tells you how fast a storage volume (like EBS) can read or write small chunks of data.

One IOPS = read/write one block
One block = ~4000 characters (if 4 KB block)
So, in one IOPS, it could read/write a paragraph, not just a word

If You Have 1 IOPS, What Does It Mean?
You can do 1 read or write operation per second
If each word = 1 operation, then:

Example:
If you want to write 4 words, and you have 1 IOPS, then:
It can write 1 word per second
So, it will take 4 seconds to write 4 words ✅


Volume Type	                              Min Size	  Max Size
gp2 (General Purpose SSD)	               1 GiB	   16 TiB
gp3 (General Purpose SSD)	               1 GiB	   16 TiB
io1 / io2 (Provisioned IOPS SSD)	       4 GiB	   16 TiB
st1 (Throughput Optimized HDD)	           500 GiB	   16 TiB
sc1 (Cold HDD)	                           500 GiB	   16 TiB
standard (Magnetic) (deprecated)	       1 GiB	   1 TiB

--------------------------------------------------------------------------------------------------

# Object storage
In object storage, data is saved as objects, and each object includes the actual data, some extra information called metadata, and a unique ID.
Each file or piece of data is treated as a separate object.

--------------------------------------------------------------------------------------------------

# EFS
EFS is a shared folder in the cloud that Linux EC2 servers can mount and use together.

--------------------------------------------------------------------------------------------------

# What is Amazon S3?
Amazon S3 (Simple Storage Service) is an object storage service where we can upload, store, and retrieve any type of data like files, images, logs, or backups.
Each piece of data is stored as an object inside a bucket, and every object has a unique key and some metadata (extra info about the object).

Feature	                                Limit
Maximum object size	                    5 TB
Maximum number of objects	            Unlimited
Maximum buckets per account	            100 (shared globally)
Can we increase bucket limit?	        ❌ No
Total data storage limit	            ✅ Unlimited


# Storage classes

# S3 Standard
It is the default storage class in S3.
Best for data that needs to be accessed very regularly or very often, like files for websites, apps, or active databases.
It offers fast retrieval speed, up to 100 MB/sec or more if your network allows.
The storage cost is around $0.023 per GB per month.
When you save data in S3 Standard, it is automatically stored across more than 3 Availability Zones (AZs) for high durability.

# S3 Intelligent-Tiering
This is a smart storage class.
If you are not sure whether your data will be accessed frequently or rarely, S3 Intelligent-Tiering automatically moves your data between different tiers based on usage patterns to save costs.
How it moves your data:
After 30 days of no access → moves to Infrequent Access tier.
After 90 days of no access → moves to Archive Access tier.
After 180 days of no access → moves to Deep Archive Access tier.

# S3 Standard-IA (Infrequent Access)
This storage class is useful when your data is not accessed regularly, maybe only once a month or occasionally.
When you need the data, it offers fast retrieval speed, similar to Standard.
It is best suited for old project files, backups, and disaster recovery copies.
The storage cost is lower than S3 Standard, but you have to pay an extra fee whenever you access the data.

# S3 One Zone-IA
Same as Standard-IA, but data is stored in only one Availability Zone (one physical location).
Cheaper than Standard-IA.
Riskier — because if that single zone goes down, you may lose the data.
Best for recreatable or non-critical backups.

# S3 Glacier
Use this for archiving — storing data you hardly ever access.
Very cheap to store, but slow to retrieve (few minutes to hours).
Example: compliance documents, audit records, old logs.

# S3 Glacier Deep Archive
Cheapest of all storage classes.
Designed for long-term backup — for data you might never use again, but need to keep (like tax documents for 7+ years).
Retrieval time is very slow — can take hours.
Storage is very, very low cost.

# Cost and speed
Standard = everyday use
➔ Cost: around $0.023/GB/month
➔ Speed: Immediate, very fast (up to 100 MB/sec or more if network allows)

Intelligent-Tiering = smart auto-saving
➔ Cost: around $0.023/GB/month + small monitoring fee
➔ Speed: Immediate, very fast (unless archived, then some delay)

Standard-IA = rare use but still quick when needed
➔ Cost: around $0.0125/GB/month (plus retrieval fee)
➔ Speed: Immediate, very fast

One Zone-IA = rare use + cheaper but riskier
➔ Cost: around $0.01/GB/month (plus retrieval fee)
➔ Speed: Immediate, very fast

Glacier = very rare access, slow to get
➔ Cost: around $0.004/GB/month
➔ Speed:
Expedited retrieval: 1–5 minutes
Standard retrieval: 3–5 hours
Bulk retrieval: 5–12 hours

Glacier Deep Archive = almost never needed, very very cheap
➔ Cost: around $0.00099/GB/month
➔ Speed:
Standard retrieval: up to 12 hours
Bulk retrieval: up to 48 hours


# S3 versioning
S3 Versioning allows us to save multiple versions of an object. If an object is accidentally deleted or overwritten, we can easily recover it. In versioning, objects are not stored incrementally — each version is a full copy. For example, if the first version is 100 GB and we upload a new version of the same file, it will consume another 100 GB of storage.


# S3 Life cycle 
1. S3 Lifecycle allows us to create rules to manage the lifecycle of objects.
2. Move objects to cheaper storage classes (like Standard-IA, One Zone-IA, Glacier, or Glacier Deep Archive) when they are not accessed frequently.
3. Delete old objects after a certain number of days to save space and cost.
4. Manage noncurrent versions in versioned buckets by archiving or deleting them.
5. Clean up incomplete multipart uploads that were never finished.

# Cross region replication
Cross-Region Replication (CRR) is a feature in Amazon S3 that automatically copies your objects from one bucket in one AWS region to another bucket in a different AWS region.
The destination bucket can be in the same AWS account or in a different AWS account, as long as proper permissions are set.

After a CRR rule is created, every time you upload a new object to the source bucket, it is automatically copied to the destination bucket in another region.
However, if you upload an object directly to the destination bucket, it will not be replicated back to the source.
Replication works one-way only, from source to destination.
CRR is especially useful for:
    1. Disaster recovery (keeping backups in another region)
    2. If our users are located in different parts of the world, we can use CRR to copy our data to a region that is closer to them. This helps improve access speed and reduces latency.
    3. Some laws or company policies may require data to be stored in a specific country or region. With CRR, we can meet these compliance requirements by automatically replicating data to the required location.

You can also apply filters to replicate:
    All objects
    Or only specific objects (based on prefix or tags)


# What are S3 access control mechanisms?
1. Bucket Policies
JSON-based rules applied at the bucket level
Grant or deny access to users, roles, accounts, IPs, VPCs, etc.
Best for cross-account access or public access control

2. IAM Policies
Attached to users, groups, or roles
Grant permissions to access specific buckets or actions (e.g., s3:GetObject)
Best for internal users within the same AWS account

3. ACLs (Access Control Lists)
Object- and bucket-level permissions
Used to grant access to individual AWS accounts
Legacy method — not recommended anymore
Often disabled by default using S3 Object Ownership settings

4. S3 Block Public Access
Security feature that blocks public access regardless of bucket/IAM/ACL settings
Can be applied to a bucket or entire account
Highly recommended to keep buckets private

# What is S3 Transfer Acceleration?
It speeds up data upload and download using Amazon CloudFront edge locations. Useful for transferring data over long distances.

# S3 Object Lock – Overview
Amazon S3 Object Lock is a feature that allows you to protect your objects from being deleted or modified for a specific period or permanently.
It enables WORM (Write Once, Read Many) behavior, meaning once data is written, it cannot be changed or deleted until the lock expires.

Use Cases
1. Legal Compliance / Regulatory Requirements
Industries like finance, healthcare, or government often require data to be retained without changes for a specific period to meet compliance standards.
2. Backups and Ransomware Protection
Protect backup data from accidental or malicious deletion, especially during ransomware attacks.
Even if an attacker gains access, they cannot delete locked objects.
3. Immutable Logs / Audit Trails
Ensure that log files and audit data remain unchanged and traceable for investigations or auditing purposes.

Retention Types
1. Retention Period
Lock the object for a fixed number of days or until a specific date.
2. Legal Hold
Acts like a pause button — the object is protected indefinitely until the hold is manually removed, regardless of the retention period.

Lock Modes
1. Compliance Mode (Strictest)
Objects cannot be deleted or modified during the retention period.
Not even the root user or an admin can override it.
Best for legal compliance and audit-proof data protection.

2. Governance Mode (Flexible)
Objects are protected by default.
However, users with the special permission s3:BypassGovernanceRetention can override the lock and delete objects if needed.
Useful for internal policies with some administrative flexibility.

3. Legal Hold
Can be applied in either mode.
Prevents object deletion regardless of retention period.
Must be manually removed before deletion is possible.

# How Can You Secure an S3 Bucket?
1. Enable S3 Block Public Access (Highly Recommended)
This feature blocks all public access, even if a bucket policy or object ACL tries to allow it.
It prevents accidental exposure of sensitive data on the internet.
Always keep this enabled unless you are intentionally hosting a public website.

2. Use IAM Policies and Bucket Policies (Expanded Explanation)
In Amazon S3, access control means deciding who can access your bucket and what they can do (read, write, delete, etc.).
There are two main ways to control this:
21. IAM Policies – for people inside your AWS account
These are permissions you attach to:
    Users (e.g., user1)
    Roles (used by EC2 or Lambda)
    Groups (e.g., DevOps group)

IAM policies say things like:
    "User1 can read and upload files to bucket my-app-data."

IAM policies only work for users or services in your account.

22. Bucket Policies – for anyone who needs access to the bucket
These are JSON-based rules attached directly to the bucket.
They control who can access the bucket, even from another AWS account or a specific IP.
Example:
"Allow account 123456789012 to read files from this bucket."
Bucket policies are great for:
    Cross-account access
    Allowing CloudFront or a third-party app to use the bucket
    Public access (if needed, with care)


3. Enable Server-Side Encryption (SSE)
Encrypt your data at rest to protect it even if someone gains access to the storage.
SSE-S3 – AWS manages encryption keys for you.
SSE-KMS – AWS Key Management Service; lets you control and audit key usage.
Use SSE-KMS for sensitive or regulated data where key control is important.

4. Enable Logging and AWS CloudTrail
S3 access logs record every request made to the bucket (who accessed what and when).
AWS CloudTrail tracks all API activity related to your S3 bucket across the account.
This helps with auditing, monitoring, and detecting suspicious behavior.

5. Enable MFA Delete (Extra Protection for Versioned Buckets)
MFA Delete requires multi-factor authentication (MFA) for:
Permanently deleting an object version
Disabling versioning
This is a powerful way to prevent accidental or unauthorized deletions, especially in backup buckets.
❗ You can only enable MFA Delete using the root account and AWS CLI.

--------------------------------------------------------------------------------------------------

# What is Static Website Hosting in Amazon S3?
Static website hosting in Amazon S3 means you can use an S3 bucket like a web server to show web pages to users — just like a traditional website.
But there’s one important difference:
It only supports static content — not dynamic code like PHP, Python, or databases.
1. What is Static Content?
Static content means files that don’t change based on user input — they are fixed and the same for everyone.
Examples:
index.html (home page)
style.css (for design)
script.js (JavaScript behavior)
Images, PDFs, videos, etc.

2. What it Does Not Support:
No back-end processing
No user login systems (unless connected to a separate API)
No database queries
You can’t use PHP, Node.js, or Python code inside the bucket

3. Why Use S3 Static Website Hosting?
Super low cost (you only pay for storage + bandwidth)
Scales automatically — no server maintenance
Easy to deploy (just upload your files)
You can connect it to a custom domain via Route 53 or CloudFront
Useful for:
Personal websites
Documentation sites
Landing pages
Static frontends (React, Angular, Vue builds)

4. Behind the Scenes:
When you enable Static website hosting:
S3 assigns a public website URL
It serves your files over HTTP from that URL
You set which file is shown first (index.html)
You can also set an error page (like error.html for 404 errors)

#  Steps to Host a Static Website on S3:
1. Created an S3 bucket
Gave it a name (like my-static-site)
Unchecked "Block all public access"

2. Uploaded website files
Uploaded index.html, error.html, and other files

3. Enabled static website hosting
Went to Properties > Static website hosting
Selected “Host a static website”
Set:
Index document = index.html
Error document = error.html

4. Added a bucket policy to allow public access
Went to Permissions > Bucket policy
Added a public-read policy like:

    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::your-bucket-name/*"
        }
    ]
    }

5. Made the objects public
Selected the files (index.html, etc.)
Chose Actions > Make public

6. Accessed the website
Copied the “Bucket website endpoint” from the Properties tab
Opened it in the browser

--------------------------------------------------------------------------------------------------

# VPC
# Can two VPCs have overlapping CIDR blocks?
Technically yes (Check manually), but overlapping CIDRs prevent peering or communication between VPCs due to routing conflicts. It’s a best practice to use non-overlapping ranges.

# Vpc peering
VPC Peering is a way to establish a network connection between two VPCs. Once VPC peering is set up, resources in both VPCs can communicate with each other using private IP addresses.
This communication happens over the AWS internal network, not the internet, which makes it more secure and faster.
You can create VPC peering in the following scenarios:
Between VPCs in the same AWS account and same region
Between VPCs in the same account but in different regions
Between VPCs in different AWS accounts, whether in the same or different regions

1. Step 1: Go to VPC Dashboard
    Open the AWS Console
    Navigate to VPC → Peering Connections

2. Step 2: Create Peering Connection
    Click on Create Peering Connection
    Fill in the details:
    Name tag (optional)
    VPC Requester: Select your first VPC
    VPC Accepter: Select the second VPC (in same account or enter details for another account)
    Click Create Peering Connection

3. Step 3: Accept the Peering Connection
    After creation, go to the Peering Connections list
    Select the new peering connection → Click Actions → Accept Request (in the case of cross-account VPC peering, the acceptance step happens from the second AWS account (the "accepter").)

4. Step 4: Update Route Tables
    Go to Route Tables
    Edit the route table of both VPCs
    Add a new route in each:
    Destination: CIDR of the other VPC
    Target: The VPC Peering connection ID

    In VPC vish:
    Go to VPC Dashboard > Route Tables
    Find the route table associated with subnets in vish
    Click "Edit routes" > Add route
    Destination: 10.20.0.0/16 (CIDR of yog)
    Target: Select the Peering Connection ID (e.g., pcx-abc123)

    In VPC yog:
    Find the route table associated with subnets in yog
    Add route:
    Destination: 10.10.0.0/16 (CIDR of vish)
    Target: Select the same Peering Connection ID    

5. Step 5: Update Security Groups (if needed)
    Ensure security groups in both VPCs allow traffic from the other VPC’s CIDR block (e.g., for port 22, 80, etc.)

    On EC2 in VPC vish:
    Go to EC2 → Security Groups
    Select the SG attached to vish EC2
    Edit inbound rules:
    Type: Select the service (e.g., SSH for Linux, RDP for Windows, HTTP for web)
    Protocol: Auto-filled based on Type
    Source: 10.20.0.0/16 (CIDR of yog VPC)

    On EC2 in VPC yog:
    Edit its Security Group
    Allow inbound from 10.10.0.0/16 (CIDR of vish)


# Scenarios Where VPC Peering Fails or Does Not Work
1. Overlapping CIDR Blocks
    Cause: Both VPCs have same or overlapping IP ranges.
    Effect: Peering connection cannot be created.
    Fix: Use non-overlapping CIDRs, or add a secondary CIDR to one VPC.    

2. Missing Route Table Entries
    Cause: You forgot to add a route to the other VPC’s CIDR block.
    Effect: Peering connection is active, but traffic won’t flow.
    Fix: Add correct routes to both VPC route tables.

3. Security Group Rules Not Allowing Traffic
    Cause: Security groups are not allowing inbound traffic from the other VPC’s CIDR.
    Effect: Traffic is blocked even though peering and routing are correct.
    Fix: Allow inbound rules for required ports (e.g., TCP 22, 80) and source CIDR.

4. Using Public IPs Between Peered VPCs
    Cause: You try to use public IPs for communication.
    Effect: Communication fails; VPC peering only works over private IPs.
    Fix: Always use private IPs for communication between instances.

5. DNS Hostnames or Resolution Disabled
    Cause: If DNS settings are off, and you're using private DNS.
    Effect: Hostnames don’t resolve; private service endpoints may not work.
    Fix: Enable DNS hostnames and DNS resolution in both VPCs.

6. Peering Connection Not Accepted
    Cause: For cross-account or cross-region peering, the connection request must be accepted.
    Effect: Peering stays in "Pending Acceptance".
    Fix: Log in to the accepter account and accept the peering.

7. Trying to Use Transitive Peering
    Cause: You expect VPC-A → VPC-B → VPC-C to work transitively.
    Effect: Communication between A and C fails.
    Fix: Peering is not transitive. You must peer each VPC pair individually or use Transit Gateway.

8. Cross-Region Peering Without Required Config
    Cause: Regions are supported, but route table or firewall settings are incomplete.
    Effect: Peering connection exists but no connectivity.
    Fix: Ensure correct routing, security, and that services support cross-region access.    

--------------------------------------------------------------------------------------------------
 
# Nat Instance
A NAT instance is a special type of EC2 instance that allows private subnet instances to access the internet, for example, to download software updates. With a NAT instance, traffic can go from the private instance to the internet, but traffic from the internet is blocked from directly reaching the private instance. The NAT instance acts like a bridge between the private subnet and the internet. When a private instance wants to access the internet, the request goes through the NAT instance, and the response comes back the same way — from the internet to the NAT instance and then to the private instance. The NAT instance is created and placed in a public subnet.
Unlike a NAT Gateway, with a NAT instance, you have to manually manage scaling, updates, and high availability. For small setups, a NAT instance is cheaper, but for production or high-traffic environments, a NAT Gateway is more reliable and scalable.

--------------------------------------------------------------------------------------------------

# ALB
An Application Load Balancer (ALB) is a type of load balancer that works at Layer 7 of the OSI model, which is the application layer. This means it can understand the content of a request — such as the URL path, domain name, or headers — and route traffic accordingly. This makes ALB ideal for modern web applications where traffic needs to be handled based on what the customer is requesting.

For example, if your application has different parts like a login page, a shopping cart, and an image gallery, the ALB can direct /login requests to one group of servers and /images to another. Similarly, if you host multiple applications under different domains, such as user.example.com and admin.example.com, the ALB can route traffic to different backend services based on the host name.

ALB also supports health checks — it continuously monitors the health of backend targets. If one of the servers goes down or becomes unhealthy, the ALB automatically stops sending traffic to it.

It is mainly used to distribute incoming web traffic over HTTP and HTTPS to multiple backends such as EC2 instances, ECS containers, Lambda functions, or IP addresses. Additionally, you can enable SSL termination to securely handle HTTPS traffic and offload SSL processing from your application servers.


