##########
#Infrastructure configuration
##########
env = "dev"
vpc_cider = "10.10.0.0/16"
subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24", "10.10.4.0/24"]
nodes_instance_types = ["t3.medium"]
auto_scaling_config = {
    desired_size = 1
    max_size     = 2
    min_size     = 1
}
domain = "ahmedsamy.link"
sub_domain = "dev.weather.ahmedsamy.link"
