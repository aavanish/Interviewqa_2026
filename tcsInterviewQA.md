## AWS

* What is the difference between an Application Load Balancer (ALB) and a Network Load Balancer (NLB)?
* Explain how Auto Scaling works in AWS.
  
* What are Security Groups and Network ACLs? How do they differ?

| Security Groups (Stateful) | NACL (Stateless) |
|---------------------|---------------------|
| A Security Group acts as a virtual firewall for your EC2 instances and other AWS resources like RDS, Lambda, and ELB. | A Network ACL (NACL) acts as a firewall for an entire subnet.|
| **Level**: Instance Level | **Level**: Subnet Level | 
| It is attached directly to a specific resource. | It controls traffic entering and leaving the subnet. |
| **Behavior**: Stateful | **Behavior**: Stateless|
| If a request is allowed to go out, the response traffic is automatically allowed back. | NACLs do not remember connections. |
| You do not need to create separate inbound or outbound rules for return traffic. | If inbound traffic is allowed, outbound response traffic must also be explicitly allowed |
| **Rules**: Allow Only | **Rules**: Allow and Deny |
| Security Groups support only allow rules. Any traffic not explicitly allowed is automatically denied. | Unlike Security Groups, NACLs can create both allow and deny rules. |
| **Usage**: Primary Defense | **Usage**: Secondary Defense |
| Used to tightly control access to individual instances and services. | Commonly used for broad traffic control, such as blocking suspicious IP addresses or creating secure subnet boundaries. |
| **Example**: If you allow outbound internet access from an EC2 instance to download updates, the returning traffic is automatically permitted without adding extra inbound rules. | **Example**: If you allow inbound HTTP traffic on port 80, you must also allow outbound response traffic, otherwise, the communication will fail. |

* How do you secure an S3 bucket?

| Security Area | Recommended Practice |
| --- | --- |
| **Access Control** | Disable ACLs, use IAM & bucket policies (giving access) |
| **Encryption** | SSE-S3 (managed keys) or SSE-KMS (customer-managed keys). |
| **Network Security** | Restrict via VPC endpoints, enforce HTTPS |
| **Monitoring** | CloudTrail, CloudWatch, Macie, AWS Config |
| **Data Protection** | Versioning, replication, lifecycle rules |

* What is the difference between NAT Gateway and Internet Gateway?

| Feature	| Internet Gateway |	NAT Gateway |
|---------------------|---------------------|---------------------|
| Traffic Direction |	Inbound + Outbound	| Outbound only |
| Subnet Placement |	Public subnet |	Public subnet (serves private subnets) |
| Use Case	| Public-facing apps |	Private instances needing internet access |
| Security	 | Can expose resources |	Keeps private resources hidden |
  
* How does Route 53 perform failover routing?
```
1. Health Checks   
    Route 53 uses health checks to monitor endpoints such as web servers, load balancers, or applications.
    If the health check fails (e.g., server down, timeout, or incorrect response), Route 53 marks the resource as unhealthy.

3. Primary and Secondary Records
You configure two DNS records:
  Primary record → Points to the main resource (e.g., EC2 instance, ALB, S3 static site).
  Secondary record → Points to a backup resource.

3. Active-Passive vs Active-Active
    Active-Passive Failover:
      Primary handles all traffic.
      Secondary only receives traffic when primary fails.
    Active-Active Failover:
      Both primary and secondary handle traffic simultaneously.
      If one fails, the other continues serving requests seamlessly

4. Supported Resources
   Failover routing can be applied to:
      Amazon S3 buckets (static websites)
      Elastic Load Balancers (ALB/NLB)
      EC2 instances
      CloudFront distributions
      Custom endpoints (via IP or domain name)
```
* Explain the EBS volume types and their use cases.

| Volume Type | Storage Medium | Performance | Cost | Typical Use Case |
| --- | --- | --- | --- | --- |
| **gp3** | SSD | Balanced, scalable IOPS | Moderate | Boot volumes, dev/test, general apps |
| **io1/io2** | SSD | High IOPS, low latency | High | Databases, critical workloads |
| **st1** | HDD | High throughput | Low | Big data, logs, streaming |
| **sc1** | HDD | Lowest throughput | Lowest | Backups, cold storage |

* What is the purpose of IAM Roles compared to IAM Users?

| Feature | IAM User | IAM Role |
| --- | --- | --- |
| **Identity Type** | Permanent | Temporary |
| **Credentials** | Long-term (password, access keys) | Short-term (STS tokens) |
| **Best For** | Human users, service accounts | AWS services, cross-account access, temporary permissions |
| **Security** | Higher risk if keys leaked | Safer — credentials expire automatically |

