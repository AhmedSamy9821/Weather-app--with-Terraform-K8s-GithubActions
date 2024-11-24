variable "env" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "nodes_instance_types" {
  type = list(string)
}

variable "auto_scaling_config" {
  type = map(string)
  
}