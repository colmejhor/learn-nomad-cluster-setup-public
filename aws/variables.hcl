# Packer variables (all are required)
region                    = "us-west-2"

# Terraform variables (all are required)
# ami                       = "ami-091664a5716b9fba0"
ami                       = "ami-0a2977df9fd651c5e"

# These variables will default to the values shown
# and do not need to be updated unless you want to
# change them
allowlist_ip            = "0.0.0.0/0"
name_prefix             = "nomad"
server_instance_type    = "t3.micro"
server_count            = "3"
client_instance_type    = "t3.medium"
client_count            = "3"