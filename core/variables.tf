variable "location" {
  type        = string
  description = "(Optional) The location for resource deployment"
  default     = "australiaeast"
}

variable "environment" {
  type        = string
  description = "(Required) Three character environment name"
  validation {
    condition     = length(var.environment) <= 3
    error_message = "Err: Environment cannot be longer than three characters."
  }
}

variable "project" {
  type        = string
  description = "(Required) The project name"
}

variable "azure_subscription_id" {
  type        = string
  description = "The ID of the Azure subscription"
}

variable "your_ip" {
  type        = string
  description = "Your IP use * if not sure"
}


variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  default     = {}
}

