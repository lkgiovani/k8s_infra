.PHONY: help validate lint tf-fmt tf-validate tf-plan tf-apply helm-lint secrets-apply

TERRAFORM_DIR := terraform
HELM_CHART_DIR := gitops/helm/portfolio
SECRETS_SCRIPT := ./apply-secrets.sh

## help: Exibe esta mensagem de ajuda
help:
	@echo "Targets disponíveis:"
	@grep -E '^## ' Makefile | sed 's/## /  /'

## validate: Executa todas as validações (YAML, Terraform, Helm)
validate: tf-validate helm-lint
	@echo "Todas as validações passaram."

## lint: Executa linters (yamllint, terraform fmt check, helm lint)
lint: tf-fmt helm-lint
	@yamllint -c .yamllint.yaml .
	@echo "Linting concluído."

## tf-fmt: Formata os arquivos Terraform
tf-fmt:
	terraform -chdir=$(TERRAFORM_DIR) fmt -recursive

## tf-validate: Valida a configuração Terraform
tf-validate:
	terraform -chdir=$(TERRAFORM_DIR) init -backend=false -input=false
	terraform -chdir=$(TERRAFORM_DIR) validate

## tf-plan: Exibe o plano de execução Terraform (requer credenciais)
tf-plan:
	terraform -chdir=$(TERRAFORM_DIR) plan

## tf-apply: Aplica as mudanças Terraform (requer credenciais)
tf-apply:
	terraform -chdir=$(TERRAFORM_DIR) apply

## helm-lint: Valida o Helm chart do portfolio
helm-lint:
	helm lint $(HELM_CHART_DIR)

## secrets-apply: Aplica os secrets no cluster (requer kubectl configurado)
secrets-apply:
	$(SECRETS_SCRIPT)

## pre-commit-install: Instala os hooks de pre-commit
pre-commit-install:
	pre-commit install

## pre-commit-run: Executa todos os hooks de pre-commit
pre-commit-run:
	pre-commit run --all-files
