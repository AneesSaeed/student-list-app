variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "pg_location" {
  description = "Region for Azure PostgreSQL Flexible Server"
  type        = string
  default     = "North Europe"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-container-app"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "esiattendance62294"
}

variable "identity_name" {
  description = "Name of the user-assigned managed identity"
  type        = string
  default     = "container-app-identity"
}

variable "service_plan_name" {
  description = "Name of the App Service plan"
  type        = string
  default     = "appserviceplan"
}

variable "spring_web_app_name" {
  description = "Name of the spring Web App"
  type        = string
  default     = "esiattendancebackend"
}

variable "vue_web_app_name" {
  description = "Name of the vue Web App"
  type        = string
  default     = "esiattendancefrontend"
}

variable "spring_docker_image_name" {
  description = "spring Docker image name and tag"
  type        = string
  default     = "springserviceimage:latest"
}

variable "vue_docker_image_name" {
  description = "vue Docker image name and tag"
  type        = string
  default     = "vueserviceimage:latest"
}

variable "spring_web_app_port" {
  description = "Port on which the spring web app listens"
  type        = string
  default     = "8080"
}

variable "vue_web_app_port" {
  description = "Port on which the vue web app listens"
  type        = string
  default     = "80"
}


# db

variable "pg_name" {
  type = string  
  default = "esiattendance-pg" 
}

variable "pg_admin_user" {
  type = string  
  default = "appadmin" 
}

variable "pg_admin_password" {
  type = string  
  sensitive = true
}

variable "pg_db_name" {
  type = string  
  default = "mydb"
}
