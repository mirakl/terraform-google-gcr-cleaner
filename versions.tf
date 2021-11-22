terraform {
  required_version = ">= 1.0.10"
  experiments      = [module_variable_optional_attrs]

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = ">= 2.1.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.1.0"
    }
  }
}
