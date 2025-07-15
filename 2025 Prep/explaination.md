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


