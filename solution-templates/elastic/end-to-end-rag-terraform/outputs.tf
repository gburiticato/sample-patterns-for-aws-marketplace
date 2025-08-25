output "endpoint_id" {
    value = module.private-link.endpoint_id
}

output "deployment_alias" {
    value = module.private-link.deployment_alias
}

output "elasticsearch_public_https_endpoint" {
    value = module.private-link.elasticsearch_public_https_endpoint
}

output "elasticsearch_private_https_endpoint" {
    value = module.private-link.elasticsearch_private_https_endpoint
}

output "bucket_name" {
    value = module.data-source.bucket_name
}

output "vectorizer_function_arn" {
    value = module.lambda-vectorizer.function_arn
}

output "agent_function_arn" {
    value = module.lambda-agent.function_arn
}

output "invoke_url" {
    value = module.api-gateway.invoke_url
}