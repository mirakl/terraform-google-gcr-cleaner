terraform {
  required_version = ">= 0.14.9"
  experiments      = [module_variable_optional_attrs]

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.62.0"
    }
  }
}
