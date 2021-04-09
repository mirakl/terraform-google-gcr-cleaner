terraform {
  required_version = ">= 0.14.9"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = ">= 2.1.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 3.62.0"
    }
  }
}
