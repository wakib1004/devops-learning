# Deployed an EC2 instance and configured it using Terraform and a cloud-init file

Used Terraform to provision and configure an EC2 instance, use a cloud-init YAML file as the user data to install Apache HTTP server and to provision and 
configure the security group for the EC2 instance to allow inbound HTTP access and all outbound traffic. Structured the Terraform code for clarity using 
variables and modules to make the code dynamic and reusable.

---

## What I built

### 1. Terraform Provider Configuration

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}
```
Configured the Terraform AWS provider (which is a plugin) in the `providers.tf` file to allow Terraform to communicate with AWS. Specified the AWS region (eu-north-1). This enables Terraform to provision and manage AWS resources within that specified region.

### 2. The cloud-init YAML file

```yaml
#cloud-config

# Update and upgrade packages on the system
package_update: true
package_upgrade: true

# Install apache2
packages: 
- apache2
```
Created the file `cloud-init.yaml` to use as user data for the EC2 instance to automatically configure the instance when it first starts.


### 3. Creating the Modules Directory

Created a `modules` directory to organise the Terraform configuration into reusable modules. Within this directory, two subdirectories were created:

- `ec2` – Responsible for creating and configuring the EC2 instance.
- `security_group` – Responsible for creating and configuring the security group.

Using separate modules promotes modularity and code reusability, allowing us to follow the software engineering principle known as DRY (Do Not Repeat
Yourself).

### 4. Creating the ec2 Module

Created three Terraform configuration files and ensured they were placed within the modules/ec2 directory to define the EC2 instance, its input variables, and its outputs.

#### 4.1 - Configured the input variables in `variables.tf`:

```hcl
variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "user_data" {
  type = string
}
```

Rather than hardcoding values directly into the resource configuration, these variables allow the ec2 module to accept different configuration values when called from the root module, making it more dynamic and reusable.

#### 4.2 - Configured the EC2 instance in `ec2.tf`:

```hcl
resource "aws_instance" "a2_ec2_instance" {
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = var.vpc_security_group_ids
    user_data = file(var.user_data)
}
```

The input variables defined in variables.tf are used to configure the EC2 instance. 

The file() function reads the contents of the specified user data script and passes them to the EC2 instance during initialisation. The user data is then used 
to automatically configure the EC2 instance when it first starts.


#### 4.3 - Configured output blocks to expose important information about the EC2 instance after Terraform provisions the infrastructure.

```hcl
output "instance_id" {
  description = "The ID of the EC2 instance"
  value = aws_instance.a2_ec2_instance.id
}

output "instance_public_IPv4_address" {
  description = "The public IPv4 address of the EC2 instance"
  value = aws_instance.a2_ec2_instance.public_ip
}

output "instance_public_DNS" {
  description = "The public DNS of the EC2 instance"
  value = aws_instance.a2_ec2_instance.public_dns
}
``` 
These outputs make it easier to retrieve important instance details without having to navigate through the AWS Management Console.

### 5. Creating the security_group Module

Created three Terraform configuration files and ensured they were placed within the the modules/security_group directory to define the security group and its inbound and outbound rules, its input variables, and its output.

#### 5.1 - Configured the input variables for `security_group.tf` in variables.tf

```hcl
variable "security_group_description" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "security_group_tags" {
  type = map(string)
}

variable "ingress_cidr_ipv4" {
  type = string
}

variable "ingress_from_port" {
  type = number
}

variable "ingress_to_port" {
  type = number
}

variable "ingress_ip_protocol" {
  type = string
}

variable "egress_cidr_ipv4" {
  type = string
}

variable "egress_ip_protocol" {
  type = string
}
```
Defined the input variables required to configure the security group and its ingress and egress rules.

#### 5.2 - Created the security group resource and defined separate ingress and egress rules in the `security_group.tf` file

```hcl 
resource "aws_security_group" "a2_ec2_instance_sg" {
  name        = var.security_group_name
  description = var.security_group_description
  tags = var.security_group_tags
}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress_rule" {
  security_group_id = aws_security_group.a2_ec2_instance_sg.id
  cidr_ipv4         = var.ingress_cidr_ipv4
  from_port         = var.ingress_from_port
  ip_protocol       = var.ingress_ip_protocol
  to_port           = var.ingress_to_port
}

resource "aws_vpc_security_group_egress_rule" "sg_egress_rule" {
  security_group_id = aws_security_group.a2_ec2_instance_sg.id
  cidr_ipv4         = var.egress_cidr_ipv4
  ip_protocol       = var.egress_ip_protocol 
}
``` 
The security group allows inbound HTTP traffic so users can access the Apache2 web server, while permitting all outbound traffic so the EC2 instance can install the Apache2 package.

#### 5.3 -  Configured the output blocks in the `ouputs.tf` file:

```hcl
output "a2_ec2_security_group_id" {
  description = "The ID of the security group"
  value = aws_security_group.a2_ec2_instance_sg.id
}
```
This allows the security group ID to be passed from the security_group module to the ec2 module through the root module, enabling the security group to be attached to the EC2 instance.

### 6. Calling the Modules from the Root Module in `main.tf`

#### 6.1 - Calling the ec2 module

Configured the ec2 module block in main.tf to provision and configure the EC2 instance.

```hcl 
module "ec2" {
  source = "./modules/ec2"

