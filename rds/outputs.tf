output "keycloak_db_instance_endpoint" {
  description = "The connection endpoint"
  value       = try(module.rds.db_instance_endpoint, null)
  sensitive   = true
}

output "keycloak_db_instance_name" {
  description = "The database name"
  value       = try(module.rds.db_instance_name, null)
  sensitive   = true
}

output "keycloak_db_instance_username" {
  description = "The master username for the database"
  value       = try(module.rds.db_instance_username, null)
  sensitive   = true
}

output "keycloak_db_instance_password" {
  description = "The master password for the database"
  value       = try(module.rds.db_instance_password, null)
  sensitive   = true
}
