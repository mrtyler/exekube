provider "helm" {}

resource "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "ingress_controller" {
  name = "my-ingress-controller"
  repository = "${helm_repository.stable.metadata.0.name}"
  chart = "nginx-ingress"
  values = "${file("helm/releases/nginx-ingress.yaml")}"
}