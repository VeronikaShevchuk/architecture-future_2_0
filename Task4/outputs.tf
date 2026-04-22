

output "vpc_network_id" {
  description = "ID of existing VPC network"
  value       = data.yandex_vpc_network.main.id
}

output "public_subnet_id" {
  description = "ID of public subnet"
  value       = yandex_vpc_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of private subnet"
  value       = yandex_vpc_subnet.private.id
}

output "fintech_server_ip" {
  description = "External IP of Fintech server"
  value       = yandex_compute_instance.fintech.network_interface[0].nat_ip_address
}

output "fintech_internal_ip" {
  description = "Internal IP of Fintech server"
  value       = yandex_compute_instance.fintech.network_interface[0].ip_address
}