# Changelog

Todas as mudanças notáveis neste projeto são documentadas aqui.

O formato segue [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/), e este projeto adota [Semantic Versioning](https://semver.org/lang/pt-BR/).

---

## [Unreleased]

### Segurança
- Removido flag `--insecure` do ArgoCD server (TLS habilitado)
- Restrito RBAC do AppProject ArgoCD — de `*/*` para lista explícita de recursos
- Habilitado security context no Helm chart do portfolio (`runAsNonRoot`, `readOnlyRootFilesystem`, capabilities dropped)
- Definidos resource limits no portfolio (CPU: 200m/50m, Memory: 256Mi/64Mi)
- Substituída tag `latest` por `v1.0.0` no deployment de produção
- Corrigido email no ClusterIssuer (era `test@test.com`)
- Alterado log level do External DNS de `debug` para `warning`

### Adicionado
- `.pre-commit-config.yaml` com hooks: yamllint, terraform fmt/validate, helm lint, gitleaks
- `.yamllint.yaml` com regras de linting YAML
- `.editorconfig` para padronização de formatação
- `Makefile` com targets: validate, lint, tf-fmt, tf-validate, tf-plan, tf-apply, helm-lint, secrets-apply
- `.github/workflows/validate.yaml` — CI para validação em PRs
- `CONTRIBUTING.md` com fluxo de contribuição e padrão de commits
- `SECURITY.md` com práticas de segurança e processo de reporte de vulnerabilidades
- `CHANGELOG.md` (este arquivo)
- Template `poddisruptionbudget.yaml` no Helm chart
- Template `networkpolicy.yaml` no Helm chart
- Namespace `prod` definido em `secrets/namespaces.yaml`
- Probes (liveness/readiness) configuradas no deployment de produção

### Corrigido
- Versão do ArgoCD Image Updater no README (v0.16.0 → v0.12.1)

---

## [0.1.0] — 2024-01-01

### Adicionado
- Infraestrutura GitOps inicial com ArgoCD, Cert-Manager, External DNS e ArgoCD Image Updater
- Terraform para instalação de componentes de plataforma via Helm
- Helm chart para aplicação portfolio
- Kustomize para geração de secrets
- README com documentação da arquitetura e setup
