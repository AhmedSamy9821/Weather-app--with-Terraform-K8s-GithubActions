##############
#vpc module creates vpc and 4 public subnets for eks cluster
############## 
module "vpc" {
  source = "../modules/vpc"
  env = var.env
  vpc_cider = var.vpc_cider
  subnet_cidrs = var.subnet_cidrs
}

##############
#eks_cluster module creates eks cluster and node group
##############
module "eks_cluster" {
  source = "../modules/eks"
  env = var.env
  subnet_ids = module.vpc.subnet_ids
  nodes_instance_types = var.nodes_instance_types
  auto_scaling_config = var.auto_scaling_config
  
}


###############
#certificate module creates certificate for the domain
###############
module "certificate" {
  source = "../modules/domain_Certificate"
  env = var.env
  sub_domain = var.sub_domain
  domain = var.domain
}