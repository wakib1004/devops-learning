# Deploying a Full Wordpress Stack on AWS using Terraform 
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonwebservices&logoColor=white)
![Amazon EC2](https://img.shields.io/badge/Amazon%20EC2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white)
![WordPress](https://img.shields.io/badge/WordPress-21759B?style=for-the-badge&logo=wordpress&logoColor=white)
![GNU Bash](https://img.shields.io/badge/GNU%20Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

Deployed a WordPress application on AWS using Terraform by provisioning an EC2 instance and a MariaDB database, automating the installation of WordPress and its required dependencies, configuring WordPress to connect to the database, and setting up security groups to enable public web access and secure database connectivity.

---

## Technology Stack

| Technology | Purpose |
|---|---|
| **Terraform** | Infrastructure as Code tool used to provision and manage AWS resources. |
| **Amazon EC2** | Hosts the WordPress application and its required dependencies. |
| **AWS Security Groups** | Controls inbound and outbound network traffic to the EC2 instance. |
| **Ubuntu Server 26.04 LTS** | Operating system running on the EC2 instance. |
| **Apache** | Web server responsible for serving the WordPress application. |
| **MariaDB** | Database used to store WordPress data. |
| **PHP** | Scripting language required to run WordPress. |
| **WordPress** | Content management system used to build and manage the website. |
| **Bash** | Used to automate the installation and configuration of the application through EC2 user data. |

---

## How It Works

The deployment process follows these steps:

1. **Terraform provisions the infrastructure.** Terraform uses the AWS provider to communicate with AWS and provision an EC2 instance and its associated security group.

2. **The EC2 instance launches.** An Ubuntu Server 26.04 LTS instance is created with a public IPv4 address, providing a publicly accessible endpoint.

3. **User data executes automatically.** During the initial boot process, the Bash user data script executes to install and configure the required software.

4. **The LAMP stack is installed.** Apache, MariaDB and PHP are installed to provide the environment required to run WordPress.

5. **The database is configured.** A MariaDB database and dedicated database user are created, with the necessary privileges granted.

6. **WordPress is installed and configured.** The WordPress package is downloaded, extracted and copied into the Apache web directory. Its configuration file is updated with the database connection details.

7. **The application becomes accessible.** Once the installation and configuration process completes, users can access the WordPress application through the EC2 instance's public IPv4 address and custom domain.

---

## Terraform Code Structure

The Terraform code is organised into separate files to keep the infrastructure configuration simple and maintainable.

- **main.tf:** Defines the infrastructure resources and their configurations.
- **variables.tf:** Declares input variables used in the Terraform configuration.
- **outputs.tf:** Defines output values that are displayed after the `terraform apply` command completes, such as the instance ID, public IP address public DNS.
- **terraform.tfvars:** Provides environment-specific values for the declared variables.
- **.terraform.lock.hcl:** Maintains consistent provider versions across Terraform executions.
- **.terraform directory.:** Contains downloaded Terraform provider plugins and any other files if they are required to initialise and manage the Terraform working directory.
- **terraform.tfstate:** Terraform uses the state file to track the infrastructure resources it manages.
- **terraform.tfstate.backup:** Contains a backup of the Terraform state file.

---

## What I built

1. Terraform Provider Configuration

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
Configured the Terraform AWS provider (which is a plugin) to allow Terraform to communicate with AWS. Specified the AWS region (eu-north-1). This enables Terraform to provision and manage AWS resources within that specified region.

2. Variables
```hcl
variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

```

Configured variable blocks in a seperate variables.tf file, defining input variables to ensure the Terraform code is dynamic and reusable.

3. Configuration of the values of the input variables
```hcl
ami = "ami-021aaf3749be66813"
instance_type = "t3.micro"
```

Configured the values of the input variables in a seperate file terraform.tfvars

4. Creating the user data script for the EC2 instance 

```bash
   #!/bin/bash

   #Variables
   DB_name=wordpress_db
   DB_user=wp_user
   DB_password=password

   #Update and upgrade the system
   apt update && apt upgrade -y

   #Install Apache web server for WordPress
   apt install apache2 -y

   #Install MariaDB server and MariaDB command-line client
   apt install mariadb-server mariadb-client -y

   #Install PHP and a PHP module that allows PHP to communicate with MySQL-based databases
   apt install php php-mysql -y

   #Create a database and a user with all privileges granted on the database
   mysql -u root << EOL
   CREATE DATABASE $${DB_name};
   CREATE USER "$${DB_user}"@"localhost" IDENTIFIED BY "$${DB_password}";
   GRANT ALL ON $${DB_name}.* TO "$${DB_user}"@"localhost" IDENTIFIED BY "$${DB_password}";
   FLUSH PRIVILEGES;
   EXIT;
   EOL

   #Install and extract the WordPress package
   cd /tmp && wget https://wordpress.org/latest.tar.gz
   tar -xzvf latest.tar.gz

   #Copy the wordpress folder into /var/www/html/ directory 
   cp -R wordpress /var/www/html/

   #Make www-data the owner and the group of the wordpress directory
   chown -R www-data:www-data /var/www/html/wordpress/

   #Configure WordPress to connect to the database
   mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
   sed -i "s/database_name_here/$${DB_name}/" /var/www/html/wordpress/wp-config.php
   sed -i "s/username_here/$${DB_user}/" /var/www/html/wordpress/wp-config.php
   sed -i "s/password_here/$${DB_password}/" /var/www/html/wordpress/wp-config.php
```

5. Configuration of the Security Group

```hcl 
resource "aws_security_group" "wordpress_instance_sg" {
  name        = "wordpress_instance_sg"
  description = "Allow HTTP inbound traffic and all outbound traffic"

  tags = {
    Name = "wordpress_instance_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.wordpress_instance_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.wordpress_instance_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
```

Configured the security group `wordpress_instance_sg` with the following: 
- Inbound rule allowing inbound HTTP traffic from anywhere
- Outbound rule allowing all outbound traffic

This is to ensure there is a public endpoint where we can reach the web server.

6. Configuration of the EC2 instance

```hcl
resource "aws_instance" "wordpress_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.wordpress_instance.id]
  user_data =  <<-EOF
   #!/bin/bash

   #Variables
   DB_name=wordpress_db
   DB_user=wp_user
   DB_password=password

   #Update and upgrade the system
   apt update && apt upgrade -y

   #Install Apache web server
   apt install apache2 -y

   #Install MariaDB server and MariaDB command-line client
   apt install mariadb-server mariadb-client -y

   #Install PHP and a PHP module that allows PHP to communicate with MySQL-based databases
   apt install php php-mysql -y

   #Create a database and a user with all privileges granted on the database
   mysql -u root << EOL
   CREATE DATABASE $${DB_name};
   CREATE USER "$${DB_user}"@"localhost" IDENTIFIED BY "$${DB_password}";
   GRANT ALL ON $${DB_name}.* TO "$${DB_user}"@"localhost" IDENTIFIED BY "$${DB_password}";
   FLUSH PRIVILEGES;
   EXIT;
   EOL

   #Install and extract the WordPress package
   cd /tmp && wget https://wordpress.org/latest.tar.gz
   tar -xzvf latest.tar.gz

   #Copy the wordpress folder into /var/www/html/ directory 
   cp -R wordpress /var/www/html/

   #Make www-data the owner and the group of the wordpress directory
   chown -R www-data:www-data /var/www/html/wordpress/

   #Configure WordPress to connect to the database
   mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
   sed -i "s/database_name_here/$${DB_name}/" /var/www/html/wordpress/wp-config.php
   sed -i "s/username_here/$${DB_user}/" /var/www/html/wordpress/wp-config.php
   sed -i "s/password_here/$${DB_password}/" /var/www/html/wordpress/wp-config.php

EOF
}
``` 

Configured an EC2 t3.micro instance with Ubuntu Server 26.04 LTS and assigned a public IP address to establish a publicly accessible endpoint

7. Configuration of the output variables

```hcl 
output "instance_id" {
  description = "The ID of the EC2 instance"
  value = aws_instance.wordpress_instance.id
}

output "instance_public_IPv4_address" {
  description = "The public IPv4 address of the EC2 instance"
  value = aws_instance.wordpress_instance.public_ip
}

output "instance_public_DNS" {
  description = "The public DNS of the EC2 instance"
  value = aws_instance.wordpress_instance.public_dns
}
```
Configured the ouput variables to display instance details such as the ID, public IPv4 address 
and the public DNS after the command `terraform apply`
has been completed.

8. Deploying to AWS cloud

```bash 

#I configured the AWS credentials by exporting the access key ID and secret access key as environment variables. This allowed Terraform to authenticate with AWS.

export AWS_ACCESS_KEY_ID="<AWS_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<AWS_SECRET_ACCESS_KEY>"

terraform init #Initializes the working directory. Downloads the provider and configures the 
backend for the Terraform State file 

terraform validate #Validates the terraform configuration files within that working directory to ensure they are syntactically valid 
and internally consistent

terraform plan #Creates an execution plan and determines the nessecary actions required to achieve the desired
state specified in configuration files.

terraform apply #Applies the changes defined in the Terraform configuration files to create, update, or destroy infrastructure as required.

```
Then the site was live on both 51.21.171.237/wordpress and <custom domain>/wordpress: 

<img width="995" height="686" alt="wordpress_screenshot" src="https://github.com/user-attachments/assets/c9be125b-7153-4ea3-b731-6850d552786d" />


---

### What I learnt

1. How to create security groups with inbound and outbound rules using Terraform. 

2. EOF is a commonly used delimiter in here documents (heredocs) that allows multiline strings to be passed as input to a command. 
In Terraform configuration files, heredocs can be used to provide multiline string values, such as user data scripts. The delimiter EOF is not mandatory; you can use other identifiers, such as EOT, END, or HERE.

3. How to configure output blocks to display useful output values after the terraform apply command completes.

4. The argument `user_data_replace_on_change = true` can be used to replace the EC2 instance every time changes are made to its user data.

5. When creating an EC2 instance within a VPC using Terraform, use the `vpc_security_group_ids` argument to associate security groups with the instance instead of the `security_groups` argument, which is primarily intended for EC2-Classic (legacy).

### Any issues I hit and how I fixed them

1. Invalid reference error in user data script

Error message:
"A reference to a resource type must be followed by at least one attribute access, specifying the resource name."

Cause:

Within the user data script, I attempted to expand variables using the ${} syntax. However, this syntax was interpreted as a reference to a Terraform resource type rather than as a variable.

Solution:

I replaced ${} with $${} to escape the interpolation syntax and ensure the variables were expanded correctly within the user data script.
After making this change, the error was resolved.

2. Error establishing a database connection

- Within the user data script, I tried to expand the variables using ${} within single quotes.
- I specified the password without quotes in the `IDENTIFIED BY` clause. However, this caused an error because the password needed to be enclosed in quotes.

Solution:

- I changed the variable expansion to use double quotes.
- I ensured that the password was enclosed in double quotes after the IDENTIFIED BY clause. 

After making these changes, the database connection error was resolved.

----

## Files

- [`README.md`](README.md) - this file
- [`variables.tf`](variables.tf) - input variables (instance type, AMI, region)
- [`main.tf`](main.tf) - EC2 instance, security group, and AWS provider
- [`outputs.tf`](outputs.tf) - the IP and domain URLs printed after `terraform apply` command
- [`terraform.tfvars`](terraform.tfvars) - Defines the actual values assigned to the input variables declared in variables.tf
- [`.gitignore`](.gitignore) - used to exclude the state file, `terraform.tfstate.backup` and the `.terraform` directory
