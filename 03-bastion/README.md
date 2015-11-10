# How to find CDIR of my network?

```
ip r
```

# What is bastion host?

You will now need to create a file in this directory called ```terraform.tfvars``` with contents like this:

```
access_key = "YOUR ACCESS KEY"
secret_key = "YOUR SECRET KEY"
allowed_network = "YOUR NETWORK CIDR"
```

Populate the above values with your AWS IAM keys you saved earlier and the CIDR of the network you want to allow access to the bastion host.

terraform get 03-bastion
terraform apply 03-bastion

Once you have an environment running you can SSH to the bastion server as follows. The -A argument enables agent forwarding which will allow you to SSH from the bastion host to other hosts without a password.

```sh
$ ssh -A ec2-user@$(terraform output bastion)
ssh -i /path/to/id_rsa ec2-user@$(terraform output bastion)
```
