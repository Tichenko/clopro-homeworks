resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.public_subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.public_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_family
}

data "template_file" "public_config" {
  template = "${file("cloud-config")}"

  vars = {
    user    = var.vm_user
    ssh_key = file(var.public_ssh_filepath)
  }
}

resource "yandex_compute_instance" "public-vm" {
  name = "public-vm"
  platform_id = var.platform_id
  zone = var.default_zone

  resources {
    cores         = var.public_vm_resources.cores
    memory        = var.public_vm_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.public_vm_resources.disk_size
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = var.vm_user
    private_key = file(var.ssh_filepath)
  }

  provisioner "file" {
    content = tls_private_key.ssh-key.private_key_pem
    destination = pathexpand(var.ssh_filepath)
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 ${pathexpand(var.ssh_filepath)}"
    ]
  }

  metadata = {
    user-data = data.template_file.public_config.rendered
  }
}
