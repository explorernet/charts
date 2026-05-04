# AGENTS.md

## Objetivo

Este repositório guarda charts Helm para o cluster.

Ao criar novos charts aqui, seguir as convenções abaixo.

## Estrutura

- Cada chart deve ficar em `charts/<nome-do-chart>/`
- Não usar diretório por versão dentro do chart
- A versão do chart é controlada por `Chart.yaml` (`version`) e pelo pacote `.tgz` publicado na raiz

## Nomenclatura

- O nome dos recursos deve usar o release name como prefixo
- Não repetir o nome fixo do chart no prefixo
- Exemplo:
  - release `n8n` -> `n8n-server`
  - release `redis-tools` -> `redis-tools-job`

## Valores e defaults

- Preferir defaults reutilizáveis, não dados reais de produção
- Não deixar domínio real, e-mail real, host interno real, credencial real ou token no chart
- `values.yaml` deve vir com secrets vazios
- Campos sensíveis devem ir para `Secret`, não para `ConfigMap`
- Evitar defaults excessivamente específicos do ambiente, exceto quando forem padrão claro do cluster

## Ingress

- O padrão deste repositório para ingress é:
  - `className: traefik`
  - annotation `cert-manager.io/cluster-issuer: letsencrypt`
- Sempre expor hosts via `ingress.hosts`
- Quando fizer sentido, derivar URLs públicas internas do chart a partir do host principal do ingress para evitar duplicação de configuração

## Imagens

- Usar `pullPolicy: IfNotPresent` por padrão
- Assumir imagens taggeadas, não `Always`

## Segurança e simplicidade

- Não adicionar `serviceAccount` por padrão, a menos que o chart realmente precise
- Não adicionar `imagePullSecrets` por padrão, a menos que o chart realmente precise
- Não adicionar `securityContext` por padrão, a menos que exista necessidade clara

## Recursos

- Definir `resources.requests` e `resources.limits` no `values.yaml`
- Usar unidades nativas do Kubernetes:
  - CPU em `m`
  - memória em `Mi` ou `Gi`

## Múltiplas instâncias

- O chart deve permitir múltiplos releases sem colisão
- Não fixar nomes de recursos fora do padrão baseado em release
- Cuidar para que hostnames, PVCs, banco, filas e secrets possam variar por release quando necessário

## Atualizações

- Evitar mudanças de nome de recurso depois que o chart já estiver em uso
- Mudança de nome pode causar recriação de recurso e indisponibilidade
- Sempre que a estrutura publicada mudar, regenerar:
  - pacote `.tgz`
  - `index.yaml`

## Publicação e higiene

- O repositório é público; revisar sempre se não há dados sensíveis antes de commitar
- Nunca commitar manifests brutos exportados do cluster com secrets reais
- Nunca commitar certificados, chaves privadas, senhas, tokens ou arquivos de values de produção

## Rancher

- Os charts daqui são consumidos como Helm repository
- Não estruturar charts pensando em `Git repository containing Helm chart`
- Priorizar compatibilidade com instalação repetida via catálogo Helm do Rancher
