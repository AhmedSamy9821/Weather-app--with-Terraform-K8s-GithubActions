#vpc module vars
variable "env" {
  type = string
}
variable "vpc_cider" {
    type = string
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for subnets"
  type        = list(string)
}


#eks module vars
variable "nodes_instance_types" {
  type = list(string)
}

variable "auto_scaling_config" {
  type = map(string)
}


#certficate module vars
variable "domain" {
  description = "domain name"
  type        = string
}

variable "sub_domain" {
  type        = string
}
