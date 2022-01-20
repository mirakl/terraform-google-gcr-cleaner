provider "google" {
  project = var.google_project_id
  region  = var.region
}

provider "google-beta" {
  project = var.google_project_id
  region  = var.region
}
