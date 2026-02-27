# Segurança

## Reportando Vulnerabilidades

Se você encontrar uma vulnerabilidade de segurança neste repositório, **não abra uma issue pública**. Entre em contato diretamente por email: lkgiovani@gmail.com.

## Práticas de Segurança

### Secrets

- Secrets **nunca** são versionados no Git
- Arquivos `.env` estão no `.gitignore`
- Os arquivos `.env.example` contêm apenas os nomes das variáveis, sem valores
- Secrets são gerados via Kustomize e aplicados diretamente no cluster com `apply-secrets.sh`

### Acesso ao Cluster

- Kubeconfig (`~/.kube/config-vps`) não deve ser compartilhado ou versionado
- Acesso ao ArgoCD deve usar SSO ou credenciais fortes
- RBAC do ArgoCD está restrito a recursos explicitamente permitidos (ver `argocd/project.yaml`)

### Imagens de Container

- Imagens devem usar tags semânticas (ex: `v1.2.3`), nunca `latest` em produção
- O Image Updater monitora novas versões e atualiza automaticamente via Git
- Imagens são armazenadas no GitHub Container Registry (`ghcr.io/lkgiovani/*`)

### Certificados TLS

- Certificados são gerenciados automaticamente pelo Cert-Manager
- Renovação automática antes do vencimento
- Validação DNS via Cloudflare (sem necessidade de expor porta 80)

### Kubernetes

- Security contexts habilitados: `runAsNonRoot`, `readOnlyRootFilesystem`, capabilities dropped
- Resource limits definidos em todos os workloads
- Network Policies ativas no namespace `prod`
- Pod Disruption Budgets configurados para alta disponibilidade

### CI/CD

- Todos os PRs passam por scan de secrets com `gitleaks`
- YAML, Terraform e Helm são validados automaticamente
- Pre-commit hooks evitam commits com problemas

## Checklist de Segurança para Mudanças

Antes de fazer merge de qualquer mudança:

- [ ] Nenhum secret ou credencial no código
- [ ] Imagens com tags específicas (não `latest`)
- [ ] Resource limits definidos para novos workloads
- [ ] Security context configurado para novos containers
- [ ] RBAC mínimo necessário (princípio do menor privilégio)
