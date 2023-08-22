module "banodoco_frontend" {
    source = "./modules/repository"

    app_name = "banodoco-frontend"
    iam_user_name = "github_user"
}

output "banodoco_fe_access_key" {
    value = module.banodoco_frontend.access_key
    sensitive = true
}

output "banodoco_fe_secret_key" {
    value = module.banodoco_frontend.secret_key
    sensitive = true
}