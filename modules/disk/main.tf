resource "google_compute_disk" "default" {
  name  = "${var.instance-name}-disk"
  type  = "pd-ssd"
  zone  = "${var.zone}"
  image = "${var.image}"
  labels = {
    environment = "mc-serv"
  }
  physical_block_size_bytes = 4096
}