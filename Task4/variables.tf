variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = "ru-central1-a"
}

# ============================================
# NETWORK VARIABLES
# ============================================
variable "network_name" {
  description = "Name of VPC network"
  type        = string
  default     = "future20-network"
}

variable "subnet_name" {
  description = "Name prefix for subnets"
  type        = string
  default     = "future20-subnet"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "security_group_name" {
  description = "Name prefix for security groups"
  type        = string
  default     = "future20-sg"
}

# ============================================
# COMPUTE VARIABLES
# ============================================
variable "boot_disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
}

# Fintech
variable "fintech_vm_cores" {
  description = "Number of vCPU cores for Fintech server"
  type        = number
  default     = 2
}

variable "fintech_vm_memory_gb" {
  description = "Memory in GB for Fintech server"
  type        = number
  default     = 4
}

# SSH
variable "ssh_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}