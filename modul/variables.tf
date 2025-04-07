
# RG variables
variable "rg_name" {
    type = string
    description = "RG name"
}

variable "rg_location" {
  description = "RG Location"
  type        = string
  default     = "westeurope"
}

# SA variable
variable "sa_name" {
  description = "SA name"
  type        = string
  default     = "sakm"
}

# Web blob variable
variable "index_document" {
  type = string
  description = "Name of the index document"
  default = "index.html"  # Setter standardverdi for indexdokumentet
}