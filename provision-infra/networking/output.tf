#networking/output.tf

output "vpc_id" {
  value = aws_vpc.mtc_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.mtc_rds_subnetgroup.*.name
}

output "db_security_group" {
  value = aws_security_group.mtc_sg["rds"].id
}

output "public_sg" {
  value = aws_security_group.mtc_sg["public"].*.id
}

output "private_subnets_a" {
  value = aws_subnet.mtc_private_subnet_AZ_a.*.id
}

output "private_subnets_c" {
  value = aws_subnet.mtc_private_subnet_AZ_c.*.id
}

output "public_subnets" {
  value = aws_subnet.mtc_public_subnet_AZ_c.*.id
}