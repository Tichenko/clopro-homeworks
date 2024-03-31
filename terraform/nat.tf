resource "yandex_vpc_subnet" "private" {
  name           = var.private_subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.private_cidr
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

resource "yandex_compute_instance" "nat" {
  name = "nat"
  platform_id = var.platform_id
  zone = var.default_zone

  resources {
    cores  = var.nat_resources.cores
    memory = var.nat_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_image_id
      size     = var.nat_resources.disk_size
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    nat        = true
    ip_address = var.public_nat_ip
  }
}

resource "yandex_vpc_route_table" "nat-instance-route" {
  name       = "nat-instance-route"
  network_id = yandex_vpc_network.vpc.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat.network_interface.0.ip_address
  }
}

resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "template_file" "private_config" {
  template = "${file("cloud-config")}"
  vars = {
    user    = var.vm_user
    ssh_key = tls_private_key.ssh-key.public_key_openssh
  }
}

resource "yandex_compute_instance" "private-vm" {
  name = "private-vm"
  platform_id = var.platform_id
  zone = var.default_zone

  resources {
    cores         = var.private_vm_resources.cores
    memory        = var.private_vm_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.private_vm_resources.disk_size
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
  }

  metadata = {
    user-data = data.template_file.private_config.rendered
  }
}
