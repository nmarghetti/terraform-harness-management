resource "harness_platform_organization" "organization" {
  for_each = local.organizations

  tags        = (each.key == "default" ? [] : toset(concat(tolist(local.tags), tolist(each.value.tags == null ? [] : each.value.tags))))
  identifier  = each.key
  name        = each.value.name
  description = each.value.description
}

resource "harness_platform_project" "project" {
  depends_on = [harness_platform_organization.organization]
  for_each   = local.projects

  tags        = toset(concat(tolist(local.tags), tolist(each.value.tags == null ? [] : each.value.tags)))
  identifier  = each.value.id
  org_id      = each.value.org_id
  name        = each.value.name
  description = each.value.description
}

resource "harness_platform_file_store_folder" "store_folder" {
  depends_on = [harness_platform_project.project]
  for_each   = local.store_folders

  tags              = toset(concat(tolist(local.tags), tolist(each.value.tags == null ? [] : each.value.tags)))
  identifier        = each.value.id
  parent_identifier = each.value.parent_identifier
  org_id            = each.value.org_id
  project_id        = each.value.project_id
  name              = each.value.name
  description       = each.value.description
}

resource "harness_platform_file_store_file" "store_file" {
  depends_on = [harness_platform_file_store_folder.store_folder]
  for_each   = local.store_files

  tags              = toset(concat(tolist(local.tags), tolist(each.value.tags == null ? [] : each.value.tags)))
  identifier        = each.value.id
  parent_identifier = each.value.parent_identifier
  org_id            = each.value.org_id
  project_id        = each.value.project_id
  name              = each.value.name
  description       = each.value.description
  file_content_path = each.value.file_content_path
  file_usage        = each.value.file_usage
  mime_type         = each.value.mime_type
}

resource "harness_platform_delegatetoken" "delegate_token" {
  depends_on = [harness_platform_file_store_file.store_file]
  for_each   = local.delegate_tokens

  account_id = each.value.account_id
  org_id     = each.value.org_id
  project_id = each.value.project_id
  name       = each.value.id
}

module "harness-delegate" {
  depends_on = [harness_platform_delegatetoken.delegate_token]
  source     = "harness/harness-delegate/kubernetes"
  version    = "0.2.0"

  for_each = local.delegates

  account_id       = each.value.account_id
  delegate_name    = each.value.id
  delegate_image   = each.value.image
  delegate_token   = harness_platform_delegatetoken.delegate_token["${each.value.token_base_id}${each.value.token_name}"].value
  manager_endpoint = each.value.endpoint
  init_script      = each.value.init_script
  create_namespace = each.value.create_namespace
  namespace        = each.value.namespace
  deploy_mode      = each.value.deploy_mode
  helm_repository  = each.value.helm_repository
  values           = each.value.values
}

resource "harness_platform_variables" "variable" {
  for_each = local.variables

  identifier = each.value.id
  org_id     = each.value.org_id
  project_id = each.value.project_id
  name       = each.value.name
  type       = each.value.type
  spec {
    value_type  = each.value.spec.value_type
    fixed_value = each.value.spec.fixed_value
  }
  description = each.value.description
}

resource "harness_platform_secret_text" "secret" {
  depends_on = [harness_platform_file_store_file.store_file]
  for_each   = local.secrets

  tags                      = toset(concat(tolist(local.tags), tolist(each.value.tags == null ? [] : each.value.tags)))
  identifier                = each.value.id
  org_id                    = each.value.org_id
  project_id                = each.value.project_id
  name                      = each.value.name
  description               = each.value.description
  secret_manager_identifier = each.value.secret_manager_identifier
  value_type                = each.value.value_type
  value                     = each.value.value
  additional_metadata {
    values {
      version = try(each.value.additional_metadata.values.version, null)
    }
  }
}

resource "harness_platform_secret_file" "secret" {
  for_each = local.secrets_file

  tags                      = toset(concat(tolist(local.tags), tolist(each.value.tags == null ? [] : each.value.tags)))
  identifier                = each.value.id
  org_id                    = each.value.org_id
  project_id                = each.value.project_id
  name                      = each.value.name
  description               = each.value.description
  secret_manager_identifier = each.value.secret_manager_identifier
  file_path                 = each.value.file_path
}

resource "harness_platform_template" "template" {
  depends_on = [harness_platform_file_store_file.store_file]
  for_each   = local.templates

  tags          = toset(concat(tolist(local.tags), tolist(each.value.tags == null ? [] : each.value.tags)))
  identifier    = each.value.id
  org_id        = each.value.org_id
  project_id    = each.value.project_id
  name          = each.value.name
  version       = each.value.version
  template_yaml = each.value.template_yaml
}

