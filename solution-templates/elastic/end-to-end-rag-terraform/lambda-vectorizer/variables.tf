variable "vpc_id" {
    type = string
}

variable "s3_bucket" {
    type = string
}

variable "elasticsearch_private_https_endpoint" {
    type = string
}

variable "elasticsearch_connection_secret" {
    type = string
}

variable "vpc_subnet_ids" {
    type = list(string)
}

variable "vpc_security_group_ids" {
    type = list(string)
}

variable "bucket_id" {
    type = string
}