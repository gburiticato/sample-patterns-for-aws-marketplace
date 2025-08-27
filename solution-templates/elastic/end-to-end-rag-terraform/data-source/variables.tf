variable "deployment_id" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "route_table_ids" {
    type = list(string)
}

variable "security_group_ids" {
    type = list(string)
}
    