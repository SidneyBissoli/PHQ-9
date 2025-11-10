# 🤝 Guia de Contribuição

Obrigado por considerar contribuir com o **PHQ-9 Statistical Analysis System**! 

Este documento fornece diretrizes para contribuir com o projeto.

---

## 📋 Código de Conduta

### Nossos Compromissos

- Manter um ambiente respeitoso e inclusivo
- Aceitar críticas construtivas
- Focar no que é melhor para a comunidade
- Demonstrar empatia com outros membros

---

## 🚀 Como Contribuir

### 1️⃣ Reportar Bugs

Encontrou um bug? Ajude-nos a melhorar!

**Antes de reportar:**
- ✅ Verifique se o bug já foi reportado nas [Issues](https://github.com/SEU_USUARIO/PHQ-9/issues)
- ✅ Certifique-se de estar usando a versão mais recente
- ✅ Teste com dados fictícios (nunca compartilhe dados reais de pacientes!)

**Como reportar:**
1. Abra uma [Nova Issue](https://github.com/SEU_USUARIO/PHQ-9/issues/new)
2. Use o template de bug report
3. Inclua:
   - Versão do R e RStudio
   - Sistema operacional
   - Código para reproduzir o erro
   - Mensagem de erro completa
   - Comportamento esperado vs. observado

**Exemplo de bom report:**

```markdown
**Ambiente:**
- R: 4.3.1
- RStudio: 2023.06.1
- SO: Windows 11

**Erro:**
`Error in analisar_phq9(): could not find function "mutate"`

**Código para reproduzir:**
```r
source("scripts/analise_phq9_avancado.R")
resultado <- analisar_phq9(meus_dados)
```

**Comportamento esperado:** Análise completar sem erros
**Comportamento observado:** Erro de função não encontrada
```

---

### 2️⃣ Sugerir Melhorias

Tem uma ideia para melhorar o projeto?

1. Abra uma [Issue de Feature Request](https://github.com/SEU_USUARIO/PHQ-9/issues/new)
2. Descreva claramente:
   - O problema que a feature resolve
   - Como seria a solução
   - Casos de uso
   - Alternativas consideradas

---

### 3️⃣ Contribuir com Código

#### Fluxo de Trabalho

```bash
# 1. Fork o projeto no GitHub

# 2. Clone seu fork
git clone https://github.com/SEU_USUARIO/PHQ-9.git
cd PHQ-9

# 3. Adicione o repositório original como upstream
git remote add upstream https://github.com/USUARIO_ORIGINAL/PHQ-9.git

# 4. Crie uma branch para sua feature
git checkout -b feature/minha-feature

# 5. Faça suas alterações
# ... edite os arquivos ...

# 6. Commit com mensagem semântica
git add .
git commit -m "Add: funcionalidade X para análise Y"

# 7. Push para seu fork
git push origin feature/minha-feature

# 8. Abra um Pull Request no GitHub
```

---

## 📝 Padrões de Código

### Estilo R

Siga o [Tidyverse Style Guide](https://style.tidyverse.org/):

**✅ BOM:**
```r
# Nomes descritivos e snake_case
calcular_escore_total <- function(dados) {
  dados %>%
    mutate(
      escore_total = rowSums(select(., starts_with("PHQ9_")))
    )
}
```

**❌ RUIM:**
```r
# Nomes pouco claros
calc<-function(d){d$tot=rowSums(d[,3:11])}
```

### Estrutura de Funções

```r
#' Título Curto da Função
#'
#' Descrição detalhada do que a função faz.
#'
#' @param parametro1 Descrição do parâmetro 1
#' @param parametro2 Descrição do parâmetro 2
#'
#' @return Descrição do retorno
#'
#' @examples
#' resultado <- minha_funcao(dados, opcao = TRUE)
#'
#' @export
minha_funcao <- function(parametro1, parametro2 = valor_padrao) {
  # Validações
  if (!is.data.frame(parametro1)) {
    stop("parametro1 deve ser um dataframe")
  }
  
  # Processamento
  resultado <- parametro1 %>%
    filter(condicao) %>%
    mutate(nova_coluna = calculo)
  
  # Retorno
  return(resultado)
}
```

### Comentários

```r
# ===== SEÇÃO PRINCIPAL =====

# Explicação do que o bloco faz
codigo_aqui <- funcao()

# TODO: Implementar validação adicional
# FIXME: Corrigir bug com valores NA
# NOTE: Atenção especial para encoding
```

---

## 📊 Testes

### Teste Manual

Antes de enviar seu PR, teste:

```r
# 1. Configure o ambiente limpo
rm(list = ls())
source("00_configuracao_inicial.R")

# 2. Teste análise básica
source("scripts/analise_phq9_basico.R")
source("scripts/relatorio_phq9_basico.R")

# 3. Teste análise avançada
source("scripts/analise_phq9_avancado.R")
source("scripts/relatorio_phq9_avancado.R")

# 4. Verifique saídas
list.files("resultados/csv/")
list.files("resultados/graficos/")
list.files("resultados/pdf/")
```

### Checklist de Qualidade

- [ ] Código segue o estilo do projeto
- [ ] Funções têm documentação (roxygen2)
- [ ] Exemplos funcionam
- [ ] Sem warnings no R CMD check
- [ ] README atualizado (se necessário)
- [ ] Testes manuais passaram
- [ ] Commit messages são claros

---

## 💬 Mensagens de Commit

### Formato Semântico

```
Tipo: Descrição curta (máx 50 caracteres)

Descrição detalhada opcional (máx 72 caracteres por linha)

Referências: #123
```

### Tipos de Commit

| Tipo | Uso | Exemplo |
|------|-----|---------|
| **Add** | Nova funcionalidade | `Add: função para análise longitudinal` |
| **Fix** | Correção de bug | `Fix: erro ao calcular alfa de Cronbach` |
| **Update** | Atualização de feature existente | `Update: melhorar visualização de gráficos` |
| **Refactor** | Refatoração sem mudar funcionalidade | `Refactor: simplificar função analisar_phq9()` |
| **Docs** | Apenas documentação | `Docs: adicionar exemplos ao README` |
| **Style** | Formatação, espaços | `Style: ajustar indentação` |
| **Test** | Adicionar testes | `Test: adicionar testes para validação` |
| **Chore** | Tarefas de manutenção | `Chore: atualizar .gitignore` |

### Exemplos de Boas Mensagens

```bash
# ✅ BOM
git commit -m "Add: suporte para análise por grupos demográficos"

# ✅ BOM (com corpo)
git commit -m "Fix: correção no cálculo da média ponderada

O cálculo estava usando sum() ao invés de weighted.mean(),
causando resultados incorretos para amostras com pesos diferentes.

Fixes #42"

# ❌ RUIM
git commit -m "correção"
git commit -m "mudanças"
git commit -m "update"
```

---

## 🌳 Branches

### Nomenclatura

```
feature/nome-da-feature    # Nova funcionalidade
fix/descricao-do-bug       # Correção de bug
docs/atualizacao-doc       # Documentação
refactor/melhoria-codigo   # Refatoração
```

### Exemplos

```bash
feature/analise-longitudinal
fix/erro-encoding-utf8
docs/tutorial-iniciantes
refactor/simplificar-graficos
```

---

## 🎯 Pull Requests

### Checklist Antes de Enviar

- [ ] Branch atualizada com `main`
- [ ] Código testado localmente
- [ ] Commits organizados e com mensagens claras
- [ ] README atualizado (se aplicável)
- [ ] Screenshots/exemplos incluídos (se visual)
- [ ] Sem conflitos com `main`

### Template de PR

```markdown
## Descrição
Breve descrição das mudanças

## Tipo de Mudança
- [ ] Bug fix
- [ ] Nova feature
- [ ] Breaking change
- [ ] Documentação

## Como Testar
1. Execute `source("scripts/...")`
2. Verifique que...
3. Compare com...

## Screenshots (se aplicável)
[Adicione imagens]

## Checklist
- [ ] Código segue o estilo do projeto
- [ ] Documentação atualizada
- [ ] Testes passaram
- [ ] Sem warnings
```

---

## ⚠️ Segurança e Privacidade

### CRÍTICO: Dados Sensíveis

**NUNCA faça commit de:**
- ❌ Dados reais de pacientes
- ❌ Informações identificáveis (nomes, CPF, etc.)
- ❌ Credenciais (senhas, tokens, API keys)
- ❌ Arquivos de configuração com dados sensíveis

### Verifique Antes de Commit

```bash
# Revise o que será commitado
git diff --staged

# Liste arquivos que serão incluídos
git status
```

### Se Commitar Dados Sensíveis Acidentalmente

```bash
# PARE imediatamente!
# NÃO faça push!

# Remova do último commit
git reset HEAD~1

# Ou use BFG Repo-Cleaner para histórico
# https://rtyley.github.io/bfg-repo-cleaner/
```

---

## 📞 Dúvidas?

- **Issues:** Para bugs e features
- **Discussions:** Para perguntas gerais
- **Email:** seu.email@exemplo.com (para questões sensíveis)

---

## 🌟 Reconhecimento

Contribuidores serão listados no README e terão seus nomes incluídos na seção de agradecimentos!

---

**Obrigado por contribuir! 🎉**
