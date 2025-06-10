# Copilot generation
# I would like to create a variable with type matching all possible fields but remove identifier, org_id and project_id from the following schema:
# Paste schema content, eg. from https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_file_store_file#schema

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = set(string)
  default     = []
}

## Harness management
variable "harness_account" {
  description = "Harness account to create"
  type = object({
    account_id = string
    organizations = optional(map(object({
      name        = string
      description = optional(string)
      tags        = optional(set(string))
      projects = map(object({
        name        = string
        description = string
        tags        = optional(set(string))
        store_folders = optional(map(object({
          name              = string
          parent_identifier = optional(string, "Root")
          description       = optional(string)
          tags              = optional(set(string))
        })), {})
        store_files = optional(map(object({
          name              = string
          parent_identifier = optional(string, "Root")
          description       = optional(string)
          file_content_path = optional(string)
          file_usage        = optional(string)
          mime_type         = optional(string)
          tags              = optional(set(string))
        })), {})
        delegate_tokens = optional(map(object({
        })), {})
        delegates = optional(map(object({
          token_name       = string
          endpoint         = optional(string, "https://app.harness.io")
          image            = optional(string, "harness/delegate:25.02.85201")
          init_script      = optional(string, "")
          create_namespace = optional(bool, true)
          namespace        = optional(string, "harness-delegate-ng")
          deploy_mode      = optional(string, "KUBERNETES")
          helm_repository  = optional(string, "https://app.harness.io/storage/harness-download/delegate-helm-chart/")
          values           = optional(string, "")
          tags             = optional(set(string))
        })), {})
        variables = optional(map(object({
          name        = string
          type        = string
          description = optional(string)
          spec = object({
            fixed_value = optional(string, "FIXED")
            value_type  = string
          })
        })), {})
        secrets = optional(map(object({
          name                      = string
          secret_manager_identifier = string
          value                     = string
          value_type                = string
          description               = optional(string)
          tags                      = optional(set(string))
          additional_metadata = optional(object({
            values = object({
              version = string
            })
          }))
        })), {})
        secrets_file = optional(map(object({
          file_path                 = string
          name                      = string
          secret_manager_identifier = string
          description               = optional(string)
          tags                      = optional(set(string))
        })), {})
        templates = optional(map(object({
          name    = string
          version = string
          # Optional fields
          comments     = optional(string)
          force_delete = optional(string)
          git_details = optional(object({
            base_branch    = optional(string)
            branch_name    = optional(string)
            commit_message = optional(string)
            connector_ref  = optional(string)
            file_path      = optional(string)
            last_commit_id = optional(string)
            last_object_id = optional(string)
            repo_name      = optional(string)
            store_type     = optional(string)
          }))
          git_import_details = optional(object({
            branch_name     = optional(string)
            connector_ref   = optional(string)
            file_path       = optional(string)
            is_force_import = optional(bool)
            repo_name       = optional(string)
          }))
          import_from_git = optional(bool)
          is_stable       = optional(bool)
          tags            = optional(set(string))
          template_import_request = optional(object({
            template_description = optional(string)
            template_name        = optional(string)
            template_version     = optional(string)
          }))
          template_yaml = string
        })), {})
        connectors_custom_secrets_manager = optional(map(object({
          name               = string
          type               = optional(string, "CustomSecretManager")
          on_delegate        = bool
          template_ref       = string
          description        = optional(string)
          timeout            = optional(number)
          tags               = optional(set(string))
          version_label      = optional(string)
          delegate_selectors = optional(set(string))
          target_host        = optional(string)
          ssh_secret_ref     = optional(string)
          working_directory  = optional(string)
          template_inputs = optional(list(object({
            environment_variable = list(object({
              name    = string
              value   = string
              type    = string
              default = optional(bool, false)
            }))
          })))
        })), {})
        connectors_github = optional(map(object({
          connection_type     = string
          name                = string
          url                 = string
          description         = optional(string)
          delegate_selectors  = optional(set(string))
          execute_on_delegate = optional(bool)
          force_delete        = optional(string)
          tags                = optional(set(string))
          validation_repo     = optional(string)
          credentials = object({
            http = optional(object({
              token_ref    = string
              username     = optional(string)
              username_ref = optional(string)
              github_app = optional(object({
                private_key_ref     = string
                application_id      = optional(string)
                application_id_ref  = optional(string)
                installation_id     = optional(string)
                installation_id_ref = optional(string)
              }))
              anonymous = optional(object({}))
            }))
            ssh = optional(object({
              ssh_key_ref = string
            }))
          })
          api_authentication = optional(object({
            github_app = optional(object({
              private_key_ref     = string
              application_id      = optional(string)
              application_id_ref  = optional(string)
              installation_id     = optional(string)
              installation_id_ref = optional(string)
            }))
            token_ref = optional(string)
          }))
        })), {})
        connectors_aws = optional(map(object({
          name         = string
          description  = optional(string)
          tags         = optional(set(string))
          force_delete = optional(bool)
          cross_account_access = optional(object({
            role_arn    = string
            external_id = optional(string)
          }))
          equal_jitter_backoff_strategy = optional(object({
            base_delay       = optional(number)
            max_backoff_time = optional(number)
            retry_count      = optional(number)
          }))
          fixed_delay_backoff_strategy = optional(object({
            fixed_backoff = optional(number)
            retry_count   = optional(number)
          }))
          full_jitter_backoff_strategy = optional(object({
            base_delay       = optional(number)
            max_backoff_time = optional(number)
            retry_count      = optional(number)
          }))
          inherit_from_delegate = optional(object({
            delegate_selectors = set(string)
            region             = optional(string)
          }))
          irsa = optional(object({
            delegate_selectors = set(string)
            region             = optional(string)
          }))
          manual = optional(object({
            secret_key_ref     = string
            access_key         = optional(string)
            access_key_ref     = optional(string)
            session_token_ref  = optional(string)
            delegate_selectors = optional(set(string))
            region             = optional(string)
          }))
          oidc_authentication = optional(object({
            iam_role_arn       = string
            delegate_selectors = set(string)
            region             = string
          }))
        })), {})
        connectors_kubernetes = optional(map(object({
          name               = string
          description        = optional(string)
          delegate_selectors = optional(set(string))
          force_delete       = optional(bool)
          tags               = optional(set(string))
          client_key_cert = optional(object({
            client_cert_ref           = string
            client_key_algorithm      = string
            client_key_ref            = string
            master_url                = string
            ca_cert_ref               = optional(string)
            client_key_passphrase_ref = optional(string)
          }))
          inherit_from_delegate = optional(object({
            delegate_selectors = set(string)
          }))
          openid_connect = optional(object({
            client_id_ref = string
            issuer_url    = string
            master_url    = string
            password_ref  = string
            scopes        = optional(list(string))
            secret_ref    = optional(string)
            username      = optional(string)
            username_ref  = optional(string)
          }))
          service_account = optional(object({
            master_url                = string
            service_account_token_ref = string
            ca_cert_ref               = optional(string)
          }))
          username_password = optional(object({
            master_url   = string
            password_ref = string
            username     = optional(string)
            username_ref = optional(string)
          }))
        })), {})
      }))
      store_folders = optional(map(object({
        name              = string
        parent_identifier = optional(string, "Root")
        description       = optional(string)
        tags              = optional(set(string))
      })), {})
      store_files = optional(map(object({
        name              = string
        parent_identifier = optional(string, "Root")
        description       = optional(string)
        file_content_path = optional(string)
        file_usage        = optional(string)
        mime_type         = optional(string)
        tags              = optional(set(string))
      })), {})
      delegate_tokens = optional(map(object({
      })), {})
      delegates = optional(map(object({
        token_name       = string
        endpoint         = optional(string, "https://app.harness.io")
        image            = optional(string, "harness/delegate:25.02.85201")
        init_script      = optional(string, "")
        create_namespace = optional(bool, true)
        namespace        = optional(string, "harness-delegate-ng")
        deploy_mode      = optional(string, "KUBERNETES")
        helm_repository  = optional(string, "https://app.harness.io/storage/harness-download/delegate-helm-chart/")
        values           = optional(string, "")
        tags             = optional(set(string))
      })), {})
      variables = optional(map(object({
        name        = string
        type        = string
        description = optional(string)
        spec = object({
          fixed_value = optional(string, "FIXED")
          value_type  = string
        })
      })), {})
      secrets = optional(map(object({
        name                      = string
        secret_manager_identifier = string
        value                     = string
        value_type                = string
        description               = optional(string)
        tags                      = optional(set(string))
        additional_metadata = optional(object({
          values = object({
            version = string
          })
        }))
      })), {})
      secrets_file = optional(map(object({
        file_path                 = string
        name                      = string
        secret_manager_identifier = string
        description               = optional(string)
        tags                      = optional(set(string))
      })), {})
      templates = optional(map(object({
        name    = string
        version = string
        # Optional fields
        comments     = optional(string)
        force_delete = optional(string)
        git_details = optional(object({
          base_branch    = optional(string)
          branch_name    = optional(string)
          commit_message = optional(string)
          connector_ref  = optional(string)
          file_path      = optional(string)
          last_commit_id = optional(string)
          last_object_id = optional(string)
          repo_name      = optional(string)
          store_type     = optional(string)
        }))
        git_import_details = optional(object({
          branch_name     = optional(string)
          connector_ref   = optional(string)
          file_path       = optional(string)
          is_force_import = optional(bool)
          repo_name       = optional(string)
        }))
        import_from_git = optional(bool)
        is_stable       = optional(bool)
        tags            = optional(set(string))
        template_import_request = optional(object({
          template_description = optional(string)
          template_name        = optional(string)
          template_version     = optional(string)
        }))
        template_yaml = string
      })), {})
      connectors_custom_secrets_manager = optional(map(object({
        name               = string
        type               = optional(string, "CustomSecretManager")
        on_delegate        = bool
        template_ref       = string
        description        = optional(string)
        timeout            = optional(number)
        tags               = optional(set(string))
        version_label      = optional(string)
        delegate_selectors = optional(set(string))
        target_host        = optional(string)
        ssh_secret_ref     = optional(string)
        working_directory  = optional(string)
        template_inputs = optional(list(object({
          environment_variable = list(object({
            name    = string
            value   = string
            type    = string
            default = optional(bool, false)
          }))
        })))
      })), {})
      connectors_github = optional(map(object({
        connection_type     = string
        name                = string
        url                 = string
        description         = optional(string)
        delegate_selectors  = optional(set(string))
        execute_on_delegate = optional(bool)
        force_delete        = optional(string)
        tags                = optional(set(string))
        validation_repo     = optional(string)
        credentials = object({
          http = optional(object({
            token_ref    = string
            username     = optional(string)
            username_ref = optional(string)
            github_app = optional(object({
              private_key_ref     = string
              application_id      = optional(string)
              application_id_ref  = optional(string)
              installation_id     = optional(string)
              installation_id_ref = optional(string)
            }))
            anonymous = optional(object({}))
          }))
          ssh = optional(object({
            ssh_key_ref = string
          }))
        })
        api_authentication = optional(object({
          github_app = optional(object({
            private_key_ref     = string
            application_id      = optional(string)
            application_id_ref  = optional(string)
            installation_id     = optional(string)
            installation_id_ref = optional(string)
          }))
          token_ref = optional(string)
        }))
      })), {})
      connectors_aws = optional(map(object({
        name         = string
        description  = optional(string)
        tags         = optional(set(string))
        force_delete = optional(bool)
        cross_account_access = optional(object({
          role_arn    = string
          external_id = optional(string)
        }))
        equal_jitter_backoff_strategy = optional(object({
          base_delay       = optional(number)
          max_backoff_time = optional(number)
          retry_count      = optional(number)
        }))
        fixed_delay_backoff_strategy = optional(object({
          fixed_backoff = optional(number)
          retry_count   = optional(number)
        }))
        full_jitter_backoff_strategy = optional(object({
          base_delay       = optional(number)
          max_backoff_time = optional(number)
          retry_count      = optional(number)
        }))
        inherit_from_delegate = optional(object({
          delegate_selectors = set(string)
          region             = optional(string)
        }))
        irsa = optional(object({
          delegate_selectors = set(string)
          region             = optional(string)
        }))
        manual = optional(object({
          secret_key_ref     = string
          access_key         = optional(string)
          access_key_ref     = optional(string)
          session_token_ref  = optional(string)
          delegate_selectors = optional(set(string))
          region             = optional(string)
        }))
        oidc_authentication = optional(object({
          iam_role_arn       = string
          delegate_selectors = set(string)
          region             = string
        }))
      })), {})
      connectors_kubernetes = optional(map(object({
        name               = string
        description        = optional(string)
        delegate_selectors = optional(set(string))
        force_delete       = optional(bool)
        tags               = optional(set(string))
        client_key_cert = optional(object({
          client_cert_ref           = string
          client_key_algorithm      = string
          client_key_ref            = string
          master_url                = string
          ca_cert_ref               = optional(string)
          client_key_passphrase_ref = optional(string)
        }))
        inherit_from_delegate = optional(object({
          delegate_selectors = set(string)
        }))
        openid_connect = optional(object({
          client_id_ref = string
          issuer_url    = string
          master_url    = string
          password_ref  = string
          scopes        = optional(list(string))
          secret_ref    = optional(string)
          username      = optional(string)
          username_ref  = optional(string)
        }))
        service_account = optional(object({
          master_url                = string
          service_account_token_ref = string
          ca_cert_ref               = optional(string)
        }))
        username_password = optional(object({
          master_url   = string
          password_ref = string
          username     = optional(string)
          username_ref = optional(string)
        }))
      })), {})
    })), {}),
    store_folders = optional(map(object({
      name              = string
      parent_identifier = optional(string, "Root")
      description       = optional(string)
      tags              = optional(set(string))
    })), {})
    store_files = optional(map(object({
      name              = string
      parent_identifier = optional(string, "Root")
      description       = optional(string)
      file_content_path = optional(string)
      file_usage        = optional(string)
      mime_type         = optional(string)
      tags              = optional(set(string))
    })), {})
    delegate_tokens = optional(map(object({
    })), {})
    delegates = optional(map(object({
      token_name       = string
      endpoint         = optional(string, "https://app.harness.io")
      image            = optional(string, "harness/delegate:25.02.85201")
      init_script      = optional(string, "")
      create_namespace = optional(bool, true)
      namespace        = optional(string, "harness-delegate-ng")
      deploy_mode      = optional(string, "KUBERNETES")
      helm_repository  = optional(string, "https://app.harness.io/storage/harness-download/delegate-helm-chart/")
      values           = optional(string, "")
      tags             = optional(set(string))
    })), {})
    variables = optional(map(object({
      name        = string
      type        = string
      description = optional(string)
      spec = object({
        fixed_value = optional(string, "FIXED")
        value_type  = string
      })
    })), {})
    secrets = optional(map(object({
      name                      = string
      secret_manager_identifier = string
      value                     = string
      value_type                = string
      description               = optional(string)
      tags                      = optional(set(string))
      additional_metadata = optional(object({
        values = object({
          version = string
        })
      }))
    })), {})
    secrets_file = optional(map(object({
      file_path                 = string
      name                      = string
      secret_manager_identifier = string
      description               = optional(string)
      tags                      = optional(set(string))
    })), {})
    templates = optional(map(object({
      name    = string
      version = string
      # Optional fields
      comments     = optional(string)
      force_delete = optional(string)
      git_details = optional(object({
        base_branch    = optional(string)
        branch_name    = optional(string)
        commit_message = optional(string)
        connector_ref  = optional(string)
        file_path      = optional(string)
        last_commit_id = optional(string)
        last_object_id = optional(string)
        repo_name      = optional(string)
        store_type     = optional(string)
      }))
      git_import_details = optional(object({
        branch_name     = optional(string)
        connector_ref   = optional(string)
        file_path       = optional(string)
        is_force_import = optional(bool)
        repo_name       = optional(string)
      }))
      import_from_git = optional(bool)
      is_stable       = optional(bool)
      tags            = optional(set(string))
      template_import_request = optional(object({
        template_description = optional(string)
        template_name        = optional(string)
        template_version     = optional(string)
      }))
      template_yaml = string
    })), {})
    connectors_custom_secrets_manager = optional(map(object({
      name               = string
      type               = optional(string, "CustomSecretManager")
      on_delegate        = bool
      template_ref       = string
      description        = optional(string)
      timeout            = optional(number)
      tags               = optional(set(string))
      version_label      = optional(string)
      delegate_selectors = optional(set(string))
      target_host        = optional(string)
      ssh_secret_ref     = optional(string)
      working_directory  = optional(string)
      template_inputs = optional(list(object({
        environment_variable = list(object({
          name    = string
          value   = string
          type    = string
          default = optional(bool, false)
        }))
      })))
    })), {})
    connectors_github = optional(map(object({
      connection_type     = string
      name                = string
      url                 = string
      description         = optional(string)
      delegate_selectors  = optional(set(string))
      execute_on_delegate = optional(bool)
      force_delete        = optional(string)
      tags                = optional(set(string))
      validation_repo     = optional(string)
      credentials = object({
        http = optional(object({
          token_ref    = string
          username     = optional(string)
          username_ref = optional(string)
          github_app = optional(object({
            private_key_ref     = string
            application_id      = optional(string)
            application_id_ref  = optional(string)
            installation_id     = optional(string)
            installation_id_ref = optional(string)
          }))
          anonymous = optional(object({}))
        }))
        ssh = optional(object({
          ssh_key_ref = string
        }))
      })
      api_authentication = optional(object({
        github_app = optional(object({
          private_key_ref     = string
          application_id      = optional(string)
          application_id_ref  = optional(string)
          installation_id     = optional(string)
          installation_id_ref = optional(string)
        }))
        token_ref = optional(string)
      }))
    })), {})
    connectors_aws = optional(map(object({
      name         = string
      description  = optional(string)
      tags         = optional(set(string))
      force_delete = optional(bool)
      cross_account_access = optional(object({
        role_arn    = string
        external_id = optional(string)
      }))
      equal_jitter_backoff_strategy = optional(object({
        base_delay       = optional(number)
        max_backoff_time = optional(number)
        retry_count      = optional(number)
      }))
      fixed_delay_backoff_strategy = optional(object({
        fixed_backoff = optional(number)
        retry_count   = optional(number)
      }))
      full_jitter_backoff_strategy = optional(object({
        base_delay       = optional(number)
        max_backoff_time = optional(number)
        retry_count      = optional(number)
      }))
      inherit_from_delegate = optional(object({
        delegate_selectors = set(string)
        region             = optional(string)
      }))
      irsa = optional(object({
        delegate_selectors = set(string)
        region             = optional(string)
      }))
      manual = optional(object({
        secret_key_ref     = string
        access_key         = optional(string)
        access_key_ref     = optional(string)
        session_token_ref  = optional(string)
        delegate_selectors = optional(set(string))
        region             = optional(string)
      }))
      oidc_authentication = optional(object({
        iam_role_arn       = string
        delegate_selectors = set(string)
        region             = string
      }))
    })), {})
    connectors_kubernetes = optional(map(object({
      name               = string
      description        = optional(string)
      delegate_selectors = optional(set(string))
      force_delete       = optional(bool)
      tags               = optional(set(string))
      client_key_cert = optional(object({
        client_cert_ref           = string
        client_key_algorithm      = string
        client_key_ref            = string
        master_url                = string
        ca_cert_ref               = optional(string)
        client_key_passphrase_ref = optional(string)
      }))
      inherit_from_delegate = optional(object({
        delegate_selectors = set(string)
      }))
      openid_connect = optional(object({
        client_id_ref = string
        issuer_url    = string
        master_url    = string
        password_ref  = string
        scopes        = optional(list(string))
        secret_ref    = optional(string)
        username      = optional(string)
        username_ref  = optional(string)
      }))
      service_account = optional(object({
        master_url                = string
        service_account_token_ref = string
        ca_cert_ref               = optional(string)
      }))
      username_password = optional(object({
        master_url   = string
        password_ref = string
        username     = optional(string)
        username_ref = optional(string)
      }))
    })), {})
  })
  default = {
    account_id = ""
  }
}
