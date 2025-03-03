provider "aws" {
  region = "us-east-2"
  profile = "default"

}
 resource "aws_instance" "K8s" {
   count = "3"
   key_name = "17-key"
   tags = {
    Name = "17-tf-k8-${count.index+5}"
    owner = "Ramaseshan Rangarajan"
   }
    launch_template {
        id= "lt-03d07fead2a427b74"
        version = "3"
    }
 
 }


 