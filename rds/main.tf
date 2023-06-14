data "aws_availability_zones" "available" {}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "replication_region"
  region = var.replication_region
}

module "rds" {
  source = "git::https://github.com/defenseunicorns/terraform-aws-uds-rds?ref=v0.0.1-alpha"

  vpc_cidr = var.vpc_cidr
  vpc_id   = var.vpc_id

  db_name                    = "keycloak"
  username                   = "kcadmin"
  engine                     = "postgres"
  engine_version             = "14"
  family                     = "postgres14" # DB parameter group
  major_engine_version       = "14"         # DB option group
  instance_class             = "db.m7g.large"
  allocated_storage          = "10"
  max_allocated_storage      = 20
  identifier                 = "keycloak-postgres"

  providers = {
    aws.region2 = aws.replication_region
  }
}
