provider "aws" {
  region  = var.aws_region
  alias   = "primary_region"
}

provider "aws" {
  region  = var.aws_region_ha
  alias   = "secondary_region"
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = var.website_bucket.id
  policy = data.aws_iam_policy_document.website_bucket.json
}

resource "aws_s3_account_public_access_block" "website_bucket" {
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "website_bucket" {
  bucket       = var.website_bucket.id
  key          = "index.html"
# source       = "index.html"
 content_type = "text/html"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket
}

resource "aws_s3_bucket_logging""log_bucket" {
  bucket = var.website_bucket

  target_bucket =  aws_s3_bucket.log_bucket.id
  target_prefix = " "
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = var.log_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "S3-Console-Auto-Gen-Policy-1699224162311",
    Statement = [
      {
        Sid       = "S3PolicyStmt-DO-NOT-MODIFY-1699224162205",
        Effect    = "Allow",
        Principal = {
          Service = "logging.s3.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "${var.log_bucket.arn}/*",
      },
    ],
  })
}

resource "aws_s3_bucket_policy" "website_bucket_ha_policy" {
  provider = aws.secondary_region
  bucket = var.website_bucket_ha.id
  policy = data.aws_iam_policy_document.website_bucket_ha.json
}

resource "aws_s3_account_public_access_block" "website_bucket_ha" {
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3control_multi_region_access_point" "multibucket" {
  details {
    name = "multibucket"

    region {
      bucket = var.website_bucket.idaws_s3_bucket.website_bucket
    }

    region {
      bucket = var.website_bucket_ha.id
    }
  }
}

data "aws_iam_policy_document" "website_bucket" {
  provider = aws.secondary_region
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.website_bucket.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

data "aws_iam_policy_document" "website_bucket_ha" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.website_bucket_ha.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}
