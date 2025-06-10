locals {
  tags = var.tags

  organizations = var.harness_account.organizations

  projects = { for project in flatten([for org_id, org in local.organizations : [
    for project_id, project in org.projects : merge(project, {
      org_id = org_id
      id     = project_id
  })]]) : "${project.org_id}/${project.id}" => project }

  // STORE FOLDER
  account_store_folders = { for id, content in var.harness_account.store_folders : id => merge(content, {
    org_id     = null
    project_id = null
    id         = id
  }) }

  organizations_store_folders = { for data in flatten([for org_id, org in local.organizations : [
    for id, content in org.store_folders : merge(content, {
      org_id     = org_id
      project_id = null
      id         = id
  })]]) : "${data.org_id}/${data.id}" => data }

  projects_store_folders = { for data in flatten([for project_id, project in local.projects : [
    for id, content in project.store_folders : merge(content, {
      org_id     = project.org_id
      project_id = project.id
      id         = id
  })]]) : "${data.org_id}/${data.project_id}/${data.id}" => data }

  store_folders = merge(local.account_store_folders, local.organizations_store_folders, local.projects_store_folders)

  // STORE FILES
  account_store_files = { for id, content in var.harness_account.store_files : id => merge(content, {
    org_id     = null
    project_id = null
    id         = id
  }) }

  organizations_store_files = { for data in flatten([for org_id, org in local.organizations : [
    for id, content in org.store_files : merge(content, {
      org_id     = org_id
      project_id = null
      id         = id
  })]]) : "${data.org_id}/${data.id}" => data }

  projects_store_files = { for data in flatten([for project_id, project in local.projects : [
    for id, content in project.store_files : merge(content, {
      org_id     = project.org_id
      project_id = project.id
      id         = id
  })]]) : "${data.org_id}/${data.project_id}/${data.id}" => data }

  store_files = merge(local.account_store_files, local.organizations_store_files, local.projects_store_files)

  // DELEGATE TOKEN
  account_delegate_tokens = { for id, content in var.harness_account.delegate_tokens : id => merge(content, {
    account_id = var.harness_account.account_id
    org_id     = null
    project_id = null
    id         = id
  }) }

  organizations_delegate_tokens = { for data in flatten([for org_id, org in local.organizations : [
    for id, content in org.delegate_tokens : merge(content, {
      account_id = var.harness_account.account_id
      org_id     = org_id
      project_id = null
      id         = id
  })]]) : "${data.org_id}/${data.id}" => data }

  projects_delegate_tokens = { for data in flatten([for project_id, project in local.projects : [
    for id, content in project.delegate_tokens : merge(content, {
      account_id = var.harness_account.account_id
      org_id     = project.org_id
      project_id = project.id
      id         = id
  })]]) : "${data.org_id}/${data.project_id}/${data.id}" => data }

  delegate_tokens = merge(local.account_delegate_tokens, local.organizations_delegate_tokens, local.projects_delegate_tokens)

  // DELEGATE
  account_delegates = { for id, content in var.harness_account.delegates : id => merge(content, {
    account_id    = var.harness_account.account_id
    org_id        = null
    project_id    = null
    id            = id
    token_base_id = ""
  }) }

  organizations_delegates = { for data in flatten([for org_id, org in local.organizations : [
    for id, content in org.delegates : merge(content, {
      account_id    = var.harness_account.account_id
      org_id        = org_id
      project_id    = null
      id            = id
      token_base_id = "${org_id}/"
  })]]) : "${data.org_id}/${data.id}" => data }

  projects_delegates = { for data in flatten([for project_id, project in local.projects : [
    for id, content in project.delegates : merge(content, {
      account_id    = var.harness_account.account_id
      org_id        = project.org_id
      project_id    = project.id
      id            = id
      token_base_id = "${project.org_id}/${project.id}/"
  })]]) : "${data.org_id}/${data.project_id}/${data.id}" => data }

  delegates = merge(local.account_delegates, local.organizations_delegates, local.projects_delegates)

  // VARIABLES
  account_variables = { for id, content in var.harness_account.variables : id => merge(content, {
    org_id     = null
    project_id = null
    id         = id
  }) }

  organizations_variables = { for data in flatten([for org_id, org in local.organizations : [
    for id, content in org.variables : merge(content, {
      org_id     = org_id
      project_id = null
      id         = id
  })]]) : "${data.org_id}/${data.id}" => data }

  projects_variables = { for data in flatten([for project_id, project in local.projects : [
    for id, content in project.variables : merge(content, {
      org_id     = project.org_id
      project_id = project.id
      id         = id
  })]]) : "${data.org_id}/${data.project_id}/${data.id}" => data }

  variables = merge(local.account_variables, local.organizations_variables, local.projects_variables)

  // SECRETS
  account_secrets = { for id, content in var.harness_account.secrets : id => merge(content, {
    org_id     = null
    project_id = null
    id         = id
  }) }

  organizations_secrets = { for data in flatten([for org_id, org in local.organizations : [
    for id, content in org.secrets : merge(content, {
      org_id     = org_id
      project_id = null
      id         = id
  })]]) : "${data.org_id}/${data.id}" => data }

  projects_secrets = { for data in flatten([for project_id, project in local.projects : [
    for id, content in project.secrets : merge(content, {
      org_id     = project.org_id
      project_id = project.id
      id         = id
  })]]) : "${data.org_id}/${data.project_id}/${data.id}" => data }

  secrets = merge(local.account_secrets, local.organizations_secrets, local.projects_secrets)

  // SECRETS FILE
  account_secrets_file = { for id, content in var.harness_account.secrets_file : id => merge(content, {
    org_id     = null
    project_id = null
    id         = id
  }) }

  organizations_secrets_file = { for data in flatten([for org_id, org in local.organizations : [
    for id, content in org.secrets_file : merge(content, {
      org_id     = org_id
      project_id = null
      id         = id
  })]]) : "${data.org_id}/${data.id}" => data }

  projects_secrets_file = { for data in flatten([for project_id, project in local.projects : [
    for id, content in project.secrets_file : merge(content, {
      org_id     = project.org_id
      project_id = project.id
      id         = id
  })]]) : "${data.org_id}/${data.project_id}/${data.id}" => data }

  secrets_file = merge(local.account_secrets_file, local.organizations_secrets_file, local.projects_secrets_file)

  // TEMPLATES
  account_templates = { for id, content in var.harness_account.templates : id => merge(content, {
    org_id     = null
    project_id = null
    id         = id
  }) }

  organizations_templates = { for data in flatten([for org_id, org in local.organizations : [
    for id, content in org.templates : merge(content, {
      org_id     = org_id
      project_id = null
      id         = id
  })]]) : "${data.org_id}/${data.id}" => data }

  projects_templates = { for data in flatten([for project_id, project in local.projects : [
    for id, content in project.templates : merge(content, {
      org_id     = project.org_id
      project_id = project.id
      id         = id
  })]]) : "${data.org_id}/${data.project_id}/${data.id}" => data }

  templates = merge(local.account_templates, local.organizations_templates, local.projects_templates)

  // CONNECTORS CUSTOM SECRETS MANAGER
  account_connectors_custom_secrets_manager = { for id, content in var.harness_account.connectors_custom_secrets_manager : id => merge(content, {
    org_id     = null
    project_id = null
    id         = id
  }) }

  organizations_connectors_custom_secrets_manager = { for data in flatten([for org_id, org in local.organizations : [
    for id, content in org.connectors_custom_secrets_manager : merge(content, {
      org_id     = org_id
      project_id = null
      id         = id
  })]]) : "${data.org_id}/${data.id}" => data }

  projects_connectors_custom_secrets_manager = { for data in flatten([for project_id, project in local.projects : [
    for id, content in project.connectors_custom_secrets_manager : merge(content, {
      org_id     = project.org_id
      project_id = project.id
      id         = id
  })]]) : "${data.org_id}/${data.project_id}/${data.id}" => data }

  connectors_custom_secrets_manager = merge(local.account_connectors_custom_secrets_manager, local.organizations_connectors_custom_secrets_manager, local.projects_connectors_custom_secrets_manager)

  // CONNECTORS GITHUB
  account_connectors_github = { for id, content in var.harness_account.connectors_github : id => merge(content, {
    org_id     = null
    project_id = null
    id         = id
  }) }

  organizations_connectors_github = { for data in flatten([for org_id, org in local.organizations : [
    for id, content in org.connectors_github : merge(content, {
      org_id     = org_id
      project_id = null
      id         = id
  })]]) : "${data.org_id}/${data.id}" => data }

  projects_connectors_github = { for data in flatten([for project_id, project in local.projects : [
    for id, content in project.connectors_github : merge(content, {
      org_id     = project.org_id
      project_id = project.id
      id         = id
  })]]) : "${data.org_id}/${data.project_id}/${data.id}" => data }

  connectors_github = merge(local.account_connectors_github, local.organizations_connectors_github, local.projects_connectors_github)

  // CONNECTORS AWS
  account_connectors_aws = { for id, content in var.harness_account.connectors_aws : id => merge(content, {
    org_id     = null
    project_id = null
    id         = id
  }) }

  organizations_connectors_aws = { for data in flatten([for org_id, org in local.organizations : [
    for id, content in org.connectors_aws : merge(content, {
      org_id     = org_id
      project_id = null
      id         = id
  })]]) : "${data.org_id}/${data.id}" => data }

  projects_connectors_aws = { for data in flatten([for project_id, project in local.projects : [
    for id, content in project.connectors_aws : merge(content, {
      org_id     = project.org_id
      project_id = project.id
      id         = id
  })]]) : "${data.org_id}/${data.project_id}/${data.id}" => data }

  connectors_aws = merge(local.account_connectors_aws, local.organizations_connectors_aws, local.projects_connectors_aws)

  // CONNECTORS KUBERNETES
  account_connectors_kubernetes = { for id, content in var.harness_account.connectors_kubernetes : id => merge(content, {
    org_id     = null
    project_id = null
    id         = id
  }) }

  organizations_connectors_kubernetes = { for data in flatten([for org_id, org in local.organizations : [
    for id, content in org.connectors_kubernetes : merge(content, {
      org_id     = org_id
      project_id = null
      id         = id
  })]]) : "${data.org_id}/${data.id}" => data }

  projects_connectors_kubernetes = { for data in flatten([for project_id, project in local.projects : [
    for id, content in project.connectors_kubernetes : merge(content, {
      org_id     = project.org_id
      project_id = project.id
      id         = id
  })]]) : "${data.org_id}/${data.project_id}/${data.id}" => data }

  connectors_kubernetes = merge(local.account_connectors_kubernetes, local.organizations_connectors_kubernetes, local.projects_connectors_kubernetes)

}
