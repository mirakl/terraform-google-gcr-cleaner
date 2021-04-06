terraform {
  required_version = ">= 0.14.9"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.62.0"
    }
  }
}
