module "api_gateway" {
    source = "terraform-aws-modules/apigateway-v2/aws"
    name = "marketplace-elastic"
    protocol_type = "HTTP"
    cors_configuration = {
        allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
        allow_methods = ["*"]
        allow_origins = ["*"]
    }

    create_domain_name = false
    create_domain_records = false

    routes = {
        "POST /agent" = {
            integration = {
                uri = var.lambda_agent_function_arn
                payload_format_version = "2.0"
                timeout_milliseconds = 30000
            }
        }
    }
}



resource "aws_lambda_permission" "api_gateway" {
    statement_id  = "AllowExecutionFromAPIGateway"
    action        = "lambda:InvokeFunction"
    function_name = var.lambda_agent_function_name
    principal     = "apigateway.amazonaws.com"
    source_arn    = "${module.api_gateway.api_execution_arn}/*/*/*"
}


