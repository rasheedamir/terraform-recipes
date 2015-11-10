// This is the same module block from 01-ssh-keypair. Terraform will know the
// old resource exists because of the state file it created. We will discuss
// that more later.
module "ssh_keys" {
  source = "../ssh_keys"
  name   = "terraform-stack"
}

// This is the same resource block from 02-single-instance.
resource "aws_instance" "gocd" {
  count = 1
  ami   = "${lookup(var.aws_coreos_amis, var.aws_region)}"

  instance_type = "t2.micro"
  key_name      = "${module.ssh_keys.key_name}"
  subnet_id     = "${aws_subnet.terraform-stack.id}"

  vpc_security_group_ids = ["${aws_security_group.terraform-stack.id}"]

  tags { Name = "gocd-${count.index}" }

  // This tells Terraform how to connect to the instance to provision. Terraform
  // uses "sane defaults", but we are utilizing a custom SSH key, so we need to
  // specify the connection information here.
  connection {
    user     = "ubuntu"
    key_file = "${module.ssh_keys.private_key_path}"
  }

  // The first remote-exec provisioner is used to wait for cloud-init (which is
  // an AWS-EC2-specific thing) to finish. Without this line, Terraform may try
  // to provision the instance before apt has updated all its sources. This is
  // an implementation detail of an operating system and the way it runs on the
  // cloud platform; this is not a Terraform bug.
  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done"
    ]
  }

  // Use the remote-exec provisioner to execute commands to install a simple
  // web server.
  // provisioner "remote-exec" {
  //  inline = [
  //    "sudo apt-get update",
  //    "sudo apt-get -y -f install apache2",
  //  ]
  // }
}

// This tells terrafrom to export (or output) the AWS instance's public DNS. We
// will use this to access the instance from the public internet.
output "address" { value = "${aws_instance.gocd.public_dns}" }

// If you run `terraform apply 03-provision-instance`, nothing will happen. This
// is because Terraform has already created the instance and Terraform is unable
// to know which provisioners have executed or whether their prior execution was
// succesfully. Thankfully Terraform allows us to manually say "this resource
// needs to be recreated next run" using the taint command.

// Run `terraform taint aws_instance.web` and then run
// `terraform apply 03-provision-instance`. This will destroy the old instance
// and create a new one. When the new instance is created, Terraform will run
// the provisioner script.

// The output will contain the address of the instance at the end of the apply.
// Copy-paste this address into your favorite web browser. You should see the
// apache2 default page. Great!