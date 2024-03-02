variable "project" {
  type        = string
  description = "The project ID of your project"
  sensitive   = false
  nullable    = false
}

variable "region" {
  type        = string
  description = "Region of your project"
  sensitive   = false
  nullable    = false
}

variable "username" {
  type        = string
  description = "User name for new MySQL user - Only String values accepted."
  sensitive   = false
  nullable    = false

  validation {
    condition     = length(var.username) > 2
    error_message = "Username must be a minimum of 3 characters"
  }
}

variable "user_password" {
  type        = string
  description = "Password for new MySQL user - Minimum length is 6 characters and must contain a special character"
  sensitive   = true
  nullable    = false

  validation {
    condition     = length(var.user_password) > 5
    error_message = "Password does not meet complexity requirements"
  }
}

variable "database_name" {
  type        = string
  description = "Name for MySQL database"
  nullable    = false
}
