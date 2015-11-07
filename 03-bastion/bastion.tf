##
# Create a bastion host to allow SSH in to the network.
# Connections are only allowed from ${var.allowed_network}
# This box also acts as a NAT for the private network.
##

// What is NAT instance?
// Instances that you launch into a private subnet in a virtual private cloud (VPC) can't communicate with 
// the Internet. You can optionally use a network address translation (NAT) instance in a public subnet in 
// your VPC to enable instances in the private subnet to initiate outbound traffic to the Internet, but 
// prevent the instances from receiving inbound traffic initiated by someone on the Internet.
// Read more: http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_NAT_Instance.html

// This module creates an AWS keypair named "terraform-stack" using a pre-
// packaged SSH public key.
module "ssh_keys" {
  source = "../ssh_keys"
  name   = "terraform-stack"
}

resource "aws_security_group" "bastion" {
    name = "bastion"
    description = "Allow access from allowed_network and NAT internal traffic"
    vpc_id = "${aws_vpc.terraform-stack.id}"

    # SSH
    ingress = {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "${var.allowed_network}" ]
        self = false
    }

    # NAT
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = [
            "${aws_subnet.public.cidr_block}",
            "${aws_subnet.private.cidr_block}"
        ]
        self = false
    }

    tags { Name = "terraform-stack-bastion-security-group" }
}

resource "aws_security_group" "allow_bastion" {
    name = "allow_bastion_ssh"
    description = "Allow access from bastion host"
    vpc_id = "${aws_vpc.terraform-stack.id}"
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        security_groups = ["${aws_security_group.bastion.id}"]
        self = false
    }

    tags { Name = "terraform-stack-allow-bastion-ssh-security-group" }
}

resource "aws_instance" "bastion" {
    connection {
        user = "ec2-user"
        // Path to your private key to use to connect with the instance over ssh
        key_file = "${module.ssh_keys.private_key_path}"
    }

    // The ami is the AMI ID (like "ami-dfba9ea8"). Since AMIs are
    // region-specific, we can ask Terraform to look up the proper AMI ID from our
    // variables map in the aws.tf file.
    //
    // Notice that we access variables using the "var" keyword and a "dot"
    // notation. The "lookup" is built into Terraform and provides a way to look
    // up a value in a map.    
    ami = "${lookup(var.amazon_nat_amis, var.aws_region)}"

    // For demonstration purposes, we will launch the smallest instance.
    instance_type = "t2.micro"

    // key_name = "${var.key_name}"
    // We could hard-code the key_name to the string "terraform-stack" from
    // above, but Terraform allows us to reference our key pair resource block.
    // This also declares the AWS keypair as a dependency of the aws_instance
    // resource. Terraform builds a graph of all the resources and executes in
    // parallel where possible. If we just hard-coded the name, it is possible
    // Terraform would create the instance first, then create the key, which
    // would raise an error.
    key_name = "${module.ssh_keys.key_name}"

    security_groups = [
        "${aws_security_group.bastion.id}"
    ]
    
    // The subnet_id is the subnet this instance should run in. We can just
    // reference the subnet created earlier.
    subnet_id = "${aws_subnet.dmz.id}"
    
    associate_public_ip_address = true
    
    source_dest_check = false
    
    // user_data = "${file(\"files/bastion/cloud-init.txt\")}"

    tags = {
        Name = "terraform-stack-bastion"
        subnet = "dmz"
        role = "bastion"
        environment = "test"
    }
}

output "bastion" {
    value = "${aws_instance.bastion.public_ip}"
}