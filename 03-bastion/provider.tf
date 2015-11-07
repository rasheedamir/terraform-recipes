// This stanza declares the default region for our provider. The other
// attributes such as access_key and secret_key will be read from the
// environment instead of committed to disk for security.
provider "aws" {
  region = "${var.aws_region}"
}