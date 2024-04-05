variable "token" {
  type = string
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "service_acc_name" {
  type = string
  default = "sa1"
}

variable "vm_user" {
  type    = string
  default = "vagrant"
}

variable "bucket_max_size" {
  type = number
  default = 10485760
}

variable "vm_number" {
  type = number
  default = 2
}

variable "picture_path" {
  type = string
  default = "./static/picture.jpg"
}

variable "public_ssh_filepath" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "vm_image_id" {
  type    = string
  default = "fd827b91d99psvq5fjit"
}

variable "v4_cidr" {
  type    = list(string)
  default = ["192.168.10.0/24"]
}

variable "vm_resources" {
  type = map(any)
  default = {
    cores     = 2
    memory    = 4
    disk_size = 50
  }
}
