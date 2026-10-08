output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "backend_instance_id" {
  value = module.compute.instance_id
}

output "backend_private_ip" {
  value = module.compute.instance_private_ip
}

output "secondary_ebs_volume_id" {
  value = module.compute.data_volume_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "asg_name" {
  value = module.compute.asg_name
}
