data "template_file" "cloud_config" {
  template = file("cloud-config.yaml")
  vars = {
    user    = var.vm_user
    ssh_key = file(var.public_ssh_filepath)
    url     = "https://storage.yandexcloud.net/${local.bucket_name}/${local.picture_name}"
  }
}