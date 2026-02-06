ports               = [22, 80, 443, 3306, 27017, 1080]
instance_type       = "t3.micro"
image_name          = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
owner               = "099720109477"
virtualization-type = "hvm"
root_device_type    = "ebs"
access_key    = "your_access_key_here"
secret_key    = "your_secret_key_here"