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

variable "nat_gateway_name" {
  description = "Name of NAT gateway"
  type        = string
  default     = "future20-nat-gateway"
}

# ============================================
# COMPUTE VARIABLES (по доменам)
# ============================================
variable "boot_disk_size_gb" {
  description = "Boot disk size in GB for all VMs"
  type        = number
  default     = 20
}

# Fintech domain
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

# Clinics domain
variable "clinics_vm_cores" {
  description = "Number of vCPU cores for Clinics server"
  type        = number
  default     = 2
}

variable "clinics_vm_memory_gb" {
  description = "Memory in GB for Clinics server"
  type        = number
  default     = 4
}

# AI domain
variable "ai_vm_cores" {
  description = "Number of vCPU cores for AI server"
  type        = number
  default     = 4
}

variable "ai_vm_memory_gb" {
  description = "Memory in GB for AI server"
  type        = number
  default     = 8
}

variable "ai_data_disk_size_gb" {
  description = "Data disk size for AI models in GB"
  type        = number
  default     = 100
}

# BI Portal
variable "bi_vm_cores" {
  description = "Number of vCPU cores for BI Portal"
  type        = number
  default     = 2
}

variable "bi_vm_memory_gb" {
  description = "Memory in GB for BI Portal"
  type        = number
  default     = 4
}

# Database
variable "db_vm_cores" {
  description = "Number of vCPU cores for database server"
  type        = number
  default     = 4
}

variable "db_vm_memory_gb" {
  description = "Memory in GB for database server"
  type        = number
  default     = 8
}

variable "db_data_disk_size_gb" {
  description = "Data disk size for database in GB"
  type        = number
  default     = 100
}

variable "db_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}

# SSH
variable "ssh_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
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