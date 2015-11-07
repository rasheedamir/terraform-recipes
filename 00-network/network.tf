#####
# VPC
# A virtual private cloud (VPC) is a virtual network dedicated to your AWS account. 
# It is logically isolated from other virtual networks in the AWS cloud. You can 
# launch your AWS resources, such as Amazon EC2 instances, into your VPC. When you 
# create a VPC, you specify the set of IP addresses for the VPC in the form of a 
# Classless Inter-Domain Routing (CIDR) block (for example, 10.0.0.0/16)
#####

resource "aws_vpc" "terraform-stack" {
    cidr_block = "10.0.0.0/16"

    tags { Name = "terraform-stack-vpc" }
}

resource "aws_internet_gateway" "gateway" {
    vpc_id = "${aws_vpc.terraform-stack.id}"

    tags { Name = "terraform-stack-gateway" }
}

#####
# DMZ
#####

resource "aws_subnet" "dmz" {
    vpc_id = "${aws_vpc.terraform-stack.id}"
    cidr_block = "10.0.201.0/24"

    tags { Name = "terraform-stack-dmz" }
}

resource "aws_route_table" "dmz" {
    vpc_id = "${aws_vpc.terraform-stack.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gateway.id}"
    }

    tags { Name = "terraform-stack-dmz" }
}

resource "aws_route_table_association" "dmz" {
    subnet_id = "${aws_subnet.dmz.id}"
    route_table_id = "${aws_route_table.dmz.id}"

    tags { Name = "terraform-stack-dmz" }
}

########
# Public
########

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.terraform-stack.id}"
    cidr_block = "10.0.0.0/24"

    tags { Name = "terraform-stack-public" }
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.terraform-stack.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.bastion.id}"
    }

    tags { Name = "terraform-stack-public" }    
}

resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"

    tags { Name = "terraform-stack-public" }    
}

#########
# Private
#########

resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.terraform-stack.id}"
    cidr_block = "10.0.1.0/24"

    tags { Name = "terraform-stack-private" }
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.terraform-stack.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.bastion.id}"
    }

    tags { Name = "terraform-stack-private" }
}

resource "aws_route_table_association" "private" {
    subnet_id = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private.id}"

    tags { Name = "terraform-stack-private" }    
}

