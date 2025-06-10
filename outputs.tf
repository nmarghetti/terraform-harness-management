output "harness_organizations" {
  value = resource.harness_platform_organization.organization
}
output "harness_projects" {
  value = resource.harness_platform_project.project
}
output "harness_store_folders" {
  value = resource.harness_platform_file_store_folder.store_folder
}
output "harness_store_files" {
  value = resource.harness_platform_file_store_file.store_file
}
output "harness_delegate_tokens" {
  value = resource.harness_platform_delegatetoken.delegate_token
}
output "harness_delegates" {
  value = module.harness-delegate
}
output "harness_secrets" {
  value = resource.harness_platform_secret_text.secret
}
output "harness_secrets_file" {
  value = resource.harness_platform_secret_file.secret
}
output "harness_templates" {
  value = resource.harness_platform_template.template
}
