# Terraform Features

## Infrastructure Updates

This is the absolute killer feature of Terraform. Terraform has a separate planning and execution phase. The planning phase shows which resources will be created, modified and destroyed. It gives you complete control of how your changes will affect the existing environment, which is quite crucial. This was one of the main reasons why we went ahead with Terraform.

## Roll back Mechanism

If a resource is successfully created but fails during provision, Terraform will error and mark the resource as “tainted.” In the next execution plan, Terraform will remove the tainted resources and will attempt to provision again. This is because it follows the execution plan very strictly. 

## State management

State management is currently the “chink in the armor” for Terraform and I would like to elaborate on this. Terraform manages state via a json file. This file serves as the source of truth about what the actual environment contains. However, the problem is the inability of terraform to uniquely identify resources that it creates. 

This is how terraform works – It maintains a local state file where it keeps track of any CRUD operations that it performs. Whenever terraform is invoked to perform any operations, it compares –
a) resources defined in the template files by the developer.
b) and the local state file.
Now take the state file away and everything will be lost, it will again recreate all the resources that are defined in the .tf files. This means the state file needs to be shared between developers and that can lead to chaos!

# Modules as Libraries

A module defines its contract in two ways:

Here are the inputs I can take
Here are the outputs I give you

Once you start moving some of your Terraform code into modules, you will be forced to create this contract for yourself.

