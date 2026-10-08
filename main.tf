data "aws_availability_zones" "available" {
  state = "available"
}

module "network" {
  source = "./modules/network"

  name                 = local.name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source = "./modules/security"

  name   = local.name
  vpc_id = module.network.vpc_id
}

module "compute" {
  source = "./modules/compute"

  name                    = local.name
  instance_type           = var.instance_type
  private_subnet_id       = module.network.private_subnet_ids[0]
  private_subnet_ids      = module.network.private_subnet_ids
  instance_sg_id          = module.security.instance_sg_id
  target_group_arn        = module.alb.target_group_arn
  data_volume_size        = var.data_volume_size
  availability_zone       = module.network.private_subnet_azs[0]
  enable_asg              = var.enable_asg
  asg_min_size            = var.asg_min_size
  asg_desired_capacity    = var.asg_desired_capacity
  asg_max_size            = var.asg_max_size
}

module "alb" {
  source = "./modules/alb"

  name              = local.name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
}

module "backup" {
  source = "./modules/backup"

  name                     = local.name
  data_volume_id           = module.compute.data_volume_id
  snapshot_retention_count = var.snapshot_retention_count
}
