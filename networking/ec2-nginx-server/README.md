# NGINX Web Server on AWS EC2 with Custom Domain

Deployed a NGINX web server on AWS EC2 and configured DNS (A record) to serve a custom domain using CloudFlare.

![Demo](Nginx.gif)

---

## 📌 Overview

This project covers:

Launching an AWS EC2 instance (Ubuntu 24)

Installing and running NGINX

Deploying a website

Connecting a Cloudflare domain to EC2

--- 

## 🧰 Tech Stack
AWS EC2 – Virtual server hosting

Ubuntu 24.04 LTS – Operating system

NGINX – Web server

Cloudflare – Domain & DNS management

--- 

## 🚀 Setup Instructions

### 1. Launch an EC2 Instance 
- Go to AWS Console → EC2 → Launch Instance
- Choose:
  - Ubuntu Server 24.04 LTS (Free Tier)
  - Instance type: t2.micro (Free Tier eligible)
- Ensure "Auto-assign public IP" is enabled
- Download .pem key pair

- Configure Security Group:
  - Allow:
    - SSH (22)
    - HTTP (80)

| Type | Port | Source | Purpose |
|------|------|---------|----------|
| SSH | 22 | 0.0.0.0/0 | Temporary secure access to instance using EC2 Instance Connect |
| HTTP | 80 | 0.0.0.0/0 | Web traffic and ACME validation |

> [!IMPORTANT]  
> In production, restrict SSH to a trusted IP or switch to Session Manager as rules with source of 0.0.0.0/0 or ::/0 allow all IP addresses to access your instance.


### 2. Connect to EC2

`ssh -i <your-key.pem> ubuntu@<your-ec2-public-dns>`

### 3. Update System and Install NGINX

```bash
sudo apt update
sudo apt install nginx
sudo systemctl status nginx # should show "active (running)"
```
If you visit the public IP address of your EC2 instance in the browser, you should now see the NGINX default welcome page.

### 4. Register a Domain

Purchase a domain from Cloudflare

### 5. 🌍 Cloudflare Domain Setup

Go to Cloudflare Dashboard → Your Domain → DNS → Add Records:

| Record | Type | Value | TTL |
|--------|------|--------|-----|
| `@` | A | `<Public IP-address of EC2 instance>` | 300 |

Set Proxy status to "proxied" 

---

## 🧠 Challenges & Learnings

### 1. NGINX not accessible via public IP

**Problem:** The NGINX server was running, but the site was not reachable via the EC2 public IP address.

**Cause:** Port 80 was opened using UFW on the instance, but not allowed in the AWS security group.

**Solution:** Updated the EC2 security group to allow inbound HTTP (port 80) traffic from 0.0.0.0/0.

**Key Insight:**

This issue reinforced the importance of checking cloud-level networking rules first. Even though I was aware that security groups in Amazon Web Services control inbound traffic, I initially focused on the instance-level firewall (UFW), which led to unnecessary debugging.

### 2. Domain stopped working after restarting EC2 instance

**Problem:** After stopping and restarting the EC2 instance, the custom domain no longer resolved correctly.

**Cause:** The public IP address of the EC2 instance changed, causing the DNS A record in Cloudflare to point to an outdated IP.

**Solution:** Updated the A record with the new public IP address of the instance.

**Key Insight:**

This highlighted that public IP addresses in Amazon Web Services EC2 are dynamic by default and can change when an instance is stopped and started. 

---

## Notes on Costs

| Service | Est. Cost | Notes |
|----------|------------|-------|
| EC2 (t2.micro) | Free Tier | Charged hourly after limit |
|  | |  |
| DNS queries |  |  |

