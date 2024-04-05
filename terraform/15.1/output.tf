output "output" {
  value = {
    "public_ip" = "${yandex_compute_instance.public-vm.network_interface[0].nat_ip_address}"
    "private_ip"  = "${yandex_compute_instance.private-vm.network_interface[0].ip_address}"
  }
}
