output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "bastion-allow-ssh" {
  value = aws_security_group.bastion-allow-ssh.id
}


output "my_vpc" {
  value = aws_vpc.main.id
}