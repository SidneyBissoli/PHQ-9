# 📂 Pasta: scripts/

## Propósito

Esta pasta contém os scripts R para análise e geração de relatórios dos dados do PHQ-9.

---

## Scripts de Análise Disponíveis

### 🔵 `analise_phq9_basico.R`

**Nível:** Iniciante  
**Complexidade:** Básica  
**Tempo de execução:** ~30 segundos

#### O que faz:
- ✅ Calcula escores totais
- ✅ Categoriza severidade
- ✅ Estatísticas descritivas
- ✅ Análise por sexo e idade
- ✅ Alfa de Cronbach
- ✅ 6 gráficos profissionais

#### Quando usar:
- Primeira análise de dados PHQ-9
- Precisa de resultados rápidos
- Relatório simples e direto

#### Como executar:
```r
source("scripts/analise_phq9_basico.R")
```

#### Saídas geradas:
- 6 arquivos CSV em `resultados/csv/`
- 6 gráficos PNG (300 DPI) em `resultados/graficos/`
- Resumo no console

---

### 🔴 `analise_phq9_avancado.R`

**Nível:** Intermediário/Avançado  
**Complexidade:** Completa  
**Tempo de execução:** ~45 segundos

#### O que faz:
- ✅ Tudo do script básico +
- ✅ **Função reutilizável** `analisar_phq9()`
- ✅ Análise item por item
- ✅ Teste t (comparação sexos)
- ✅ Correlações (idade x escore)
- ✅ Top 3 sintomas mais prevalentes
- ✅ Relatório executivo

#### Quando usar:
- Análises para publicação
- Comparar grupos
- Identificar sintomas prevalentes
- Processar múltiplos datasets

#### Como executar:

**Opção 1: Com dados fictícios**
```r
source("scripts/analise_phq9_avancado.R")
```

**Opção 2: Com seus dados**
```r
# Primeiro, carregue o script
source("scripts/analise_phq9_avancado.R")

# Depois, use a função
library(tidyverse)
meus_dados <- read_csv("dados/questionarios.csv")
resultado <- analisar_phq9(meus_dados)
```

**Opção 3: Múltiplos estudos**
```r
source("scripts/analise_phq9_avancado.R")

# Estudo 1
dados1 <- read_csv("dados/estudo1.csv")
res1 <- analisar_phq9(dados1, prefixo_arquivo = "Estudo1")

# Estudo 2
dados2 <- read_csv("dados/estudo2.csv")
res2 <- analisar_phq9(dados2, prefixo_arquivo = "Estudo2")
```

#### Saídas geradas:
- 5 arquivos CSV em `resultados/csv/` (mais detalhados)
- 6 gráficos PNG (300 DPI) em `resultados/graficos/`
- Resumo expandido no console

---

## Scripts de Geração de Relatórios

### 📄 `relatorio_phq9_basico.R`

**Propósito:** Gera relatório automático da análise básica

#### O que faz:
- Gera relatório em PDF e HTML
- Inclui análises descritivas
- Apresenta gráficos e tabelas
- Interpretação clínica dos resultados

#### Como executar:
```r
# IMPORTANTE: Execute APÓS rodar analise_phq9_basico.R
source("scripts/relatorio_phq9_basico.R")
```

#### Saídas geradas:
- `resultados/pdf/relatorio_phq9_basico.pdf`
- `resultados/html/relatorio_phq9_basico.html`

#### Pré-requisitos:
- Ter executado `analise_phq9_basico.R` antes
- TinyTeX instalado (para PDF)
  ```r
  install.packages("tinytex")
  tinytex::install_tinytex()
  ```

---

### 📊 `relatorio_phq9_avancado.R`

**Propósito:** Gera relatório automático da análise avançada

#### O que faz:
- Tudo do relatório básico +
- Análise item por item
- Testes estatísticos inferenciais
- Comparações entre grupos
- Top 3 sintomas prevalentes

#### Como executar:
```r
# IMPORTANTE: Execute APÓS rodar analise_phq9_avancado.R
source("scripts/relatorio_phq9_avancado.R")
```

