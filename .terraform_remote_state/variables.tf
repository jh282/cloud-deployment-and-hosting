variable "remote_state_bucket" {
  type    = string
  default = "terraform-remote-state-cdah"
}

variable "remote_state_table" {
  type    = string
  default = "terraform-state-locks"
}
