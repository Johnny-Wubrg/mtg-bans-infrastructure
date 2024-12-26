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
    
    namecheap = {
      source = "namecheap/namecheap"
      version = ">= 2.0.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

provider "namecheap" {
}

locals {
  db_name           = "mtg-bans"
  connection_string = "Host=${module.mtg_bans_rds.hostname};Database=${local.db_name};Username=${var.db_username};Password=${var.db_password};Include Error Detail=true"
}

data "tfe_outputs" "core" {
  organization = "Quangdao"
  workspace    = "core_aws"
}

module "mtg_bans_alb" {
  source  = "app.terraform.io/Quangdao/alb-listener/aws"
  version = "0.0.3"

  quinfrastructure  = data.tfe_outputs.core.values
  name              = "mtg-bans"
  health_check_path = "/health"
}

module "mtg_bans_logging" {
  source      = "./components/logging"
  environment = var.environment
}

module "mtg_bans_rds" {
  source = "./components/database"

  vpc_id = data.tfe_outputs.core.values.vpc_id

  username                  = var.db_username
  password                  = var.db_password
  whitelist_ips             = var.db_whitelist
  whitelist_security_groups = [module.mtg_bans_api.api_security_group]
}

module "mtg_bans_ecr" {
  source = "./components/ecr"
}

module "mtg_bans_api" {
  source = "./components/api"

  environment          = var.environment
  image_version        = var.image_version
  alb_security_group   = data.tfe_outputs.core.values.alb_security_group
  alb_target_group_arn = module.mtg_bans_alb.tg_arn
  subnets              = data.tfe_outputs.core.values.vpc_subnets
  connection_string    = local.connection_string
  repository_url       = module.mtg_bans_ecr.url
  api_key              = var.api_key
  log_group            = module.mtg_bans_logging.log_group

  depends_on = [module.mtg_bans_alb]
}

module "mtg_bans_dns" {
  source = "./components/dns"

  domain       = var.app_domain
  alb_zone_id  = data.tfe_outputs.core.values.alb_zone_id
  alb_dns_name = data.tfe_outputs.core.values.alb_dns_name
}
