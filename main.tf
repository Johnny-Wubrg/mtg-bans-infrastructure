terraform {
  cloud {
    organization = "Quangdao"
    workspaces {
      name = "mtg-bans"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

locals {
  db_name = "mtg-bans"
  connection_string = "Host=${module.mtg_bans_rds.hostname};Database=${local.db_name};Username=${var.db_username};Password=${var.db_password};Include Error Detail=true"
}

data "tfe_outputs" "core" {
  organization = "Quangdao"
  workspace    = "core_aws"
}

module "mtg_bans_alb" {
  source  = "app.terraform.io/Quangdao/alb-listener/aws"
  version = "0.0.2"

  quinfrastructure = data.tfe_outputs.core.values
  name             = "mtg-bans"
}


module "mtg_bans_rds" {
  source = "./components/database"

  vpc_id = data.tfe_outputs.core.values.vpc_id

  username  = var.db_username
  password  = var.db_password
  whitelist = var.db_whitelist
}

module "mtg_bans_ecr" {
  source = "./components/ecr"
}

module "mtg_bans_api" {
  source = "./components/api"
}
