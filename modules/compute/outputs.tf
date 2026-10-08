output "instance_id" { value = aws_instance.backend.id }
output "instance_private_ip" { value = aws_instance.backend.private_ip }
output "data_volume_id" { value = aws_ebs_volume.data.id }
output "asg_name" { value = try(aws_autoscaling_group.this[0].name, null) }
