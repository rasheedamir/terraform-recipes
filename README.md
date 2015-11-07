# terraform-recipes

# Prerequisites

## 1. AWS Account

You must have an AWS account to use these instructions. Once you have one, create an IAM user called terraform and save the access and secret keys that are given to you. Then ensure that the terraform user has the "Amazon EC2 Full Access" policy template applied either a via group or role.

## 2. AWS CLI

Now install the awscli command line tools.

## 3. Terraform

1. Download Terraform

Download the appropriate package for your OS and architecture: Download Terraform (https://terraform.io/intro/getting-started/install.html)

2. Extract Terraform

Extract the package you just downloaded to the directory of your choice.

3. Add Path to Profile

The directory will contain a set of binary programs, such as terraform, terraform-provider-aws, etc. The final step is to make sure the directory you installed Terraform to is on the PATH. 

For example, if you use bash as your shell, you could add the path to your .bashrc or .bash_profile. Open your profile for editing:

## TERRAFORM
export TERRAFORM_HOME=/path/to/terraform/dir
export PATH=$TERRAFORM_HOME:$PATH

Save and exit.

Now all of your new bash sessions will be able to find the terraform command. If you want load the new PATH into your current session, type the following:

. .bashrc

Or restart the bash terminal.

4. Verify Terraform Installation

To verify that you have installed Terraform correctly, let's try and run it. In a terminal, run Terraform:

terraform

By executing terraform you should see help.

