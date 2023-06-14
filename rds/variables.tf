variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "replication_region" {
  description = "AWS region that will host the backups"
  type        = string
  default     = ""
}

variable "secondary_cidr_blocks" {
  description = "Secondary CIDR blocks"
  type        = list(string)
  default     = []
}
