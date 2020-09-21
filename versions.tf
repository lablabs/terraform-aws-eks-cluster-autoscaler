terraform {
  required_version = ">= 0.12.26, < 0.14.0"

  required_providers {
    aws  = ">= 2.0, < 4.0"
    helm = ">= 1.2, < 1.4.0"
  }
}
