provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "./modules/vpc"
}

module "security_group" {
  source = "./modules/security-group"
  vpc_id = module.vpc.main_vpc_id
}

module "target_group" {
  source      = "./modules/target-group"
  main_vpc_id = module.vpc.main_vpc_id
}

module "app_load_balancer" {
  source           = "./modules/alb"
  security_group   = [module.security_group.security_group_id]
  subnets          = module.vpc.main_vpc_subnets
  target_group_arn = module.target_group.main_target_group_arn
}

module "elastic_container_service" {
  source           = "./modules/ecs"
  security_groups  = [module.security_group.security_group_id]
  subnets          = module.vpc.main_vpc_subnets
  target_group_arn = module.target_group.main_target_group_arn
  listener_rule    = module.app_load_balancer.main_listener_rule_id
}

output "app_load_balancer_dns_name" {
  value = module.app_load_balancer.app_load_balancer_dns_name
}