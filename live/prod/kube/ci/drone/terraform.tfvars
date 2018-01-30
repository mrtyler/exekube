# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//helm-release"
  }

  dependencies {
    paths = [
      "../../../infra/gcp-gke",
      "../../core/ingress-controller",
      "../../core/kube-lego",
      "../chartmuseum",
    ]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}