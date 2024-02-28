## VPC variables  ##

variable "cidr_blocks" {
  default     = ["10.2.0.0/16","10.2.1.0/24","10.2.11.0/24","10.2.12.0/24"]
  type        = list(string)
  description = "CIDR block for the VPC,public subnet 1,private subnet 1,private subnet 2"
}

variable "availablity_zones" {
  default     = ["ap-south-1a","ap-south-1b"]
  type        = list(string)
  description = "Availablity zones for subnets"
}

variable "elastic-private-ip-range" {
  default     = "10.2.11.5"
  type        = string
  description = "Elastic private IP address range for Nat Gateway"
}

variable "destination-cidr-block" {
  default     = "0.0.0.0/0"
  type        = string
  description = "Destination CIDR Block for Nat and Internet Gateway"
}