resource "harness_platform_connector_custom_secret_manager" "connector_custom_secret_manager" {
  depends_on = [harness_platform_template.template]
  for_each   = local.connectors_custom_secrets_manager

  tags               = toset(concat(tolist(local.tags), tolist(each.value.tags == null ? [] : each.value.tags)))
  identifier         = each.value.id
  org_id             = each.value.org_id
  project_id         = each.value.project_id
  name               = each.value.name
  type               = each.value.type
  version_label      = each.value.version_label != null ? each.value.version_label : "1"
  template_ref       = each.value.template_ref
  on_delegate        = each.value.on_delegate
  description        = each.value.description
  timeout            = each.value.timeout
  delegate_selectors = each.value.delegate_selectors
  target_host        = each.value.target_host
  ssh_secret_ref     = each.value.ssh_secret_ref
  working_directory  = each.value.working_directory

  dynamic "template_inputs" {
    for_each = each.value.template_inputs != null ? each.value.template_inputs : []
    content {
      dynamic "environment_variable" {
        for_each = template_inputs.value.environment_variable
        content {
          name    = environment_variable.value.name
          value   = environment_variable.value.value
          type    = environment_variable.value.type
          default = environment_variable.value.default
        }
      }
    }

  }
}

resource "harness_platform_connector_github" "connector_github" {
  depends_on = [harness_platform_template.template]
  for_each   = local.connectors_github

  tags            = toset(concat(tolist(local.tags), tolist(each.value.tags == null ? [] : each.value.tags)))
  identifier      = each.value.id
  org_id          = each.value.org_id
  project_id      = each.value.project_id
  name            = each.value.name
  connection_type = each.value.connection_type
  credentials {
    dynamic "http" {
      for_each = each.value.credentials.http != null ? [each.value.credentials.http] : []
      content {
        token_ref    = each.value.credentials.http.token_ref
        username     = each.value.credentials.http.username
        username_ref = each.value.credentials.http.username_ref
        github_app {
          application_id      = each.value.credentials.http.github_app.application_id
          application_id_ref  = each.value.credentials.http.github_app.application_id_ref
          installation_id     = each.value.credentials.http.github_app.installation_id
          installation_id_ref = each.value.credentials.http.github_app.installation_id_ref
          private_key_ref     = each.value.credentials.http.github_app.private_key_ref
        }
      }
    }
    dynamic "ssh" {
      for_each = each.value.credentials.ssh != null ? [each.value.credentials.ssh] : []
      content {
        ssh_key_ref = each.value.credentials.ssh.ssh_key_ref
      }
    }
  }
  url = each.value.url
  dynamic "api_authentication" {
    for_each = each.value.api_authentication != null ? [each.value.api_authentication] : []
    content {
      github_app {
        application_id      = each.value.api_authentication.github_app.application_id
        application_id_ref  = each.value.api_authentication.github_app.application_id_ref
        installation_id     = each.value.api_authentication.github_app.installation_id
        installation_id_ref = each.value.api_authentication.github_app.installation_id_ref
        private_key_ref     = each.value.api_authentication.github_app.private_key_ref
      }
    }
  }
  delegate_selectors  = each.value.delegate_selectors
  description         = each.value.description
  execute_on_delegate = each.value.execute_on_delegate
  force_delete        = each.value.force_delete
  validation_repo     = each.value.validation_repo
}

resource "harness_platform_connector_aws" "connector_aws" {
  depends_on = [harness_platform_template.template]
  for_each   = local.connectors_aws

  tags       = toset(concat(tolist(local.tags), tolist(each.value.tags == null ? [] : each.value.tags)))
  identifier = each.value.id
  org_id     = each.value.org_id
  project_id = each.value.project_id
  name       = each.value.name

  dynamic "manual" {
    for_each = each.value.manual != null ? [each.value.manual] : []
    content {
      access_key         = manual.value.access_key
      secret_key_ref     = manual.value.secret_key_ref
      session_token_ref  = manual.value.session_token_ref
      delegate_selectors = manual.value.delegate_selectors
      region             = manual.value.region
    }
  }

  dynamic "inherit_from_delegate" {
    for_each = each.value.inherit_from_delegate != null ? [each.value.inherit_from_delegate] : []
    content {
      delegate_selectors = inherit_from_delegate.value.delegate_selectors
    }
  }
}

resource "harness_platform_connector_kubernetes" "connector_kubernetes" {
  depends_on = [harness_platform_template.template]
  for_each   = local.connectors_kubernetes

  tags       = toset(concat(tolist(local.tags), tolist(each.value.tags == null ? [] : each.value.tags)))
  identifier = each.value.id
  org_id     = each.value.org_id
  project_id = each.value.project_id
  name       = each.value.name

  dynamic "inherit_from_delegate" {
    for_each = each.value.inherit_from_delegate != null ? [each.value.inherit_from_delegate] : []
    content {
      delegate_selectors = inherit_from_delegate.value.delegate_selectors
    }
  }
}
