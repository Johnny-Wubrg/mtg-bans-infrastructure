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

module "mtg_bans_network" {
  source = "./components/network"
}

module "mtg_bans_rds" {
  source = "./components/database"

  vpc_id = module.mtg_bans_network.vpc_id

  username     = var.db_username
  password     = var.db_password
  whitelist    = var.db_whitelist
  subnet_group = module.mtg_bans_network.subnet_group
}
