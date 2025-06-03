terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # or your preferred region
}

resource "aws_s3_bucket" "internal_bucket_name" {
  bucket              = var.s3_bucket_name
  object_lock_enabled = true

  tags = {
    Name        = var.s3_bucket_name
    Environment = "Test"
    CreatedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "example_lifecycle_config" {
  bucket = aws_s3_bucket.internal_bucket_name.id

  rule {
    id     = "example-object-transition"
    status = "Enabled"

    filter {
      prefix = "this/is/a/fake/prefix"
    }

    transition {
      days          = 365
      storage_class = "STANDARD_IA"
    }
  }
}
