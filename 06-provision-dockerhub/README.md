# docker hub or docker registry

https://docs.docker.com/registry/deploying/

1. dockerhub.<projectname>.com
2. tls enabled registry
3. enable native basic auth
4. use docker compose to run it...
5. s3 bucket for storage (https://docs.docker.com/registry/storage-drivers/s3/) -- it shld automatically create the access keys and the bucket --> ideally should be using separates modules for creating keys and s3 bucket... 
4. could be run initially on a micro instance? how will it work in case of upgrade?
5. can anyone access and push/pull from this dockerhub? offcourse not but those who can how will they access it? e.g. I would like to access from my machine? the CI machine will access it;

input variables:

1. domain url (i.e. dockerhub.<projectname>.com)
2. root certificate path
3. list of usernames & passwords for basic authentication