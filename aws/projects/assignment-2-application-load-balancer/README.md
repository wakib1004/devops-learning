# AWS Application Load Balancer: A Highly Available, Auto-Scaling Web Tier


## Setup Instructions

### Step 1 – Create Security Groups

Two security groups: 

- `A2-ALB-SG` – Allows inbound HTTP (port 80) traffic from 0.0.0.0/0, enabling public access to the load balancer over the internet.
- `A2-EC2-SG` – Security group for the EC2 instances, configured to allow inbound HTTP (port 80) traffic only from `A2-ALB-SG`

![](screenshots/A2-ALB-SG.PNG)

![](screenshots/A2-EC2-SG.PNG)

`A2-EC2-SG` ensures that the instances only accept HTTP traffic from the Application Load Balancer, rather than directly from the internet.

---

### Step 2 – Launch the EC2 Instances

Launch two Amazon EC2 instances using the `A2-EC2-SG` security group, with one instance in `eu-north-1a` AZ and the other in `eu-north-1b` AZ,
using the following User Data for both except changing the last line:

```bash
#!/bin/bash

yum update -y
yum install -y httpd

systemctl start httpd
systemctl enable httpd

echo "<h1>A2-EC2-1</h1>" > /var/www/html/index.html
```

For the other instance, change last line to the following 

```bash
echo "<h1>A2-EC2-2</h1>" > /var/www/html/index.html
```

Each instance uses a User Data script to automatically install the Apache web server and create a simple webpage displaying the instance name. This makes it easy to verify that traffic is being distributed correctly by the load balancer.

![](screenshots/A2-EC2s-Running.PNG)

![](screenshots/A2-EC2-1-UD.PNG)

![](screenshots/A2-EC2-2-UD.PNG)

---

### Step 3 – Create a Target Group

Create a target group named **`A2-TG`**.

Configure the target group with the following settings:

| Setting | Value |
|---------|-------|
| Target Type | Instances |
| Protocol | HTTP |
| Port | 80 |
| VPC | Your project VPC |
| Health Check Path | `/` |

After creating the target group, register both EC2 instances:

- `A2-EC2-1`
- `A2-EC2-2`

The health check on the root path (`/`) verifies that the Apache web server is running and responding successfully on each instance.

![](screenshots/A2-TG.PNG)

> **📸 Screenshot:** Health Check configuration with the path set to `/`.

### Step 4 – Create the Application Load Balancer

An internet-facing Application Load Balancer named **`A2-ALB`** across two public subnets in two different Availability Zones, ensuring a load balancer node is placed in each zone

![](screenshots/A2-ALB.PNG)

Two public subnets in different Availability Zones are required for an ALB as this ensures high availability.


![](screenshots/A2-ALB-SG-Attached.PNG)

This configuration enables the Application Load Balancer to receive HTTP requests from clients and distribute traffic evenly between the registered EC2 instances.

---

### Step 5 – Test Load Balancing

Once the Application Load Balancer has finished provisioning, copy its **DNS name** and open the DNS name in your web browser.

Make sure that the request is sent using HTTP if the browser defaults to HTTPS

Refresh the page several times and you should see the response alternate between:

```text
A2-EC2-1 and A2-EC2-2
```

![](screenshots/Testing-1.PNG)

![](screenshots/Testing-2.PNG)

This confirms that the Application Load Balancer is successfully distributing incoming requests across both EC2 instances.

---



