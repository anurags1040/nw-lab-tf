terraform {
  required_version = ">= 1.2.2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.53"
    }
  }
  backend "gcs" {
    bucket = "building-fle-266-34ab51b9"
    prefix = "dev/network"
  }
}

module "network" {
    source = "../../modules/networking"

    environment = "dev"
    regions     = ["us-east1", "us-east4", "us-west1", "us-west4"]
    cidr_range  = "10.0.0.0/16"
    subnet_size = 24
}
