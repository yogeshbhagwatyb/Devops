terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# === Inputs ===
variable "vpc_id" {
  type    = string
  default = "vpc-0cfad06ba8721934c"
}
variable "subnet_id" {
  type    = string
  default = "subnet-0063c047e03c260c4"
}
variable "security_group_id" {
  type    = string
  default = "sg-0a81b606fed63b01e"
}
variable "key_name" {
  type    = string
  default = "aws-singlebox-key"
}
# relative path; file is alongside main.tf
variable "ssh_private_key_path" {
  type    = string
  default = "./aws-singlebox-key.pem"
}

# compute absolute path for SSH
locals {
  ssh_key_abs = abspath(var.ssh_private_key_path)
}

# === Ubuntu AMI ===
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# === EC2 Instance ===
resource "aws_instance" "ubuntu" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "ubuntu_server-public-20250801T055216Z"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(local.ssh_key_abs)
      host        = self.public_ip
      timeout     = "5m"
    }

    inline = [
      # update and enable universe repo for completeness
      "sudo apt-get update -y",
      "sudo apt-get install -y software-properties-common",
      "sudo add-apt-repository -y universe",
      "sudo apt-get update -y",

      # Install Temurin 17 (Java 17) from Adoptium
      "sudo mkdir -p /usr/share/keyrings",
      "wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo gpg --dearmor -o /usr/share/keyrings/adoptium.gpg",
      "echo 'deb [signed-by=/usr/share/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb jammy main' | sudo tee /etc/apt/sources.list.d/adoptium.list",
      "sudo apt-get update -y",
      "sudo apt-get install -y temurin-17-jdk",

      # Verify Java
      "java -version || { echo 'Java installation failed'; exit 1; }",

      # install nginx
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx || true",
      "sudo systemctl start nginx || true",

      # install docker
      "curl -fsSL https://get.docker.com | sudo bash",
      "sudo usermod -aG docker ubuntu || true",
      "sudo systemctl enable docker || true",
      "sudo systemctl start docker || true",

      # Jenkins repo + key
      "curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
      "echo 'deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/' | sudo tee /etc/apt/sources.list.d/jenkins.list",
      "sudo apt-get update -y",

      # install Jenkins with retry
      "for i in {1..3}; do sudo DEBIAN_FRONTEND=noninteractive apt-get install -y jenkins && break || { echo \"Jenkins install failed, retrying ($i)...\"; sleep 5; }; done || true",

      # ensure Jenkins uses Java 17 explicitly
      "sudo sed -i '/^JENKINS_JAVA_CMD=/d' /etc/default/jenkins",
      "echo 'JENKINS_JAVA_CMD=$(readlink -f $(which java))' | sudo tee -a /etc/default/jenkins",

      # fix any broken deps and reload/start
      "sudo apt-get install -f -y || true",
      "sudo systemctl daemon-reload || true",
      "sudo systemctl enable jenkins || true",
      "sudo systemctl restart jenkins || true",

      # wait then show status
      "sleep 10",
      #"sudo systemctl status jenkins.service || true"
      "sudo systemctl status jenkins.service -l --no-pager || true"
    ]
  }

  #   lifecycle {
  #     create_before_destroy = true
  #   }
}

# === Outputs ===
output "instance_id" {
  value = aws_instance.ubuntu.id
}
output "public_ip" {
  value = aws_instance.ubuntu.public_ip
}
output "ssh_command" {
  value = "ssh -i \"${local.ssh_key_abs}\" ubuntu@${aws_instance.ubuntu.public_ip}"
}
