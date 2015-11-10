// This stanza declares the provider we are declaring the AWS region we want
// to use. We declare this as a variable so we can access it other places in
// our Terraform configuration since many resources in AWS are region-specific.
variable "aws_region" {
  // ireland
  default = "eu-west-1"
}

// This stanza declares the default region for our provider. The other
// attributes such as access_key and secret_key will be read from the
// environment instead of committed to disk for security.
provider "aws" {
  region = "${var.aws_region}"
}

// This stanza declares a variable named "ami_map" that is a mapping of the
// Ubuntu 14.04 official hvm:ebs volumes to their region. This is used to
// demonstrate the power of multi-provider Terraform and also allows this
// stack to be adjusted geographically easily.
variable "aws_amis" {
  default = {
    eu-west-1       = "ami-cd0fd6be"
  }
}

// Create a Virtual Private Network (VPC) for our stack. Any resources we
// launch will live inside this VPC. We will not spend much detail here, since
// these are really Amazon-specific configurations and the beauty of Terraform
// is that you only have to configure them once and forget about it!
resource "aws_vpc" "terraform-stack" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags { Name = "terraform-stack" }
}

// The Internet Gateway is like the public router for your VPC. It provides
// internet to-from resources inside the VPC.
resource "aws_internet_gateway" "terraform-stack" {
  vpc_id = "${aws_vpc.terraform-stack.id}"
  tags { Name = "terraform-stack" }
}

// The subnet is the IP address range resources will occupy inside the VPC. Here
// we have choosen the 10.0.0.x subnet with a /24. You could choose any class C
// subnet.
resource "aws_subnet" "terraform-stack" {
  vpc_id = "${aws_vpc.terraform-stack.id}"
  cidr_block = "10.0.0.0/24"
  tags { Name = "terraform-stack" }

  map_public_ip_on_launch = true
}

// The Routing Table is the mapping of where traffic should go. Here we are
// telling AWS that all traffic from the local network should be forwarded to
// the Internet Gateway created above.
resource "aws_route_table" "terraform-stack" {
  vpc_id = "${aws_vpc.terraform-stack.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terraform-stack.id}"
  }

  tags { Name = "terraform-stack" }
}

// The Route Table Association binds our subnet and route together.
resource "aws_route_table_association" "terraform-stack" {
  subnet_id = "${aws_subnet.terraform-stack.id}"
  route_table_id = "${aws_route_table.terraform-stack.id}"
}

// The AWS Security Group is akin to a firewall. It specifies the inbound
// (ingress) and outbound (egress) networking rules. This particular security
// group is insecure but should be fixed! You should
// only open required ports in a production environment.
resource "aws_security_group" "terraform-stack" {
  name   = "terraform-stack-web"
  vpc_id = "${aws_vpc.terraform-stack.id}"

  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}