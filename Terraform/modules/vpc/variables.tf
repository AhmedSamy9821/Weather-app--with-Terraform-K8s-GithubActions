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
  default = [ "eu-north-1a","eu-north-1b ","eu-north-1c" ]
}