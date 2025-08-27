resource "aws_vpc_endpoint" "elastic-endpoint" {
    vpc_id = var.vpc_id
    service_name = local.service_names[data.aws_region.current.region].name
    vpc_endpoint_type = "Interface"
    private_dns_enabled = false
    subnet_ids = var.subnet_ids
}

resource "aws_route53_zone" "elastic-endpoint" {
    name = local.service_names[data.aws_region.current.region].hosted_zone
    vpc {
        vpc_id = var.vpc_id
    }
}

resource "aws_route53_record" "elastic-endpoint" {
    zone_id = aws_route53_zone.elastic-endpoint.zone_id
    name = "*"
    type = "CNAME"
    records = [aws_vpc_endpoint.elastic-endpoint.dns_entry.0.dns_name]
    ttl = 300
}