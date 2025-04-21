variable "AWS_REGION" {
  default = "us-west-1"
}

variable "cidr_block" {
    description = "Must use 16 block"
}

variable "private_subnet" {
    description = "Privet subnet"
}

variable "public_subnet" {
    description = "Public subnet"
}

variable "azs" {
    description = "Availability Zones"
}

variable "PRIVATE_KEY" {
  default = "mykey"
}

variable "PUBLIC_KEY" {
  default = "mykey.pub"
}