resource "ec_deployment_traffic_filter" "current" {
    name = "private-link"
    region = data.aws_region.current.region
    type = "vpce"
    rule {
        source = aws_vpc_endpoint.elastic-endpoint.id
    }
}

resource "ec_deployment_traffic_filter_association" "current" {
    deployment_id = data.ec_deployment.current.id
    traffic_filter_id = ec_deployment_traffic_filter.current.id
}