# create an ec2 instance 
# region: Ireland

provider "aws" {
    # which region to use to create a resource/service
    region = "eu-west-1"
}

resource "aws_instance" "my_first_tf_instance" {
  # AMI: ubuntu 22.04 (ami-0c1c30571d2dae5c9)
  ami           = "ami-0c1c30571d2dae5c9"

  # instance_type = "t3.micro"
  instance_type = "t3.micro"

  # name tag: tech613-nowres-tf-first-vm
  tags = {
    Name = "tech613-nowres-tf-first-vm"
  }
}
