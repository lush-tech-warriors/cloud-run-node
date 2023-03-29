variable "project_id" {
  type        = string
  description = "The Google Cloud Project Id"
}

variable "region" {
  type    = string
  default = "europe-west2"
}

variable "region_fallback" {
  type    = string
  default = "europe-west1"
}

variable "service_name" {
  type = string
}

variable "cloudrun_image" {
  type = string
}

variable "next_public_host" {
  type = string
}