variable "token" {
  type        = string
}

variable "cloud_id" {
  type        = string
}

variable "folder_id" {
  type        = string
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}

variable "platform_id" {
  type        = string
  default     = "standard-v1"
}

variable "vpc_name" {
  type        = string
  default     = "vpc"
}

variable "public_subnet_name" {
  type        = string
  default     = "public"
}

variable "private_subnet_name" {
  type        = string
  default     = "private"
}

variable "vm_family" {
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "vm_user" {
  type = string
  default = "vagrant"
}

variable "ssh_filepath" {
  type = string
  default = "~/.ssh/id_rsa"
}

variable "public_ssh_filepath" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "nat_image_id" {
  type      = string
  default   = "fd8oi1ha2tq6bh8tfco4"
}

variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
}

variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
}

variable "public_nat_ip" {
  type = string
  default = "192.168.10.254"
}

variable "nat_resources" {
  type = map(any)
  default = {
    cores         = 2
    memory        = 2
    disk_size     = 25
  }
}

variable "public_vm_resources" {
  type = map(any)
  default = {
    cores         = 2
    memory        = 2
    disk_size     = 25
  }
}

variable "private_vm_resources" {
  type = map(any)
  default = {
    cores         = 2
    memory        = 2
    disk_size     = 25
  }
}
