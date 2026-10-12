# AWS VPC and Networking: A Custom Cloud Network 

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonwebservices&logoColor=white)
![Amazon VPC](https://img.shields.io/badge/Amazon%20VPC-FF9900?style=for-the-badge&logo=amazonwebservices&logoColor=white)
![Amazon EC2](https://img.shields.io/badge/Amazon%20EC2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white)
![AWS IAM](https://img.shields.io/badge/AWS%20IAM-DD344C?style=for-the-badge&logo=amazonwebservices&logoColor=white)
![Amazon CloudWatch](https://img.shields.io/badge/Amazon%20CloudWatch-FF4F8B?style=for-the-badge&logo=amazoncloudwatch&logoColor=white)
![Amazon Linux](https://img.shields.io/badge/Amazon%20Linux-232F3E?style=for-the-badge&logo=amazonlinux&logoColor=white)

An AWS networking project featuring a custom VPC with public and private subnets, an Internet Gateway, a NAT Gateway, route tables, security groups, a Bastion Host, 
and a private EC2 instance with CloudWatch monitoring enabled on both instances.

## What I Built

A custom VPC with a CIDR block `10.0.0.0/16` that contains one public subnet and one private subnet, each with a `/24` CIDR block. The public subnet can access the internet through an Internet Gateway while the private subnet can access the internet through a NAT Gateway without allowing unsolicited inbound connections to it. A public EC2 instance acts as a bastion host, serving as the sole SSH entry point into the private EC2 instance. Disk and memory metrics from both instances are published to Amazon CloudWatch using the CloudWatch Agent.

**Stack:**
- **Amazon VPC**
- **Subnet**
- **Internet Gateway** 
- **NAT Gateway + Elastic IP** 
- **Route Tables**
- **Security Groups** 
- **Amazon EC2** 
- **IAM role** 
- **Amazon CloudWatch + CloudWatch agent**

## Architecture Diagram 

![](screenshots/A1-Architecture-Diagram.PNG)

How traffic flows: 
- **Me → IGW → bastion host:** SSH and HTTP access to the bastion host from my IP only.
- **Bastion host → private EC2:** SSH access to private EC2 instance from the bastion host's security group.
- **Private EC2 → NGW → IGW → internet:** Only outbound internet access but nothing on the internet can initiate connection to the instance.
- **Both instances → Cloudwatch:** Memory and disk metrics are reported to Cloudwatch.

## Setup Instructions

### Step 1 – Create the VPC 

A VPC called `A1-VPC` with the CIDR block 10.0.0.0/16, providing 65,536 private IP addresses. DNS Resolution is enabled, allowing resources within the VPC to use DNS to resolve domains into IP addresses.

![](screenshots/A1-VPC.PNG)

The VPC is a private, isolated network within a cloud provider (such as AWS).

---

### Step 2 – Create the subnets

- `A1-Public-Subnet` with the CIDR block `10.0.0.0/24` residing in `eu-north-1a` Availibility Zone (AZ).
- `A1-Private-Subnet` with the CIDR block `10.0.1.0/24` residing in `eu-north-1b` Availibility Zone (AZ).

![](screenshots/A1-Subnets.PNG)

These are smaller networks within the VPC. However, they are not yet truly public or private. Each of them have 256 IP addresses but AWS reserves 5 IPs (for network address, VPC router, DNS, future use a nd broadcast address), so only 251 are usable.

---

### Step 3 – Create and attach the Internet Gateway

Internet Gateway `A1-IGW` attached to `A1-VPC`.

![](screenshots/A1-IGW.PNG)

This is what allows the resources within the VPC to communicate with the internet. However, attaching an Internet Gateway alone does not provide internet connectivity until a route table directs traffic to it.

---

### Step 4 - Create the NAT Gateway 

NAT Gateway `A1-NGW` residing in the public subnet, with connectivity type being public and an assigned ELastic IP.

![](screenshots/A1-NGW.PNG)

The NAT Gateway allows resources within a private subnet to have outbound connections to the internet while not allowing the internet to initiate connections to the resources. It must reside in the public subnet so it can access the internet through the Internet Gateway. However, it also does not provide internet connectivity until the private subnet's route table directs traffic to it.

---

### Step 5 - Create the route tables

Two route tables, each associated with their own subnet.

- `A1-Public-RT` associated with the public subnet `A1-Public-Subnet`, with:
 - A route with destination `0.0.0.0/0` targeting the Internet Gateway `A1-IGW`.
 - A route with destination `10.0.0.0/16` targeting `local`.
- `A1-Private-RT` associated with the private subnet `A1-Private-Subnet`, with:
 - A route with destination `0.0.0.0/0` targeting the NAT Gateway `A1-NGW`.
 - A route with destination `10.0.0.0/16` targeting `local`.

![](screenshots/A1-Public-RT.PNG)

![](screenshots/A1-Private-RT.PNG)

These routes determine where traffic from resources should be sent based on its destination. The `local` target is always present and it is what lets resources within a VPC to communicate with each other.

---

### Step 6 - Create the Security Groups

Two Security Groups, one for each EC2 instance:

- `A1-Public-EC2-SG` with inbound rules allowing:
 - HTTP (Port 80) traffic from my IP
 - SSH (Port 22) traffic from my IP

- `A1-Private-EC2-SG` with inbound rules allowing:
 - HTTP (Port 80) traffic from the security group `A1-Public-EC2-SG`
 - SSH (Port 22) traffic from the security group `A1-Public-EC2-SG`

![](screenshots/A1-Public-EC2-SG.PNG)

![](screenshots/A1-Private-EC2-SG.PNG)

The `A1-Public-EC2-SG` is the security group for the bastion host. The private security group references the bastion's security group not it's IP address. This allows the private instance to be accessed through the bastion even if its IP address changes. This setup follows the principle of least privilege by minimising access to only what is necessary.

---

### Step 7 - Launch the EC2 instances

Two t3.micro EC2 instances using Amazon Linux AMI:

- `A1-Public-EC2` in the public subnet within the `eu-north-1a` AZ with an auto-assigned public IP address. Its security group is `A1-Public-EC2-SG`. This is the bastion host.
- `A1-Private-EC2` in the private subnet within the `eu-north-1b` AZ with no public IP address. Its security group is `A1-Private-EC2-SG`.

![](screenshots/A1-EC2-Instances.PNG)

---

### Step 8 - SSH into the bastion 

Connecting to the bastion server from my machine using SSH.

![](screenshots/A1-SSH-Into-Bastion.PNG)

---

### Step 9 - SSH into private EC2 instance from the bastion

Copy the private key into the bastion. From the bastion, SSH into to the private EC2 instance `A1-Private-EC2` using its private IP address.

![](screenshots/A1-Bastion-to-Private-EC2.PNG)

---

### Bonus - Cloudwatch Monitoring on the EC2 instances

Create an IAM role named `A1-CloudWatchAgentServerPolicy-Role` for EC2 instances and attach the AWS-managed `CloudWatchAgentServerPolicy` policy.

Attach the IAM role to both EC2 instances.

![](screenshots/A1-CloudWatchAgentServerPolicy-Role.PNG)

This role allows the EC2 instances to publish monitoring metrics to Amazon CloudWatch using the CloudWatch agent.

Then install and start the CloudWatch agent on both instances:

```bash

# Install the CloudWatch agent
sudo yum install amazon-cloudwatch-agent
# Run the CloudWatch agent configuration wizard
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
# Start the CloudWatch agent using the generated configuration
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \ -a fetch-config \ -m ec2 \ -s \ -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

```

During the configuration wizard, select Basic to use the default metrics configuration, which includes disk and memory metrics.

The CloudWatch agent publishes instance metrics to the `CWAgent` namespace in Amazon CloudWatch.

![](screenshots/A1-CWAgent.PNG)

---

## What I Learnt

- VPC is an isolated private network within a cloud provider.
- AWS reserves 5 IPs (for network address, VPC router, DNS, future use and broadcast address), so only 251 IPs are usable in a /24 subnet
- No subnet is inherently private or public but only becomes so after creating and configruing the route tables.

- Internet Gateway allows the resources within the VPC that have a public IP address to communicate with the internet and supports bi-directional communication
- NAT Gateway resides in the public subnet and enables internet access for resources within the private subnet without allowing unsollicted inbound connections to it.

- Route tables determine where traffic from resources should be sent based on its destination.
- The `local` target in route tables is what enables resources within a VPC to communicate with each other.

- A security group can allow access from another resource by referncing its security group and this allows it to be accessed even if the IP of the other resource changes

