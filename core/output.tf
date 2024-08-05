output "admin_password" {
  value     = random_password.password.result
  sensitive = true
}

output "admin_username" {
  value = "AzureAdmin"
}

output "private_ip_address" {
  value = "110.0.6.4"
}
