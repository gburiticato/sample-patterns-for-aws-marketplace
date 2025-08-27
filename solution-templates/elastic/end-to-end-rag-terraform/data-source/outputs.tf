output "bucket_name" {
    value = aws_s3_bucket.data_source.bucket
}

output "bucket_arn" {
    value = aws_s3_bucket.data_source.arn
}