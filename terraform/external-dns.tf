resource "helm_release" "external_dns" {
  name             = "external-dns"
  namespace        = "dns"
  create_namespace = true

  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.21.1"

  values = [file("values/external-dns.yaml")]
}
