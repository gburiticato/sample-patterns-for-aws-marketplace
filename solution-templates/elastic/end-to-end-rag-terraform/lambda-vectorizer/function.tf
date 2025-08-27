
data "aws_secretsmanager_secret" "elastic_credentials" {
  name = var.elasticsearch_connection_secret
}

data "aws_secretsmanager_secret_version" "elastic_credentials" {
  secret_id = data.aws_secretsmanager_secret.elastic_credentials.id
}

locals {
  elastic_credentials = jsondecode(data.aws_secretsmanager_secret_version.elastic_credentials.secret_string)
}

module "lambda_function_container_image" {
  source = "terraform-aws-modules/lambda/aws"
  function_name = "vectorizer"
  create_package = false
  image_uri    = "703671915761.dkr.ecr.us-east-1.amazonaws.com/marketplace/lambda-vectorizer:v1.0"
  package_type = "Image"
  timeout = 900

  environment_variables = {
    ELASTICSEARCH_ENDPOINT = var.elasticsearch_private_https_endpoint
    ELASTICSEARCH_USER = local.elastic_credentials.username
    ELASTICSEARCH_PASSWORD = local.elastic_credentials.password
  }

  vpc_subnet_ids = var.vpc_subnet_ids
  vpc_security_group_ids = var.vpc_security_group_ids
  attach_network_policy = true

  memory_size = 3008

  policies = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess", "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"]
  attach_policies = true
  number_of_policies = 2
}

resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = var.bucket_id
  lambda_function {
    lambda_function_arn = module.lambda_function_container_image.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_permission" "aws-lambda-trigger-permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function_container_image.lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_id}"
}



