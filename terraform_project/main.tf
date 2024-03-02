terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.50.0"
    }

  }
}

provider "google" {
  credentials = file("./terraform-pipeline-376318-6cea6722c9c5.json")
  project     = var.project
  region      = var.region
}

resource "google_compute_network" "tf_vpc_pipeline" {
  name                    = "terraform-network"
  auto_create_subnetworks = true

}

resource "google_compute_subnetwork" "tf_vpc_subpipeline" {
  name          = "terraform-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.tf_vpc_pipeline.name

}

resource "google_app_engine_application" "app" {
  project     = var.project
  location_id = var.region

}

resource "google_compute_instance" "tf_compute_instance" {
  name                      = "tf-compute-instance"
  machine_type              = "e2-medium"
  zone                      = "us-central1-a"
  allow_stopping_for_update = true


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.tf_vpc_pipeline.name
    subnetwork = google_compute_subnetwork.tf_vpc_subpipeline.name
    access_config {}
  }
}

resource "google_sql_database" "tf_database" {
  name     = "terraform-db"
  instance = google_sql_database_instance.tf_db_instance.name

}

resource "google_sql_database_instance" "tf_db_instance" {
  name                = var.database_name
  database_version    = "MYSQL_8_0"
  region              = var.region
  deletion_protection = false
  settings {
    tier = "db-g1-small"
  }
}

resource "google_sql_user" "user" {
  name     = var.username
  instance = google_sql_database_instance.tf_db_instance.name
  password = var.user_password

}