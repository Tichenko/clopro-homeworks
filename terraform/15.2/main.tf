resource "yandex_vpc_network" "vpc" {
  name = local.vpc_name
}

resource "yandex_vpc_subnet" "subnet" {
  name           = local.subnet_name
  zone           = local.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.v4_cidr
}

resource "yandex_compute_instance_group" "ig" {
  name               = "instance-group"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.sa.id

  instance_template {
    platform_id = local.platform_id
    resources {
      memory = var.vm_resources.memory
      cores  = var.vm_resources.cores
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.vm_image_id
        size     = var.vm_resources.disk_size
      }
    }

    network_interface {
      network_id         = yandex_vpc_network.vpc.id
      subnet_ids         = ["${yandex_vpc_subnet.subnet.id}"]
      security_group_ids = ["${yandex_vpc_security_group.sg.id}"]
    }

    metadata = {
      user-data = data.template_file.cloud_config.rendered
    }
  }

  scale_policy {
    fixed_scale {
      size = var.vm_number
    }
  }

  allocation_policy {
    zones = [local.zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "Целевая группа Network Load Balancer"
  }
}

resource "yandex_lb_network_load_balancer" "lb" {
  name = "network-load-balancer"

  listener {
    name = "network-load-balancer-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.ig.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}
