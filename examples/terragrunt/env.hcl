  //  Global Properties
locals {
  account     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  product     = read_terragrunt_config(find_in_parent_folders("product.hcl"))
  environment = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  //  Namespace Properties
  env                    = "dev"
  account_id             = local.account_vars.locals.account_id
  account_name           = local.account_vars.locals.account_name
  product_name           = local.product_vars.locals.product_name

  //  Global Tags
  tags = merge(
    local.common_vars.locals.tags,
    local.account_vars.locals.tags,
    local.region_vars.locals.tags,
    local.product_vars.locals.tags,
    {
      environment = local.env
    }
  )
}
