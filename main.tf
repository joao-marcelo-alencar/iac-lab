terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "devops" {
  name        = "devops"
  description = "Grupo de Seguranca da Disciplina DevOps"

  tags = {
    Name = "devops"
  }
}

resource "aws_vpc_security_group_ingress_rule" "permitir_ssh_ipv4" {
  security_group_id = aws_security_group.devops.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "permitir_http_ipv4" {
  security_group_id = aws_security_group.devops.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "permitir_todo_trafego_saida" {
  security_group_id = aws_security_group.devops.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "web_server" {
  ami             = "ami-0c7217cdde317cfec"
  instance_type   = "t2.micro"
  key_name        = "vockey"
  security_groups = [aws_security_group.devops.name]

  tags = {
    Name = "ServidorWeb"
  }
}

output "instance_public_ip" {
  description = "Endereço IP público da instância EC2"
  value       = aws_instance.web_server.public_ip
}

output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.web_server.id
}


