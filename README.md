# k8s_infra

Infraestrutura Kubernetes gerenciada com GitOps, Terraform e Helm para hospedar o portfólio pessoal em `lkgiovani.com`.

## Visão Geral

Este repositório é a **fonte da verdade** para toda a infraestrutura do cluster Kubernetes (K3s). Ele combina:

- **Terraform** para instalar e gerenciar os componentes de plataforma via Helm
- **ArgoCD** para GitOps — qualquer push neste repositório é sincronizado automaticamente no cluster
- **Kustomize** para gerenciamento de manifests e geração de secrets
- **Helm** para empacotar e versionar a aplicação de portfólio

---

## Arquitetura

```
Git Push ──► ArgoCD detecta mudança ──► Sincroniza no cluster
                                              │
Container Registry ──► Image Updater ──► Commit no Git
```

### Componentes de Plataforma (instalados via Terraform + Helm)

| Componente | Versão | Namespace | Função |
|---|---|---|---|
| ArgoCD | v8.0.9 | `argocd` | GitOps — CD e sincronização com o repositório |
| Cert-Manager | v1.17.2 | `cert-manager` | Geração e renovação automática de certificados TLS |
| External DNS | v1.16.1 | `external-dns` | Criação automática de registros DNS no Cloudflare |
| ArgoCD Image Updater | v0.12.1 | `argocd` | Atualização automática de imagens de container no Git |

### Aplicações (gerenciadas pelo ArgoCD via GitOps)

| Aplicação | Namespace | Domínio | Descrição |
|---|---|---|---|
| Portfolio | `prod` | `todinho.lkgiovani.com` | Site de portfólio pessoal |

---

## Estrutura do Repositório

```
k8s_infra/
├── terraform/               # Instala componentes de plataforma via Helm
│   ├── provider.tf          # Configuração do provider Helm (kubeconfig: ~/.kube/config-vps)
│   ├── argocd.tf            # Helm release do ArgoCD
│   ├── cert-manager.tf      # Helm release do Cert-Manager
│   ├── external-dns.tf      # Helm release do External DNS
│   ├── image-updater.tf     # Helm release do ArgoCD Image Updater
│   └── values/              # Values customizados para cada componente
│
├── argocd/                  # Configuração do ArgoCD
│   ├── project.yaml         # AppProject: define permissões e destinos
│   ├── applicationset.yaml  # ApplicationSet: gera Applications por ambiente
│   └── kustomization.yaml
│
├── cert-manager/            # Gerenciamento de certificados TLS
│   ├── cloudflare-clusterissuer.yaml  # ClusterIssuer ACME via Cloudflare DNS
│   ├── certificate.yaml               # Certificado wildcard para lkgiovani.com
│   └── kustomization.yaml
│
├── gitops/                  # Definições de aplicações gerenciadas pelo ArgoCD
│   ├── helm/portfolio/      # Helm chart da aplicação portfólio
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/       # Deployment, Service, Ingress, HPA, ServiceAccount
│   └── envs/prod/portfolio/
│       └── application.yaml # ArgoCD Application para o ambiente de produção
│
├── secrets/                 # Geração de secrets via Kustomize
│   ├── envs/                # Arquivos .env por componente (não versionados)
│   │   ├── cloudflare/      # Token da API do Cloudflare
│   │   ├── external-dns/    # Credenciais do External DNS
│   │   └── argocd-repo/     # GitHub App credentials para o ArgoCD
│   ├── namespaces.yaml      # Definição dos namespaces
│   └── kustomization.yaml
│
└── apply-secrets.sh         # Script para aplicar secrets no cluster
```

---

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform) >= 1.0
- [kubectl](https://kubernetes.io/docs/tasks/tools/) configurado com acesso ao cluster
- Kubeconfig disponível em `~/.kube/config-vps`
- Arquivos `.env` preenchidos em `secrets/envs/` (ver seção de Secrets)

---

## Setup Inicial

### 1. Aplicar os Secrets

Antes de qualquer coisa, os secrets precisam estar no cluster:

```bash
# Preencha os arquivos de exemplo em secrets/envs/
# Cloudflare, External DNS e ArgoCD repo credentials

./apply-secrets.sh
```

### 2. Instalar os Componentes de Plataforma

```bash
cd terraform
terraform init
terraform apply
```

Isso instala ArgoCD, Cert-Manager, External DNS e Image Updater no cluster.

### 3. Bootstrap do ArgoCD

Após o ArgoCD estar rodando, aplique as configurações de GitOps:

```bash
kubectl apply -k argocd/
kubectl apply -k cert-manager/
```

A partir desse ponto, qualquer push ao repositório é automaticamente sincronizado pelo ArgoCD.

---

## Secrets

Os secrets **não são versionados** no Git. Cada diretório em `secrets/envs/` contém um arquivo `.env.example` com as variáveis necessárias. Crie os arquivos `.env` correspondentes antes de executar `apply-secrets.sh`.

| Secret | Diretório | Usado por |
|---|---|---|
| Cloudflare API Token | `secrets/envs/cloudflare/` | Cert-Manager (validação DNS) |
| External DNS API Token | `secrets/envs/external-dns/` | External DNS |
| GitHub App Credentials | `secrets/envs/argocd-repo/` | ArgoCD (acesso ao repositório) |

---

## GitOps — Como Funciona

O **ApplicationSet** em `argocd/applicationset.yaml` monitora o diretório `gitops/envs/` e gera automaticamente um ArgoCD Application para cada ambiente encontrado.

- Push de código → ArgoCD detecta → Sync automático no cluster
- Nova imagem no registry → Image Updater detecta → Commit no Git → ArgoCD sincroniza

Para adicionar um novo ambiente, basta criar o diretório `gitops/envs/<env>/<app>/` com o manifest de Application.

---

## Certificados TLS

O Cert-Manager gerencia automaticamente os certificados:

- **ClusterIssuer**: Let's Encrypt via validação DNS com Cloudflare
- **Certificado**: wildcard `*.lkgiovani.com` armazenado como `traefik-cert-secret` no namespace `kube-system`
- **Renovação**: automática antes do vencimento

---

## Tecnologias

- **Kubernetes** (K3s) — orquestração de containers
- **Terraform + Helm** — IaC para instalação de plataforma
- **ArgoCD** — GitOps e continuous delivery
- **Kustomize** — gerenciamento de manifests e secrets
- **Traefik** — ingress controller
- **Cert-Manager** — automação de certificados TLS
- **Let's Encrypt** — autoridade certificadora
- **Cloudflare** — DNS provider
- **GitHub Container Registry** — registry de imagens (`ghcr.io/lkgiovani/*`)
