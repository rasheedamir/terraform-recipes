// This is the same module block from 01-ssh-keypair. Terraform will know the
// old resource exists because of the state file it created. We will discuss
// that more later.
module "ssh_keys" {
  source = "../ssh_keys"
  name   = "terraform-stack"
}

// Next we are going to create a compute resource ("server") in EC2. There are
// a number of fields that Terraform accepts, but we are only going to use the
// required ones for now.
resource "aws_instance" "web" {
  // This tells Terraform to create one instance. This is the default value.
  count = 1

  // The ami is the AMI ID (like "ami-dfba9ea8"). Since AMIs are
  // region-specific, we can ask Terraform to look up the proper AMI ID from our
  // variables map in the aws.tf file.
  //
  // Notice that we access variables using the "var" keyword and a "dot"
  // notation. The "lookup" is built into Terraform and provides a way to look
  // up a value in a map.
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  // For demonstration purposes, we will launch the smallest instance.
  instance_type = "t2.micro"

  // We could hard-code the key_name to the string "terraform-tutorial" from
  // above, but Terraform allows us to reference our key pair resource block.
  // This also declares the AWS keypair as a dependency of the aws_instance
  // resource. Terraform builds a graph of all the resources and executes in
  // parallel where possible. If we just hard-coded the name, it is possible
  // Terraform would create the instance first, then create the key, which
  // would raise an error.
  key_name = "${module.ssh_keys.key_name}"

  // The subnet_id is the subnet this instance should run in. We can just
  // reference the subnet created by our aws.tf file.
  subnet_id = "${aws_subnet.terraform-tutorial.id}"

  // The vpc_security_group_ids specifies the security group(s) this instance
  // belongs to. We can reference the security group created in the aws.tf file.
  // This security group is "wide open" and allows all ingress and egress
  // traffic through.
  vpc_security_group_ids = ["${aws_security_group.terraform-tutorial.id}"]

  // Tags are arbitrary key-value pairs that will be displayed with the instance
  // in the EC2 console. "Name" is important since that is what will be
  // displayed in the console.
  tags { Name = "web-${count.index}" }
}

// If we run `terraform plan 02-single-instance`, Terraform will tell us it will
// create the single EC2 instance. You will notice some resources are marked as
// "<computed>", and some resources have been calculated. For example, the ami
// and key_name fields have been pre-computed, but there are other fields that
// Terraform does not know yet. For example, Terraform cannot know the IP
// address of the instance before it is created. Some fields are not populated
// until after the resource has been created.

// Once Terraform creates the instance, it does know the value of those fields.
// Run `terraform apply 02-single-instance`. This can take a few minutes. When
// the apply has finished, run `terraform show`. You will see all of the
// attributes Terraform saved during the instance creation including its
// IP addresses, tags, dns information, subnet, and more. You can look in the
// EC2 console and see that an instance was created and that instance is named
// "Tutorial".
