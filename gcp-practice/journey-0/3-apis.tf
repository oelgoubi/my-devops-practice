# resource "google_project_service" "compute" {
#   service = "compute.googleapis.com"
#   disable_on_destroy = false
# }
# resource "google_project_service" "container" {
#   service = "container.googleapis.com"
#   disable_on_destroy = false
# }


# Enables the specified APIs for the Google Cloud project.
resource "google_project_service" "api" {
  # Convert the list of APIs to objects with a key and value
  for_each           = toset(local.apis)
  service            = each.key
  disable_on_destroy = false
}
