// variable "access_key" {
//     description = "AWS access key."
// }

// variable "secret_key" {
//     description = "AWS secret key."
// }

variable "allowed_network" {
    description = "The CIDR of network that is allowed to access the bastion host"
}

// This stanza declares the provider we are declaring the AWS region we want
// to use. We declare this as a variable so we can access it other places in
// our Terraform configuration since many resources in AWS are region-specific.
variable "aws_region" {
  // ireland
  default = "eu-west-1"
}

// variable "region" {
//     description = "The AWS region to create things in."
//     default = "us-west-2"
// }

// variable "key_name" {
//    description = "Name of the keypair to use in EC2."
//    default = "terraform-stack"
// }

// variable "key_path" {
//     descriptoin = "Path to your private key."
//     default = "~/.ssh/id_rsa"
// }

variable "amazon_linux_amis" {
    description = "Amazon Linux AMIs"
    default = {
        us-west-2 = "ami-b5a7ea85"
    }
}

# CoreOS Stable Channel
variable "amazon_coreos_amis" {
    default = {
        ap-northeast-1 = "ami-decfc0df"
        sa-east-1 =  "ami-cb04b4d6"
        ap-southeast-2 =  "ami-d1e981eb"
        ap-southeast-1 =  "ami-83406fd1"
        us-east-1 = "ami-18205670"
        us-west-2 = "ami-4dd4857d"
        us-west-1 = "ami-17fae852"
        eu-west-1 = "ami-783a840f"
        eu-central-1 = "ami-487d4d55"
    }
}

variable "amazon_nat_amis" {
    description = "Amazon Linux NAT AMIs"
    default = {
        us-west-2 = "ami-bb69128b"
        eu-west-1 = "ami-3760b040"
    }
}

variable "centos7_amis" {
    description = "CentOS 7 AMIs"
    default = {
        us-east-1 = "ami-96a818fe"
        us-west-2 = "ami-c7d092f7"
        us-west-1 = "ami-6bcfc42e"
        eu-west-1 =  "ami-e4ff5c93"
        ap-southeast-1 = "ami-aea582fc"
        ap-southeast-2 = "ami-bd523087"
        ap-northeast-1 = "ami-89634988"
        sa-east-1 = "ami-bf9520a2"
    }
}