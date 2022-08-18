resource "google_container_cluster" "cluster" {
  name                     = var.cluster_name
  location                 = var.zone
  network                  = google_compute_network.network.self_link
  subnetwork               = google_compute_subnetwork.subnet.self_link
  remove_default_node_pool = true
  initial_node_count       = 1

  cluster_autoscaling {
    enabled = true

    resource_limits {
      resource_type = "cpu"
      maximum       = var.autoscaling_cpu
    }

    resource_limits {
      resource_type = "memory"
      maximum       = var.autoscaling_memory
    }

    auto_provisioning_defaults {
      oauth_scopes = [
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/compute",
      ]
      image_type = "COS_CONTAINERD"
    }
  }
}

resource "google_container_node_pool" "node_pool" {
  name               = var.node_pool
  location           = var.zone
  cluster            = google_container_cluster.cluster.name
  initial_node_count = 1

  autoscaling {
    min_node_count = var.autoscaling_min_node_count
    max_node_count = var.autoscaling_max_node_count
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }

  node_config {
    machine_type = var.autoscaling_machine_type
    metadata = {
      disable-legacy-endpoints = true
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
    ]
  }
}
