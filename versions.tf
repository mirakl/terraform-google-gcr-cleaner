terraform {
  required_version = ">= 1.0.10"
  experiments      = [module_variable_optional_attrs]

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.88.0"
    }
  }
}
