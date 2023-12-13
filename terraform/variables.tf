# Provider Variable
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

# Provider Variable
variable "aws_region_ha" {
  description = "AWS region_ha"
  type        = string
  default     = "ap-southeast-1"
}

# Bucket Variable
variable "website_bucket" {
  description = "S3 bucket name"
  type        = string
  default     = "techscrum-dev"
}

# Bucket Variable
variable "website_bucket_ha" {
  description = "S3 bucket name"
  type        = string
  default     = "techscrum-dev-sg"
}

# Bucket Variable
variable "log_bucket" {
  description = "S3 bucket name for access logging storage"
  type        = string
  default     = "techscrum-dev-access-log"
}

# Domain Variable
variable "domain_name" {
  type        = string
  description = "The domain name to use"
  default     = "techscrum-dev.disite.link"
}

# Domain Variable
variable "zone_id" {
  type        = string
  description = "Zone ID"
  default     = "Z09214101IU8I71TAQICS"
}

# Domain Variable
variable "existing_zone" {
  type        = string
  description = "Zone ID"
  default     = "disite.link"
}
