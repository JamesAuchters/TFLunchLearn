provider "aws" {
    profile = "Terraform"
    region  = "ap-southeast-2"
}

variable "VPCRange" {
    type = "string"
    default = "10.1.0.0/16"
}

variable "Sub0CIDR" {
    type = "string"
    default = "10.1.0.0/24"
}

variable "Sub1CIDR" {
    type = "string"
    default = "10.1.1.0/24"
}

variable "Sub2CIDR" {
    type = "string"
    default = "10.1.2.0/24"
}

variable "VPCName" {
    type = "string"
    default = "TF-VPC-01"
}

resource "aws_vpc" "AWS-VPC" {
    cidr_block = var.VPCRange
    tags = {
        Name = var.VPCName
    }
}

resource "aws_subnet" "AWS-VPCSubnet0" {
    vpc_id = aws_vpc.AWS-VPC.id
    cidr_block = var.Sub0CIDR
    tags = {
        Name = "AWS-VPC-PROD-SUB00"
    }
    depends_on = [aws_vpc.AWS-VPC]
}

resource "aws_subnet" "AWS-VPCSubnet1" {
    vpc_id = aws_vpc.AWS-VPC.id
    cidr_block = var.Sub1CIDR
    tags = {
        Name = "AWS-VPC-PROD-SUB01"
    }
    depends_on = [aws_vpc.AWS-VPC]
}

resource "aws_subnet" "AWS-VPCSubnet2" {
    vpc_id = aws_vpc.AWS-VPC.id
    cidr_block = var.Sub2CIDR
    tags = {
        Name = "AWS-VPC-PROD-SUB02"
    }
    depends_on = [aws_vpc.AWS-VPC]
}