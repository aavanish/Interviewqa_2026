## AWS

* What is the difference between an Application Load Balancer (ALB) and a Network Load Balancer (NLB)?
* Explain how Auto Scaling works in AWS.
* What are Security Groups and Network ACLs? How do they differ?
* How do you secure an S3 bucket?
* What is the difference between NAT Gateway and Internet Gateway?
* How does Route 53 perform failover routing?
* Explain the EBS volume types and their use cases.
* What is the purpose of IAM Roles compared to IAM Users?

## CI/CD

* Explain the stages of a CI/CD pipeline.
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
