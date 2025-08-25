output "endpoint_id" {
    value = aws_vpc_endpoint.elastic-endpoint.id
}

output "deployment_alias" {
    value = data.ec_deployment.current.alias
}

output "elasticsearch_public_https_endpoint" {
    value = data.ec_deployment.current.elasticsearch[0].https_endpoint
}

output "elasticsearch_private_https_endpoint" {
    value = "https://${data.ec_deployment.current.alias}.es.${local.service_names[data.aws_region.current.region].hosted_zone}"
}