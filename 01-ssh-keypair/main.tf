// This module creates an AWS keypair named "terraform-stack" using a pre-
// packaged SSH public key. We will discuss modules in more
// depth later, but modules provide a way to include external resources (much
// like "dependencies" in traditional software engineering) with customizable
// attributes.
module "ssh_keys" {
  // This defines where the module lives. Modules can reside in source control
  // in remote repositories, or on local disk as shown here.
  source = "../ssh_keys"

  // This an input to the module. Modules define inputs as variables just like
  // templates define inputs as variables.
  name = "terraform-stack"
}

// Before we can use this module, we have to download it into Terraform's local
// repository. We can do this using the `terraform get` command.
//
//     $ terraform get 01-ssh-keypair
//
// Run this command now.

// If we run `terraform plan 01-ssh-keypair` right now, Terraform will error
// saying that we are missing credentials to connect to AWS. Fill them in using
// the environment variables:

// export AWS_ACCESS_KEY_ID="..."
// export AWS_SECRET_KEY="..."

// Next, run `terraform plan 01-ssh-keypair`. You will notice Terraform uses
// the "+" to denote a new resource being added. Terraform will similarly use a
// "-" to denote a resource that will be removed, and a "~" to indicate a
// resource that will have changes attributes.

// You may notice some additional resources in the plan output. These resources
// live in the `aws.tf` file and include some important AWS-specific setup
// information such as VPCs and Security Groups. You can safely ignore this for
// now as it is provider-specific.

// Run `terraform apply 01-ssh-keypair`. This operation should be quick
// since we are only creating one resource. You should see output very similar
// to the output of the `terraform plan 01-ssh-keypair`.

// If you open the Amazon console and look under EC2 -> Key Pairs, you will see
// a new keypair has been created named "terraform-stack". We can use this
// keypair to connect to new EC2 instances created on Amazon in the next parts.

// Finally, run `terraform plan 01-ssh-keypair` again. You will notice that the
// output indicates no resources are to change. To further illustrate the power
// of Terraform, run `terraform apply 01-ssh-keypair` again. Terraform will
// refresh the remote state (more on this later), and then 0 resources will be
// changed. Terraform is intelligent enough to maintain and manage state.

// Before going any further, let's do some critical thinking. What will happen
// if you delete this keypair from EC2 outside of Terraform (like via the
// web interface)? Will Terraform re-create it? Will Terraform throw an error?
// Will Terraform ignore it? Let's try that out and see!

// Go into the Amazon Key Pair page in the AWS Console and delete the key using
// the Web UI. Back on your local terminal, run `terraform plan 01-ssh-keypair`.
// Viola! Terraform has intelligently detected that the keypair was removed
// out-of-band and re-created it for us.

// What will happen if we rename this resource in Terraform? Suppose we want to
// add a better description to this key name, including the today's date.
// Update the `key_name` in this Terraform configuration to be
// "terraform-stack-<date>" and run `terraform plan 01-ssh-keypair`.
// Terraform will detect the rename and alter the resource automatically! We
// could apply these changes, but let's not do that. The rest of the modules in
// this series will assume the keypair is named "terraform-stack". You can
// delete the date from the keypair name and verify nothing has changed by
// running the `terraform plan 01-ssh-keypair` command again. If you
// accidentally ran `terraform apply 01-ssh-keypair`, do not worry - just
// change the name back and run `terraform apply 01-ssh-keypair` again.