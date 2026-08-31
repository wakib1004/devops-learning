# AWS VPC and Networking: A Custom Cloud Network 


## Setup Instructions

### Step 1 – Create the VPC 

A VPC called `A1-VPC` with the CIDR block 10.0.0.0/16, providing 65,536 private IP addresses. DNS Resolution is enabled, allowing resources within the VPC to use DNS to resolve domains into IP addresses.

![](screenshots/A1-VPC.PNG)

The VPC is a private, isolated network within a cloud provider (such as AWS).

---

### Step 2 – Create the subnets

- `A1-Public-Subnet` with the CIDR block `10.0.0.0/24` residing in `eu-north-1a` Availibility Zone.
- `A1-Private-Subnet` with the CIDR block `10.0.1.0/24` residing in `eu-north-1b` Availibility Zone.

![](screenshots/A1-Subnets.PNG)

These are smaller networks within the VPC. However, they are not yet truly public or private. Each of them have 256 IP addresses but AWS reserves 5 IPs (for network address, VPC router, DNS, future use a nd broadcast address), so only 251 are usable.

---

### Step 3 – Create and attach the Internet Gateway

Internet Gateway `A1-IGW` attached to `A1-VPC`.

![](screenshots/A1-IGW.PNG)

This is what allows the resources within the VPC to send and receive Internet traffic. However, attaching an Internet Gateway alone does not provide internet connectivity until a route table directs traffic to it.

---



