# AWS Application Load Balancer: A Highly Available, Auto-Scaling Web Tier

---
## Setup Instructions
---

### Step 1 – Create Security Groups

#### Create the Application Load Balancer Security Group

Create a security group named **`A2-ALB-SG`** with the following inbound rule:

| Type | Protocol | Port | Source |
|------|----------|------|--------|
| HTTP | TCP | 80 | `0.0.0.0/0` |

This allows HTTP traffic from the internet to reach the Application Load Balancer.

![](screenshots/A2-ALB-SG.PNG)

---

#### Create the EC2 Security Group

Create another security group named **`A2-EC2-SG`** with the following inbound rule:

| Type | Protocol | Port | Source |
|------|----------|------|--------|
| HTTP | TCP | 80 | `A2-ALB-SG` |

This configuration ensures that the EC2 instances only accept HTTP traffic from the Application Load Balancer, rather than directly from the internet.

![](screenshots/A2-EC2-SG.PNG)

---

### Step 2 – Launch the EC2 Instances

Launch two Amazon EC2 instances using the **`A2-EC2-SG`** security group.

| Instance Name | Availability Zone | 
|---------------|-------------------|
| `A2-EC2-1` | `eu-north-1a` |
| `A2-EC2-2` | `eu-north-1b` |

Each instance uses a User Data script to automatically install the Apache web server and create a simple webpage displaying the instance name. This makes it easy to verify that traffic is being distributed correctly by the load balancer.

![](screenshots/A2-EC2s-Running.PNG)

---

### Step 3 – Configure User Data

#### User Data for `A2-EC2-1`

```bash
#!/bin/bash

yum update -y
yum install -y httpd

systemctl start httpd
systemctl enable httpd

echo "<h1>A2-EC2-1</h1>" > /var/www/html/index.html
```

#### User Data for `A2-EC2-2`

Use the same script, but replace the final line with:

```bash
echo "<h1>A2-EC2-2</h1>" > /var/www/html/index.html
```

This creates a unique webpage on each instance, allowing you to identify which EC2 instance is serving requests during load balancing.

> **📸 Screenshot:** User Data section during EC2 instance creation.

---

### Step 4 – Create a Target Group

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

### Step 5 – Create the Application Load Balancer

Create an Application Load Balancer named **`A2-ALB`**.

Configure it with the following settings:

| Setting | Value |
|---------|-------|
| Scheme | Internet-facing |
| Type | Application Load Balancer |
| IP Address Type | IPv4 |
| Availability Zones | Two public subnets across two Availability Zones |
| Security Group | `A2-ALB-SG` |

Next, configure an HTTP listener:

| Listener | Action |
|----------|--------|
| HTTP (Port 80) | Forward requests to `A2-TG` |

![](screenshots/A2-ALB.PNG)

![](screenshots/A2-ALB-SG-Attached.PNG)

This configuration enables the Application Load Balancer to receive HTTP requests from clients and distribute traffic evenly between the registered EC2 instances.

---


