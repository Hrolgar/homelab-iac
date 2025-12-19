data "infisical_secrets" "folders" {
  for_each     = var.infisical_folders
  env_slug     = "dev"
  workspace_id = var.infisical_project_id
  folder_path  = "/${each.value}"
}