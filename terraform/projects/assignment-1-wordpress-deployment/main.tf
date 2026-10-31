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


resource "aws_instance" "wordpress_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.wordpress_instance_sg.id]
    tags = {
        Name = "wordpress_instance"
    }
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
