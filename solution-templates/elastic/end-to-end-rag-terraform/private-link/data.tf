data "ec_deployment" "current" {
    id = var.deployment_id
}

data "aws_region" "current" {}
