resource "helm_release" "acm-operator" {
  name       = "acm-operator"
  repository = "${path.module}"
  chart      = "acm-operator"
  namespace  = "kube-system"

  # set {
  #   name  = "projectID"
  #   value = var.project_id
  # }

  # set {
  #   name  = "location"
  #   value = var.location
  # }

  # set {
  #   name  = "clusterName"
  #   value = var.cluster_name
  # }

  # set {
  #   name  = "serviceAccount"
  #   value = "acm-operator-sa"
  # }

  # set {
  #   name  = "rbacEnable"
  #   value = "true"
  # }

  # set {
  #   name  = "syncRepoURL"
  #   value = var.sync_repo_url
  # }

  # set {
  #   name  = "syncRepoBranch"
  #   value = var.sync_repo_branch
  # }

  # set {
  #   name  = "syncManifestPath"
  #   value = var.sync_manifest_path
  # }

  # set {
  #   name  = "syncRoot"
  #   value = var.sync_root
  # }

  # set {
  #   name  = "clusterScopes"
  #   value = var.cluster_scopes
  # }

  # set {
  #   name  = "policyControllerEnable"
  #   value = "true"
  # }

  # set {
  #   name  = "policyControllerTemplateLibraryPath"
  #   value = var.policy_controller_template_library_path
  # }

  # set {
  #   name  = "policyControllerConfig"
  #   value = var.policy_controller_config
  # }

  values = [
    file("${path.module}/acm-operator.yaml")
  ]
}

resource "helm_release" "acm-operator-conf" {
  name       = "acm-operator-conf"
  repository = "${path.module}"
  chart      = "acm-operator-conf"
  namespace  = "kube-system"

  depends_on = [
    helm_release.acm-operator
  ]

  values = [
    file("${path.module}/acm-operator-conf.yaml")
    # {
    #   # Configure CMO to use the GitLab backend
    #   backend: gitlab
    #   gitlab:
    #     api_url: "https://gitlab.example.com/api/v4"
    #     token_secret: kubernetes_secret.gitlab-token.metadata.0.name
    #     project: YOUR_GITLAB_PROJECT_HERE
    #     ref: master

    #   # Configure the CMO agent
    #   agent:
    #     image:
    #       repository: my-registry/cmo-agent
    #       tag: latest
    #     resources:
    #       requests:
    #         cpu: 100m
    #         memory: 128Mi
    #       limits:
    #         cpu: 500m
    #         memory: 512Mi
    # }
  ]
}