resource "google_compute_network" "vpc" {
  name         = local.vpc_name
  project      = local.project_id
  routing_mode = "REGIONAL"

  auto_create_subnetworks         = false
  delete_default_routes_on_create = true


  depends_on = [google_project_service.api]
}

// Create a Route outbound traffic to the internet via the predefined default IGW of GCP
resource "google_compute_route" "igw_route" {
  name             = "${local.vpc_name}-igw-route"
  network          = google_compute_network.vpc.name
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
}

// TODO: Best Practice : Disable public IPs using Org Policies 