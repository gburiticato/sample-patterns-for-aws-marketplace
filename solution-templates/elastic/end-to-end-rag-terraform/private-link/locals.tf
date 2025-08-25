# The source for this data can be foundt at: https://www.elastic.co/docs/deploy-manage/security/aws-privatelink-traffic-filters#ec-private-link-service-names-aliases
# Data up to date as of 2025-06-29

locals {
  service_names = {
    af-south-1 = {
        name = "com.amazonaws.vpce.af-south-1.vpce-svc-0d3d7b74f60a6c32c"
        hosted_zone = "vpce.af-south-1.aws.elastic-cloud.com"
    }
    ap-east-1 = {
        name = "com.amazonaws.vpce.ap-east-1.vpce-svc-0f96fbfaf55558d5c"
        hosted_zone = "vpce.ap-east-1.aws.elastic-cloud.com"
    }
    ap-northeast-1 = {
        name = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-0e1046d7b48d5cf5f"
        hosted_zone = "vpce.ap-northeast-1.aws.elastic-cloud.com"
    }
    ap-northeast-2 = {
        name = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0d90cf62dae682b84"
        hosted_zone = "vpce.ap-northeast-2.aws.elastic-cloud.com"
    }
    ap-south-1 = {
        name = "com.amazonaws.vpce.ap-south-1.vpce-svc-0e9c1ae5caa269d1b"
        hosted_zone = "vpce.ap-south-1.aws.elastic-cloud.com"
    }
    ap-southeast-1 = {
        name = "com.amazonaws.vpce.ap-southeast-1.vpce-svc-0cbc6cb9bdb683a95"
        hosted_zone = "vpce.ap-southeast-1.aws.elastic-cloud.com"
    }
    ap-southeast-2 = {
        name = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0cde7432c1436ef13"
        hosted_zone = "vpce.ap-southeast-2.aws.elastic-cloud.com"
    }
    ca-central-1 = {
        name = "com.amazonaws.vpce.ca-central-1.vpce-svc-0d3e69dd6dd336c28"
        hosted_zone = "vpce.ca-central-1.aws.elastic-cloud.com"
    }
    eu-central-1 = {
        name = "com.amazonaws.vpce.eu-central-1.vpce-svc-081b2960e915a0861"
        hosted_zone = "vpce.eu-central-1.aws.elastic-cloud.com"
    }
    eu-central-2 = {
        name = "com.amazonaws.vpce.eu-central-2.vpce-svc-07deba12e07d77434"
        hosted_zone = "vpce.eu-central-2.aws.elastic-cloud.com"
    }
    eu-south-1 = {
        name = "com.amazonaws.vpce.eu-south-1.vpce-svc-03d8fc8a66a755237"
        hosted_zone = "vpce.eu-south-1.aws.elastic-cloud.com"
    }
    eu-north-1 = {
        name = "com.amazonaws.vpce.eu-north-1.vpce-svc-05915fc851f802294"
        hosted_zone = "vpce.eu-north-1.aws.elastic-cloud.com"
    }
    eu-west-1 = {
        name = "com.amazonaws.vpce.eu-west-1.vpce-svc-01f2afe87944eb12b"
        hosted_zone = "vpce.eu-west-1.aws.elastic-cloud.com"
    }
    eu-west-2 = {
        name = "com.amazonaws.vpce.eu-west-2.vpce-svc-0e42a2c194c97a1d0"
        hosted_zone = "vpce.eu-west-2.aws.elastic-cloud.com"
    }
    eu-west-3 = {
        name = "com.amazonaws.vpce.eu-west-3.vpce-svc-0d6912d10db9693d1"
        hosted_zone = "vpce.eu-west-3.aws.elastic-cloud.com"
    }
    me-south-1 = {
        name = "com.amazonaws.vpce.me-south-1.vpce-svc-0381de3eb670dcb48"
        hosted_zone = "vpce.me-south-1.aws.elastic-cloud.com"
    }
    sa-east-1 = {
        name = "com.amazonaws.vpce.sa-east-1.vpce-svc-0b2dbce7e04dae763"
        hosted_zone = "vpce.sa-east-1.aws.elastic-cloud.com"
    }
    us-east-1 = {
        name = "com.amazonaws.vpce.us-east-1.vpce-svc-0e42e1e06ed010238"
        hosted_zone = "vpce.us-east-1.aws.elastic-cloud.com"
    }
    us-east-2 = {
        name = "com.amazonaws.vpce.us-east-2.vpce-svc-02d187d2849ffb478"
        hosted_zone = "vpce.us-east-2.aws.elastic-cloud.com"
    }
    us-west-1 = {
        name = "com.amazonaws.vpce.us-west-1.vpce-svc-00def4a16a26cb1b4"
        hosted_zone = "vpce.us-west-1.aws.elastic-cloud.com"
    }
    us-west-2 = {
        name = "com.amazonaws.vpce.us-west-2.vpce-svc-0e69febae1fb91870"
        hosted_zone = "vpce.us-west-2.aws.elastic-cloud.com"
    }
  }
}