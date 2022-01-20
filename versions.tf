terraform {
  required_version = ">= 1.0.10"
  experiments      = [module_variable_optional_attrs]

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.1.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.1.0"
    }
  }
}
