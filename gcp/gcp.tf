variable "GCPproject_id" {
    type = "string"
}

variable "deployregions" {
    type = "map"
    default = {
        "aws" = "ap-southeast-2"
        "gcp" = "australia-southeast1"
        "azure" = "australiaeast"
    }
}

variable "VPCNames" {
    type = "map"
    default = {
        "aws" = "AWS-VPC-PROD-01"
        "gcp" = "gcp-vpc-prod01"
        "azure" = "AZURE-VNET-PROD-01"
    }
}

variable "VPCRanges" {
    type = "map"
    default = {
        "aws" = "10.1.0.0/16"
        "gcp" = "10.2.0.0/16"
        "azure" = "10.3.0.0/16"
    }
}

variable "GCPSubnetRanges" {
    type = "map"
    default = {
        "1" = "10.2.0.0/25"
        "2" = "10.2.0.128/25"
        "3" = "10.2.1.0/25"
        "4" = "10.2.1.128/25"
    }
}

provider "google" {
    credentials =  "${file("./gcpcreds.json")}"
    project = var.GCPproject_id
    region  = ""
}

resource "google_compute_network" "GCP-VCP" {
    name = var.VPCNames["gcp"]
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "VPC-SUBNETS" {
    name = format("gcp-vpc-prod-sub%02s", count.index+1)
    ip_cidr_range = "${element(values(var.GCPSubnetRanges), count.index)}"
    network = "${google_compute_network.GCP-VCP.self_link}"
    count = "${length(var.GCPSubnetRanges)}"
    depends_on = [google_compute_network.GCP-VCP]
}