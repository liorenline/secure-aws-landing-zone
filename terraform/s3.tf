data "aws_caller_identity" "current" {}
resource "aws_s3_bucket" "secure_aws" {
  bucket = "secure-aws-${data.aws_caller_identity.current.account_id}"
}