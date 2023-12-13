variable "website_bucket" {
  description = "S3 bucket name"
  type        = string
  default     = "techscrum-dev"

}

variable "website_bucket_ha" {
  description = "S3 bucket name"
  type        = string
  default     = "techscrum-dev-sg"

}

variable "log_bucket" {
  description = "S3 bucket name for access logging storage"
  type        = string
  default     = "techscrum-dev-access-log"
}