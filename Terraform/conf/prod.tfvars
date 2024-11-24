##########
#Infrastructure configuration
##########
env = "prod"
vpc_cider = "10.20.0.0/16"
subnet_cidrs = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24", "10.20.4.0/24"]
nodes_instance_types = ["t3.medium"]
auto_scaling_config = {
    desired_size = 3
    max_size     = 4
    min_size     = 2
}
domain = "ahmedsamy.link"
sub_domain = "weather.ahmedsamy.link"