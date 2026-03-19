module "account_map" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "2.0.0"

  component   = var.account_map_component_name
  tenant      = var.account_map_enabled ? coalesce(var.account_map_tenant, module.this.tenant) : null
  stage       = var.account_map_enabled ? var.root_account_stage : null
  environment = var.account_map_enabled ? var.global_environment : null
  privileged  = var.privileged

  context = module.this.context

  # When account_map is disabled, bypass remote state and use the static account_map variable
  bypass   = !var.account_map_enabled
  defaults = var.account_map
}

module "vpc" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "2.0.0"

  component = var.vpc_component_name

  context = module.this.context
}

module "logs_bucket" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "2.0.0"

  component = var.logs_bucket_component_name

  bypass        = !local.query_log_enabled || var.logs_bucket_component_name == null || var.logs_bucket_component_name == ""
  ignore_errors = !local.query_log_enabled || var.logs_bucket_component_name == null || var.logs_bucket_component_name == ""

  defaults = {
    bucket_id  = ""
    bucket_arn = ""
  }

  context = module.this.context
}