#### Saídas geradas:
- `resultados/pdf/relatorio_phq9_avancado.pdf`
- `resultados/html/relatorio_phq9_avancado.html`

#### Pré-requisitos:
- Ter executado `analise_phq9_avancado.R` antes
- TinyTeX instalado (para PDF)

---

## Função `analisar_phq9()` (Script Avançado)

### Sintaxe Completa

```r
resultado <- analisar_phq9(
  dados,                    # Seu dataframe (obrigatório)
  gerar_graficos = TRUE,    # Criar gráficos? (padrão: TRUE)
  salvar_resultados = TRUE, # Salvar CSVs? (padrão: TRUE)
  prefixo_arquivo = "PHQ9"  # Prefixo dos arquivos (padrão: "PHQ9")
)
```

### Parâmetros

| Parâmetro | Tipo | Padrão | Descrição |
|-----------|------|--------|-----------|
| `dados` | dataframe | - | Seus dados do PHQ-9 |
| `gerar_graficos` | lógico | TRUE | Se TRUE, cria e salva gráficos |
| `salvar_resultados` | lógico | TRUE | Se TRUE, salva arquivos CSV |
| `prefixo_arquivo` | texto | "PHQ9" | Prefixo para nomes de arquivo |

### Exemplos de Uso

```r
# 1. Uso padrão (mais comum)
resultado <- analisar_phq9(meus_dados)

# 2. Apenas processar, sem salvar
resultado <- analisar_phq9(meus_dados, 
                           gerar_graficos = FALSE,
                           salvar_resultados = FALSE)

# 3. Com prefixo personalizado
resultado <- analisar_phq9(meus_dados, 
                           prefixo_arquivo = "Clinica_2025")
# Gera: Clinica_2025_dados_processados.csv, etc.
```

### Retorno

A função retorna um dataframe com:
- Todas as colunas originais
- `escore_total` (soma dos 9 itens)
- `severidade` (categoria)
- `faixa_etaria` (grupos de idade)

---

## Workflow Completo Recomendado

### Para Análise Básica:
```r
# 1. Executar análise
source("scripts/analise_phq9_basico.R")

# 2. Gerar relatório
source("scripts/relatorio_phq9_basico.R")

# 3. Verificar resultados
# - CSV: resultados/csv/
# - Gráficos: resultados/graficos/
# - Relatórios: resultados/pdf/ e resultados/html/
```

### Para Análise Avançada:
```r
# 1. Executar análise
source("scripts/analise_phq9_avancado.R")

# 2. Gerar relatório
source("scripts/relatorio_phq9_avancado.R")

# 3. Verificar resultados
# - CSV: resultados/csv/
# - Gráficos: resultados/graficos/
# - Relatórios: resultados/pdf/ e resultados/html/
```

---

## Configurações Importantes

### Encoding para Português

Ambos os scripts estão configurados para português brasileiro:

```r
# Locale
Sys.setlocale("LC_ALL", "pt_BR.UTF-8")

# Encoding para Excel
ENCODING_EXPORT <- "latin1"  # Altere para "UTF-8" se necessário
```

### Personalizar Análises

**Alterar tamanho da amostra fictícia:**
```r
# Procure por essa linha no script
n_respondentes <- 500  # Altere para o valor desejado
```

**Modificar faixas etárias:**
```r
faixa_etaria = case_when(
  idade >= 18 & idade < 25 ~ "18-24 anos",  # Modifique aqui
  idade >= 25 & idade < 35 ~ "25-34 anos",
  # Adicione mais faixas...
)
```

**Mudar cores dos gráficos:**
```r
# Procure por scale_fill_manual()
scale_fill_manual(values = c(
  "Mínima" = "#2ecc71",        # Verde
  "Leve" = "#f39c12",          # Laranja claro
  "Moderada" = "#e67e22",      # Laranja
  "Moderadamente Grave" = "#e74c3c",  # Vermelho claro
  "Grave" = "#c0392b"          # Vermelho escuro
))
```

