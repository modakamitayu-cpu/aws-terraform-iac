output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_ids" { value = aws_subnet.public[*].id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }
output "private_subnet_azs" { value = aws_subnet.private[*].availability_zone }
output "nat_gateway_id" { value = aws_nat_gateway.this.id }
