locals {
  name_prefix       = "${var.environment}-${var.project}-${local.naming.location[var.location]}"
  name_prefix_short = "${var.environment}${var.project}${local.naming.location[var.location]}"
  naming = {
    location = {
      "australiaeast" = "aue"
    }
  }
  tags = {
    project     = var.project
    environment = var.environment
  }

  configuration = {
    use_private_link = true
  }
}
