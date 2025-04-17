// Optional: Create manually a NAT IP address
resource "google_compute_address" "nat" {
  name    = "${local.vpc_name}-nat"
  region  = local.region
  project = local.project_id
  address_type = "EXTERNAL"
  // Use Google's global network uses PoP vs "STANDARD" which uses regular internet
  network_tier = "PREMIUM"

  depends_on = [ google_project_service.api ]
}

// Create a Router to advertise the NATGW to the private subnet
resource "google_compute_router" "router" {
  name = "${local.vpc_name}-nat-router"
  network = google_compute_network.vpc.name
}

// Create a NAT Gateway to allow the private subnet to reach the internet
resource "google_compute_router_nat" "nat" {
    name = "nat"
    router = google_compute_router.router.name
    region = local.region

    nat_ip_allocate_option = "MANUAL_ONLY"
    nat_ips = [ google_compute_address.nat.self_link ]
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

    // NOTE: By default, it can advertise all subnets including the public subnet
    // To restrict the NAT to only the private subnet, we need to set the following
    subnetwork {
        name = google_compute_subnetwork.private_subnet.self_link
        // Allow primary and secondary IP ranges to be NATed in the private subnet
        source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }

}