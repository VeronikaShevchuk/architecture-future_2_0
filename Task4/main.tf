terraform {
  required_version = ">= 1.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# Используем существующую сеть (не создаём новую)
data "yandex_vpc_network" "main" {
  name = var.network_name
}

# Публичная подсеть
resource "yandex_vpc_subnet" "public" {
  name           = "${var.subnet_name}-public"
  zone           = var.zone
  network_id     = data.yandex_vpc_network.main.id
  v4_cidr_blocks = [var.public_subnet_cidr]
}

# Приватная подсеть
resource "yandex_vpc_subnet" "private" {
  name           = "${var.subnet_name}-private"
  zone           = var.zone
  network_id     = data.yandex_vpc_network.main.id
  v4_cidr_blocks = [var.private_subnet_cidr]
}

# Security Groups
resource "yandex_vpc_security_group" "fintech" {
  name        = "${var.security_group_name}-fintech"
  description = "Security group for Fintech domain"
  network_id  = data.yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outgoing"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = -1
  }
}

# Fintech Server
resource "yandex_compute_instance" "fintech" {
  name        = "fintech-server"
  platform_id = "standard-v2"
  zone        = var.zone

  resources {
    cores  = var.fintech_vm_cores
    memory = var.fintech_vm_memory_gb
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.boot_disk_size_gb
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    security_group_ids = [yandex_vpc_security_group.fintech.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}