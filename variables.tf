variable "key_name" {
  description = "the SSH key used to provision hosts"
}

variable "consul_version" {
  description = "the version of the consul AMI to use, defaults to blank which causes the latest to be used"
  default     = ""
}

variable "cidr" {
  description = "the cidr to use for region-1"
  default     = "192.168.1.0/24"
}

variable "environment" {
  description = "the name of this set up for naming"
  default     = "terraform-consul"
}

variable "consul_cluster_size" {
  description = "the number of nodes in this cluster"
  default     = "3"
}