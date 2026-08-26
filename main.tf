module "network" {
  source = "./modules/network"

  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  admin_cidr          = var.admin_cidr
}

module "compute" {
  source = "./modules/compute"

  project_name      = var.project_name
  subnet_id         = module.network.public_subnet_id
  security_group_id = module.network.app_security_group_id
  instance_type     = var.instance_type
}