---

## Comparação: Qual Script Usar?

| Critério | Script Básico | Script Avançado |
|----------|---------------|-----------------|
| **Complexidade** | Simples | Completa |
| **Função reutilizável** | ❌ Não | ✅ Sim |
| **Análises bivariadas** | ❌ Não | ✅ Sim (teste t, correlações) |
| **Análise por item** | Básica | ✅ Detalhada (prevalência) |
| **Múltiplos datasets** | Difícil | ✅ Fácil (função) |
| **Relatório automático** | ✅ Sim | ✅ Sim (mais completo) |
| **Para publicação** | ⚠️ Limitado | ✅ Completo |
| **Tempo de execução** | ~30s | ~45s |
| **Arquivos gerados** | 6 CSV + 6 PNG | 5 CSV + 6 PNG |

### Recomendação

- **Iniciante ou primeira análise?** → Use Script Básico
- **Análise para artigo científico?** → Use Script Avançado
- **Precisa comparar grupos?** → Use Script Avançado
- **Vai analisar múltiplos estudos?** → Use Script Avançado
- **Quer relatório profissional?** → Ambos têm (escolha pelo nível)

---

## Solução de Problemas

### Erro: "Pacote não encontrado"
```r
# Instalar manualmente
install.packages("tidyverse")
install.packages("psych")
install.packages("knitr")
install.packages("rmarkdown")
```

### Erro: "Coluna não encontrada"
- Verifique os nomes das colunas no seu CSV
- Use exatamente: `PHQ9_1`, `PHQ9_2`, ..., `PHQ9_9`

### Erro: "Função analisar_phq9 não encontrada"
```r
# Execute o script primeiro para carregar a função
source("scripts/analise_phq9_avancado.R")
```

### Problemas com acentos
- Altere `ENCODING_EXPORT` para "UTF-8" no início do script
- Ou use "CP1252" para Windows

### Erro ao gerar PDF: "LaTeX Error"
```r
# Instalar TinyTeX
install.packages("tinytex")
tinytex::install_tinytex()

# Se persistir, gere apenas HTML
# Edite o script de relatório e comente a linha do PDF
```

### Erro: "Arquivo não encontrado" ao gerar relatório
- **Certifique-se** de executar o script de análise ANTES do relatório
- Os relatórios dependem dos arquivos CSV gerados pela análise

---

## Arquivos Relacionados

### Templates R Markdown (pasta `/relatorios/`)
- `relatorio_phq9_basico.Rmd` - Template do relatório básico
- `relatorio_phq9_avancado.Rmd` - Template do relatório avançado

### Documentação (pasta `/documentacao/`)
- Guias de uso detalhados
- Instruções de configuração
- Exemplos práticos

---

## Estrutura de Arquivos Gerados

```
PHQ-9/
├── resultados/
│   ├── csv/                      # Arquivos de dados
│   │   ├── PHQ9_dados_processados.csv
│   │   ├── PHQ9_estatisticas_*.csv
│   │   └── ...
│   ├── graficos/                 # Visualizações
│   │   ├── PHQ9_distribuicao_severidade.png
│   │   ├── PHQ9_medias_idade.png
│   │   └── ...
│   ├── pdf/                      # Relatórios PDF
│   │   ├── relatorio_phq9_basico.pdf
│   │   └── relatorio_phq9_avancado.pdf
│   └── html/                     # Relatórios HTML
│       ├── relatorio_phq9_basico.html
│       └── relatorio_phq9_avancado.html
```

---

## Próximos Passos

Após executar um script:

1. ✅ Verifique os arquivos CSV em `resultados/csv/`
2. ✅ Veja os gráficos em `resultados/graficos/`
3. ✅ Gere o relatório: `source("scripts/relatorio_phq9_*.R")`
4. ✅ Abra os relatórios em `resultados/pdf/` ou `resultados/html/`

---

**Dúvidas?** Consulte a documentação completa em `/documentacao/`
