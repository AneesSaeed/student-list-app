resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_user_assigned_identity" "identity" {
  name                = var.identity_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = var.service_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Spring backend
resource "azurerm_linux_web_app" "spring_app" {
  name                = var.spring_web_app_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id
  site_config {
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = azurerm_user_assigned_identity.identity.client_id

    application_stack {
      docker_image_name   = var.spring_docker_image_name
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity.id]
  }

  app_settings = {
    WEBSITES_PORT = var.spring_web_app_port
    SPRING_DATASOURCE_URL      = "jdbc:postgresql://${azurerm_postgresql_flexible_server.pg.fqdn}:5432/${var.pg_db_name}?sslmode=require"
    SPRING_DATASOURCE_USERNAME = var.pg_admin_user
    SPRING_DATASOURCE_PASSWORD = var.pg_admin_password
  }
}

# vue frontend
resource "azurerm_linux_web_app" "vue_app" {
  name                = var.vue_web_app_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id
  site_config {
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = azurerm_user_assigned_identity.identity.client_id

    application_stack {
      docker_image_name   = var.vue_docker_image_name
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity.id]
  }

  app_settings = {
    WEBSITES_PORT = var.vue_web_app_port
  }
}


# DB server
resource "azurerm_postgresql_flexible_server" "pg" {
  name                   = var.pg_name
  resource_group_name    = azurerm_resource_group.rg.name
  location               = var.pg_location
  version                = "16"
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  backup_retention_days  = 7
  administrator_login    = var.pg_admin_user
  administrator_password = var.pg_admin_password

  public_network_access_enabled = true
  delegated_subnet_id           = null
    
  authentication {
    password_auth_enabled = true
  }
}

resource "azurerm_postgresql_flexible_server_database" "appdb" {
  name      = var.pg_db_name
  server_id = azurerm_postgresql_flexible_server.pg.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

resource "time_sleep" "wait_for_pg" {
  depends_on      = [azurerm_postgresql_flexible_server.pg]
  create_duration = "90s"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.pg.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
  depends_on       = [time_sleep.wait_for_pg]  
}