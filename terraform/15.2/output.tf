output "ip" {
  value = "${yandex_lb_network_load_balancer.lb.listener.*.external_address_spec[0].*.address[0]}"
}
