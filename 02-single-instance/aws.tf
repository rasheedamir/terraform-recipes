// This stanza declares the provider we are declaring the AWS region we want
// to use. We declare this as a variable so we can access it other places in
// our Terraform configuration since many resources in AWS are region-specific.
variable "aws_region" {
  default = "us-east-1"
}

// This stanza declares the default region for our provider. The other
// attributes such as access_key and secret_key will be read from the
// environment instead of committed to disk for security.
provider "aws" {
  region = "${var.aws_region}"
}

// This stanza declares a variable named "ami_map" that is a mapping of the
// Ubuntu 14.10 official hvm:ebs volumes to their region. This is used to
// demonstrate the power of multi-provider Terraform and also allows this
// tutorial to be adjusted geographically easily.
variable "aws_amis" {
  default = {
    ap-northeast-1  = "ami-48c27448"
    ap-southeast-1  = "ami-86e3e1d4"
    ap-southeast-2  = "ami-21eea81b"
    cn-north-1      = "ami-9871eca1"
    eu-central-1    = "ami-88333695"
    eu-west-1       = "ami-c8a5eebf"
    sa-east-1       = "ami-1319960e"
    us-east-1       = "ami-d96cb0b2"
    us-gov-west-1   = "ami-25fc9c06"
    us-west-1       = "ami-6988752d"
    us-west-2       = "ami-d9353ae9"
  }
}

// Create a Virtual Private Network (VPC) for our tutorial. Any resources we
// launch will live inside this VPC. We will not spend much detail here, since
// these are really Amazon-specific configurations and the beauty of Terraform
// is that you only have to configure them once and forget about it!
resource "aws_vpc" "terraform-tutorial" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags { Name = "terraform-tutorial" }
}

// The Internet Gateway is like the public router for your VPC. It provides
// internet to-from resources inside the VPC.
resource "aws_internet_gateway" "terraform-tutorial" {
  vpc_id = "${aws_vpc.terraform-tutorial.id}"
  tags { Name = "terraform-tutorial" }
}

// The subnet is the IP address range resources will occupy inside the VPC. Here
// we have choosen the 10.0.0.x subnet with a /24. You could choose any class C
// subnet.
resource "aws_subnet" "terraform-tutorial" {
  vpc_id = "${aws_vpc.terraform-tutorial.id}"
  cidr_block = "10.0.0.0/24"
  tags { Name = "terraform-tutorial" }

  map_public_ip_on_launch = true
}

// The Routing Table is the mapping of where traffic should go. Here we are
// telling AWS that all traffic from the local network should be forwarded to
// the Internet Gateway created above.
resource "aws_route_table" "terraform-tutorial" {
  vpc_id = "${aws_vpc.terraform-tutorial.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terraform-tutorial.id}"
  }

  tags { Name = "terraform-tutorial" }
}

// The Route Table Association binds our subnet and route together.
resource "aws_route_table_association" "terraform-tutorial" {
  subnet_id = "${aws_subnet.terraform-tutorial.id}"
  route_table_id = "${aws_route_table.terraform-tutorial.id}"
}

// The AWS Security Group is akin to a firewall. It specifies the inbound
// (ingress) and outbound (egress) networking rules. This particular security
// group is intentionally insecure for the purposes of this tutorial. You should
// only open required ports in a production environment.
resource "aws_security_group" "terraform-tutorial" {
  name   = "terraform-tutorial-web"
  vpc_id = "${aws_vpc.terraform-tutorial.id}"

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
