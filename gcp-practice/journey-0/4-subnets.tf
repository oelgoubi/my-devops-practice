# Public Subnet
resource "google_compute_subnetwork" "public_subnet" {
  name          = "${local.vpc_name}-public"
  ip_cidr_range = "10.0.0.0/24"
  region        = local.region
  network       = google_compute_network.vpc.id
  // Enable Private Resources in the subnet to access Google APIs and Services using private IP
  private_ip_google_access = true
  stack_type = "IPV4_ONLY"
}

// Private Subnet
resource "google_compute_subnetwork" "private_subnet" {
  name          = "${local.vpc_name}-private"
  ip_cidr_range = "10.0.1.0/24"
  region        = local.region
  network       = google_compute_network.vpc.id
  private_ip_google_access = true
  stack_type = "IPV4_ONLY"


  // Optional but Recommended : Add Secondary IP ranges for GKE ( We don't need to create virtual IPs for GKE using calico or flannel for example)
  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = "172.16.0.0/16"
  }

  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = "172.20.0.0/18"
  }
}
// NOTE: Technically we can create a VM in private subnet with public IP and it can reach the internet
// To avoid this we need to use Org Policies to disable public IPs
// https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints#compute.googleapis.com


// Import private subnet 2 that i created manually
resource "google_compute_subnetwork" "private_subnet_2" {
  name          = "${local.vpc_name}-private2"
  ip_cidr_range = "10.0.2.0/24"
  region        = local.region
  network       = google_compute_network.vpc.id
  private_ip_google_access = true
  stack_type = "IPV4_ONLY"
}