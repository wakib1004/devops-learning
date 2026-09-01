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

### Step 4 - Create the NAT Gateway 

Create the NAT Gateway named `A1-NGW` in the public subnet, with connectivity type being public and an assigned ELastic IP.

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



---



