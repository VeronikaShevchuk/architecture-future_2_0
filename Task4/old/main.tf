# ============================================
# TERRAFORM CONFIGURATION
# ============================================
terraform {
  required_version = ">= 1.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

# ============================================
# PROVIDER CONFIGURATION
# ============================================
provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

# ============================================
# DATA SOURCES
# ============================================
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# ============================================
# NETWORK RESOURCES
# ============================================
# Основная VPC сеть
resource "yandex_vpc_network" "main" {
  name        = var.network_name
  description = "Main VPC network for Будущее 2.0"
}

# Публичная подсеть
resource "yandex_vpc_subnet" "public" {
  name           = "${var.subnet_name}-public"
  zone           = var.zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.public_subnet_cidr]
}

# Приватная подсеть
resource "yandex_vpc_subnet" "private" {
  name           = "${var.subnet_name}-private"
  zone           = var.zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.private_subnet_cidr]
}

# ============================================
# SECURITY GROUPS
# ============================================

# Security Group для Fintech
resource "yandex_vpc_security_group" "fintech" {
  name        = "${var.security_group_name}-fintech"
  description = "Security group for Fintech domain"
  network_id  = yandex_vpc_network.main.id

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

# Security Group для Clinics
resource "yandex_vpc_security_group" "clinics" {
  name        = "${var.security_group_name}-clinics"
  description = "Security group for Clinics domain"
  network_id  = yandex_vpc_network.main.id

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

# Security Group для AI
resource "yandex_vpc_security_group" "ai" {
  name        = "${var.security_group_name}-ai"
  description = "Security group for AI domain"
  network_id  = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outgoing"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = -1
  }
}

# Security Group для BI Portal
resource "yandex_vpc_security_group" "bi_portal" {
  name        = "${var.security_group_name}-bi-portal"
  description = "Security group for BI Portal"
  network_id  = yandex_vpc_network.main.id

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

  ingress {
    protocol       = "TCP"
    description    = "HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outgoing"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = -1
  }
}

# ============================================
# ADDITIONAL DISKS
# ============================================
resource "yandex_compute_disk" "ai_data" {
  name = "ai-data-disk"
  type = "network-ssd"
  zone = var.zone
  size = var.ai_data_disk_size_gb
}

resource "yandex_compute_disk" "db_data" {
  name = "db-data-disk"
  type = "network-ssd"
  zone = var.zone
  size = var.db_data_disk_size_gb
}

# ============================================
# COMPUTE INSTANCES
# ============================================

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

# Clinics Server
resource "yandex_compute_instance" "clinics" {
  name        = "clinics-server"
  platform_id = "standard-v2"
  zone        = var.zone

  resources {
    cores  = var.clinics_vm_cores
    memory = var.clinics_vm_memory_gb
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.boot_disk_size_gb
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    security_group_ids = [yandex_vpc_security_group.clinics.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

# AI Server (приватный, без публичного IP)
resource "yandex_compute_instance" "ai" {
  name        = "ai-server"
  platform_id = "standard-v2"
  zone        = var.zone

  resources {
    cores  = var.ai_vm_cores
    memory = var.ai_vm_memory_gb
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.boot_disk_size_gb
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.ai_data.id
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    security_group_ids = [yandex_vpc_security_group.ai.id]
    nat                = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

# BI Portal Server
resource "yandex_compute_instance" "bi_portal" {
  name        = "bi-portal"
  platform_id = "standard-v2"
  zone        = var.zone

  resources {
    cores  = var.bi_vm_cores
    memory = var.bi_vm_memory_gb
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.boot_disk_size_gb
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    security_group_ids = [yandex_vpc_security_group.bi_portal.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

# Database Server (приватный)
resource "yandex_compute_instance" "bi_db" {
  name        = "bi-db"
  platform_id = "standard-v2"
  zone        = var.zone

  resources {
    cores  = var.db_vm_cores
    memory = var.db_vm_memory_gb
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.boot_disk_size_gb
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.db_data.id
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    security_group_ids = [yandex_vpc_security_group.ai.id]
    nat                = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}