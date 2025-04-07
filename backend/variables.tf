# RG
variable "rg_backend_name" {
  type = string
  description = "name of the RG"
}

variable "rg_backend_location" {
  type = string
  description = "location of RG"
}

# SA
variable "sa_backend_name" {
  type = string
  description = "name of SA"
  default = "sabetfskm"
}

# SC
variable "sc_backend_name" {
  type = string
  description ="name of SC"
}

#KV
variable "sa_backend_accesskey_name" {
  type = string
  description = "name of the storage account acces key for the backend"
  }

  variable "kv_backend_name" {
    type = string
    description = "name of the key vault for the backend"
    
  }