## CI/CD

* Explain the stages of a CI/CD pipeline.

Our infrastructure sits in a VPC with public and private subnets across multiple AZs. The EKS worker nodes live in private subnets for security, and the only internet-facing components are the Load Balancer and NAT Gateway, both in public subnets.

When a developer pushes code to GitHub, a webhook triggers our Jenkins CI job. It pulls the code, runs an OWASP dependency check, then a SonarQube quality gate — if either fails, the pipeline stops there so we're not wasting time building something already broken. Once that passes, Trivy scans the filesystem, then Jenkins builds the Docker image and pushes it to ECR, which also runs its own image-level scan as a second layer of defense.

That success triggers our CD pipeline, which updates the image tag in our GitOps repo — a separate repo that's the single source of truth for what should be running in the cluster. Argo CD is continuously watching that repo, and when it sees the change, it syncs the cluster to match — that's the GitOps model, so nobody runs kubectl apply manually.

When the new pods come up in the private subnet, they pull the image from ECR through the NAT Gateway — outbound only. Once running, user traffic comes in through the Load Balancer in the public subnet and is routed to the pods — inbound only, and nothing else can reach the nodes directly.

Once deployed, Prometheus and Grafana monitor the cluster, and we get email alerts on pipeline failures or deploy status, so the whole loop — code to production to visibility — is automated end to end
* How do you implement blue-green and canary deployments?
* How do you handle rollback if a deployment fails?
* How would you deploy the same application to multiple environments?

## Terraform

* What are Terraform state files, and why are they important?
* How do you manage remote state?
* Explain Terraform modules and workspaces.
* How do you detect and prevent configuration drift?

## Docker & Kubernetes

* What is the difference between a Deployment, StatefulSet, and DaemonSet?
* How do readiness and liveness probes work?
* How do you troubleshoot a pod stuck in CrashLoopBackOff?
* What are ConfigMaps and Secrets?
* Explain Ingress and its advantages.

## Monitoring & Logging

* How do you monitor AWS infrastructure?
* What metrics would you monitor for an EC2 instance?
* Explain CloudWatch Logs, Metrics, and Alarms.
* How do you centralize application logs?

## DevOps & Scenario-Based Questions

* A production deployment failed. What steps would you take to troubleshoot and recover?
* How would you reduce deployment downtime for a critical application?
* How do you ensure high availability and disaster recovery in AWS?
* How would you optimize AWS costs without impacting performance?
* Describe a challenging production incident you resolved and what you learned from it.


---------------------------------------------------------------------------

Difference in Application layer (Layer 7) and Network layer (Layer 4)?

The main difference between the Application Layer and the Transport Layer is that the Application Layer interacts directly with software applications and human users, while the Transport Layer manages the actual delivery, data flow, and connection stability between devices. [1, 2, 3, 4, 5] 
## Core Technical Specifications

* OSI Model Position:
* Application: Layer 7 (The highest layer, closest to the user)
   * Transport: Layer 4 (The middle layer, linking network hardware to software) [6, 7, 8, 9, 10] 
* Primary Responsibility:
* Application: Translates human interactions (like typing a URL) into data the network understands
   * Transport: Breaks large data into packets, ensures correct order, and handles error recovery [11, 12, 13, 14, 15] 
* Addressing Mechanism:
* Application: Uses URLs, domain names (DNS), and email addresses
   * Transport: Uses port numbers (e.g., Port 80 for HTTP, Port 443 for HTTPS) [16, 17, 18, 19, 20] 
* Data Unit Name:
* Application: Messages or raw data stream
   * Transport: Segments (for TCP) or Datagrams (for UDP) [21, 22, 23, 24, 25] 
* Device Awareness:
* Application: Only cares about the specific application logic and formatting
   * Transport: Cares about end-to-end connections, network congestion, and data flow speed [26, 27, 28, 29, 30] 

## Use Cases and Common Protocols

* Application Layer Protocols:
* HTTP/HTTPS: For loading web pages
   * SMTP/IMAP: For sending and receiving emails
   * FTP: For moving files between systems
   * DNS: For looking up website IP addresses [31, 32, 33, 34, 35] 
* Transport Layer Protocols:
* TCP: Guarantees data delivery (used for web browsing and file transfers)
   * UDP: Prioritizes speed over guaranteed delivery (used for live streaming and online gaming) [36, 37, 38, 39, 40] 

If you are building or troubleshooting a network setup, let me know:

* What specific application or service you are deploying
* Whether you are dealing with a connectivity issue or a design choice

I can help you map out exactly how data will flow through these layers for your project.
