resource "google_compute_firewall" "ssh" {
    name = "${var.instance-name}-ssh"
    network = "${var.network}"
    
    allow {
        protocol = "tcp"
        ports    = ["22"]
    }

}

resource "google_compute_firewall" "java" {
    count = "${var.java}"

    name = "${var.instance-name}-minecraft"
    network = "${var.network}"

    allow {
        protocol = "tcp"
        ports = ["25565"]
    }

    source_tags = ["minecraft"]
}

resource "google_compute_firewall" "bedrock" {
    count = "${var.bedrock}"

    name = "${var.instance-name}-minecraft"
    network = "${var.network}"

    allow {
        protocol = "udp"
        ports = ["19132"]
    }

    source_tags = ["minecraft"]
}