  ami = "ami-021aaf3749be66813"
  instance_type = "t3.micro"
  vpc_security_group_ids = [module.security_group.a2_ec2_security_group_id]
  user_data = "cloud-init.yaml"
}
```

Provided the required input variable values to configure the EC2 instance. The `vpc_security_group_ids` argument references the `a2_ec2_security_group_id`
output from the security_group module, passing the security group ID into the ec2 module so it can be attached to the instance.

#### 6.2 - Calling the security_group module

Configured the security_group module block in main.tf to provision and configure the security group.

```hcl
module "security_group" {
  source = "./modules/security_group"

  security_group_name = "a2-ec2-sg"
  security_group_description = "Allow inbound HTTP and all outbound traffic"
  security_group_tags = {
    Name = "a2-ec2-sg"
  }

  ingress_cidr_ipv4 = "0.0.0.0/0"
  ingress_from_port = 80
  ingress_to_port = 80
  ingress_ip_protocol = "tcp"

  egress_cidr_ipv4 = "0.0.0.0/0"
  egress_ip_protocol = "-1" # semantically equivalent to all ports
}
```
Provided the required input variable values to configure the security group, allowing inbound HTTP traffic on port 80 and all outbound traffic.

The security group ID is exposed through the module's output block and referenced by the ec2 module, allowing both modules to work together.

#### 7. 
```bash
terraform init #

terraform validate

terraform plan

terraform apply
```



---
 
### What I learnt

1. Terraform's file() function can be used to use an external file as the user data, such as cloud-init.yaml, rather than embedding the entire script 
directly in the Terraform configuration.

2. A cloud-init YAML file can be used to configure a EC2 instance when it first starts. 

3. How to use **cloud-init** to automate the initial setup of a virtual machine.

From doing this, I learnt:

- `#cloud-config` – the file begins with this line and it is required to identify the commands as cloud-init directives.
- `package_update: true` – Updates the package list so the system knows about the latest available software packages.
- `package_upgrade: true` – Upgrades the packages already installed on the system to their latest available versions.
- `packages: 
  - apache2` – Allows me to specify which software packages I want installed automatically, in this case it would install apache2.

4. You can configure the inputs as arguments in the module block allowing you to customize the module's behavior without modifying the module's source code.

5. Parent modules can access the child module outputs using `module.<CHILD_MODULE_NAME>.<OUTPUT_NAME>` syntax. This then allows us
to use those outputs for other parts of our configuration.

6. I don't fully understand 
│   on modules\ec2\ec2.tf line 5, in resource "aws_instance" "a2_ec2_instance":
│    5:     user_data = file("cloud-init.yaml")
│     ├────────────────
│     │ while calling file(path)

---

## Any issues I hit and how I fixed them

### 1. Forgot to Put Quotation Marks Around the YAML File Name When Referencing It in Terraform

**Error:**

After running `terraform validate`, I received the following error message:

```text
Error: Reference to undeclared resource

on main.tf line 4, in resource "aws_instance" "name":
4: user_data = file(cloud-init.yaml)

A managed resource "cloud-init" "yaml" has not been declared in the root module.
```

**Cause:**

I forgot to put quotation marks around the filename in the `file()` function. Without quotation marks, Terraform interpreted `cloud-init.yaml` as a resource reference rather than a file path.

**Solution:**

I added quotation marks around the filename in `main.tf`, changing the line to:

```hcl
user_data = file("cloud-init.yaml")
```

After making this change, Terraform was able to recognise the filename correctly and the error was resolved.


### 2. 'This site can't be reached'

**Solution:**
I created a secuirty group with inbound rule allowing HTTP traffic from anywhere and that error was resolved.

### 3. The module was not installed after configuring the module blocks in `main.tf`

**Error Message: 

│  Error: Module not installed
│
│   on main.tf line 1:
│    1: module "ec2" {
│ 
│ This module is not yet installed. Run "terraform init" to install all modules required by this
│ configuration.
╵
Same error was there for the `security_group` module.

**Solution:** 
I ran the command `terraform init` and the error was resolved.


### 4. Failed to access the ID of the Security group from a child module

**Error message:**

│ Error: Reference to undeclared resource
│ 
│   on modules\ec2\ec2.tf line 4, in resource "aws_instance" "a2_ec2_instance":
│    4:     vpc_security_group_ids = [aws_security_group.a2_ec2_instance_sg.id]
│ 
│ A managed resource "aws_security_group" "a2_ec2_instance_sg" has not been declared in
│ module.ec2.

**Cause:**

The security group was configured in the security group module but the ec2 module is trying to reference it as though it were a resource within it.

**Solution:**

To resolve this issue, I needed to pass the security group's ID from the security group child module to the EC2 child module through the root module.

- I configured an output block in the security group module to expose the security group's ID to the root module
- I configure an input variable in the EC2 module to accept the security group ID, and referenced that variable in ec2.tf in the resource block:
`vpc_security_group_ids = var.vpc_security_group_ids`
- I passed the output from the security_group module into the ec2module through the root module's configuration:
```hcl module "ec2" {
  source = "./modules/ec2"

  vpc_security_group_ids = [module.security_group.a2_ec2_security_group_id]
}
```
After this, the error was resolved.

### 5. ???

│ Error: Invalid function argument
│ 
│   on modules\ec2\ec2.tf line 5, in resource "aws_instance" "a2_ec2_instance":
│    5:     user_data = file("cloud-init.yaml")
│     ├────────────────
│     │ while calling file(path)
│ 
│ Invalid value for "path" parameter: no file exists at "cloud-init.yaml"; this function works
│ only with files that are distributed as part of the configuration source code, so if this file
│ will be created by a resource in this configuration you must instead obtain this result from
│ an attribute of that resource.
╵

---
