variable "domain_name" {
  type        = string
  description = "The domain name to use"
  default     = "techscrum-dev.disite.link"
}

variable "existing_zone" {
  description = "existing zone"
  type        = string
  default     = "disite.link"

}

variable "zone_id" {
  description = "zone_id"
  type        = string
  default     = "Z09214101IU8I71TAQICS"

}