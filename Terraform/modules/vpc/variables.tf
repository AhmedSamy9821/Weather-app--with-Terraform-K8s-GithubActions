variable "env" {
  type = string
}

variable "vpc_cider" {
    type = string
    default = "10.10.0.0/16"
  
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for subnets"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24", "10.10.4.0/24"]
}

variable "availability_zones" {
  type = list(string)
  default = [ "eun1-az1"," eun1-az2 "," eun1-az3" ]
}