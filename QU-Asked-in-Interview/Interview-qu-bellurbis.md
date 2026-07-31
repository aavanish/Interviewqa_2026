I appeared on an interview for the role of devops engineer and the role demands proficiency in Networking and securities. 
Interview Questions - Bellurbis

  1. Brief me tools and technologies you are working and how do you fit yourself in the role.

  2. which cloud providers you used?

3. In AWS, you used services like EC2, S3 etc. So, what is public subnet and private subnet?

4. What is the difference between NACL (Network access contorl list) and security groups?

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

https://www.geeksforgeeks.org/computer-networks/difference-between-security-group-and-network-acl-in-aws/

5. What is the bucket policies in S3? why do we use bucket policies if we have IAM policies?

6. Whats the difference between application load balancer and network load balancer?

7. Real life scenario where you could use network load balancer specifically.
  
FEEDBACKS
  * need to work in -- VPC's from scratch.
