## Variables for env, region, and projectname  ##
variable "env" {
  type    = string
  default = "production"
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "projectName" {
  type    = string
  default = "mediawiki"
}