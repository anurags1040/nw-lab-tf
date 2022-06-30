variable "environment" {
    description = "Name of the enviornment where Network is located"
}

variable "regions" {
  type = list(string)
  description = "Region of the subnets"
}


****//cidr_range is the range of the VPC//****

variable "cidr_range" {
  type = string
  description = "IP address range of the VPC"
}

***// subnet_size is the size of the subent that you need. eg 10.0.0.0/24 is 24 //*****

variable "subnet_size" {
    type = number
}

****///locals here is used basically to calculate the cidr ranges. split_cidr will split 10.0.0.0/8 into a list 10.0.0.0, 8. cidr_size will pop out number 8 using element function
// and newbits will be 24-8=16. This is a good and easy way to calculate the IP CIDRs

locals {
  split_cidr = split("/", var.cidr_range)
  cidr_size  = element(local.split_cidr, length(local.split_cidr) - 1)
  newbits    = var.subnet_size - tonumber(local.cidr_size)
}

resource "google_compute_network" "network" {
  name                    = "${var.environment}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  count         = length(var.regions)
  name          = "${var.environment}-subnet-${var.regions[count.index]}"
  ip_cidr_range = cidrsubnet(var.cidr_range, local.newbits, count.index)
  region        = var.regions[count.index]
  network       = google_compute_network.network.name
}


output "vpc_id" {
  value = google_compute_network.network.id
}
