# basic

# Resources

this recipe will include following resources:

1. one ec2 instance running gocd on docker containers
2. one ec2 instance running docker registry e.g. 
https://github.com/rasheedamir/aws-terraform/tree/master/modules/dockerhub
3. one ebs backed volume that is mounted (attached) to the docker registry ec2 instance
4. one bastion server (based on linux ami)
5. deploy parameterized generic gocd job (baker or AMINATOR) that can take in dockerized apps; and build azure images

(there shld be possibility to run all of the stuff on one ec2 instance to save cost)

## AMINATOR OR BAKER

Aminator is a tool (or a job) for creating EBS AMIs. This tool currently works for CoreOS images and is intended to run on an EC2 instance.

It creates a custom AMI from just:

1. A base ami ID (coreos ami)
2. A docker compose file which installs your application.

This is useful for many AWS workflows, particularly ones that take advantage of auto-scaling groups.