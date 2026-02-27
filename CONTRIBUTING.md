# Contribuindo com k8s_infra

## Fluxo de Trabalho

1. Crie um branch a partir de `main`
2. Faça suas mudanças
3. Execute as validações locais
4. Abra um Pull Request

## Validação Local

Antes de abrir um PR, execute:

```bash
# Instalar pre-commit (uma vez)
make pre-commit-install

# Validar tudo
make validate

# Ou rodar todos os hooks
make pre-commit-run
```

## Padrão de Commits

Seguimos [Conventional Commits](https://www.conventionalcommits.org/):

```
<tipo>(<escopo>): <descrição curta>

[corpo opcional]
```

**Tipos:**
- `feat`: nova funcionalidade
- `fix`: correção de bug
- `docs`: mudanças em documentação
- `refactor`: refatoração sem mudança de comportamento
- `ci`: mudanças em CI/CD
- `chore`: tarefas de manutenção

**Exemplos:**
```
feat(portfolio): adicionar suporte a múltiplos ambientes
fix(cert-manager): corrigir email no ClusterIssuer
docs(readme): atualizar versão do Image Updater
```

## Estrutura de Mudanças

### Adicionando uma nova aplicação

1. Crie o Helm chart em `gitops/helm/<app>/`
2. Crie o ArgoCD Application em `gitops/envs/<env>/<app>/application.yaml`
3. Se necessário, adicione secrets em `secrets/envs/<componente>/`

### Atualizando componentes de plataforma

Atualize a versão em `terraform/<componente>.tf` e o values em `terraform/values/<componente>.yaml`.
Teste localmente com `make tf-plan` antes de aplicar.

### Modificando secrets

Nunca commite arquivos `.env` ou secrets reais. Atualize apenas os arquivos `.env.example` com as variáveis necessárias (sem valores).

## Pull Request

- Título deve seguir o padrão Conventional Commits
- Descreva o que mudou e por quê
- Inclua link para issue, se aplicável
- O CI deve passar (YAML lint, Terraform validate, Helm lint, secret scan)
