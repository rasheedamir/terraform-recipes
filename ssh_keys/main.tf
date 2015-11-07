// This module defines a variable named "name". We will discuss modules more
// later, but this is a customizable attribute of the module
variable "name" {}

// This uploads our local keypair to AWS so we can access the instance(s). This
// repo includes a pre-packaged SSH key, so you do not need to worry about
// using your own local keys if you have them.
resource "aws_key_pair" "mod" {
  // This is the name of the keypair. This will show up in the Amazon console
  // and API output as this "key" (since ssh-rsa AAA... is not descriptive).
  key_name = "${var.name}"

  // We could hard-code a public key here, as shown below:
  // public_key = "ssh-rsa AAAAB3..."
  //
  // Instead we are going to leverage Terraform's ability to read a file from
  // your local machine using the `file` attribute.
  public_key = "${file("${path.module}/terraform-stack.pub")}"
}

// These are outputs from the module. They are available as attributes when
// we reference the module as a variable.
output "key_name"         { value = "${aws_key_pair.mod.key_name}" }
output "private_key_path" { value = "${path.module}/${var.name}.pem" }
output "public_key_path"  { value = "${path.module}/${var.name}.pub" }