resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = "dns"
  create_namespace = true

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.20.2"
  timeout    = 300

  set = [
    {
      name  = "crds.enabled"
      value = "true"
    },
    {
      name  = "crds.keep"
      value = "true"
    },
  ]
}
