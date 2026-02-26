#!/bin/bash
set -e

# Cloudflare
if [ ! -f secrets/envs/cloudflare/.env ]; then
  cp secrets/envs/cloudflare/.env.example secrets/envs/cloudflare/.env
  echo "Preencha secrets/envs/cloudflare/.env e rode novamente."
  exit 1
fi

# ArgoCD
if [ ! -f secrets/envs/argocd-repo/.env ]; then
  cp secrets/envs/argocd-repo/.env.example secrets/envs/argocd-repo/.env
  echo "Preencha secrets/envs/argocd-repo/.env e rode novamente."
  exit 1
fi

if [ ! -f secrets/envs/argocd-repo/githubAppPrivateKey ]; then
  echo "Arquivo secrets/envs/argocd-repo/githubAppPrivateKey não encontrado."
  echo "Cole sua chave PEM em secrets/envs/argocd-repo/githubAppPrivateKey e rode novamente."
  exit 1
fi

kubectl apply -k secrets/
