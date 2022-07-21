locals {
  prefix       = "my-prefix"
  product_name = "my-product"

  tags = {
    environment        = "dev"
    application        = "MyApplication"
    automation         = "terraform"
    cost_center        = "development" 
    customer           = "contoso"
    notification_email = "my-team@contoso.com"
    production         = false
    team_name          = "devops"
  }
}
