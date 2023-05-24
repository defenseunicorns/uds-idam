data "aws_availability_zones" "available" {}

provider "aws" {
  region = var.region
}

module "rds" {
  source = "git::https://github.com/defenseunicorns/uds-iac-aws-rds?ref=b04d4b2b3c5a8985690797fd63f7eaf4f6ffec08"

  vpc_cidr = var.vpc_cidr
  vpc_id   = var.vpc_id

  database_subnet_group_name = module.vpc.database_subnet_group_name
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
}
