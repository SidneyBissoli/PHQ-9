# 🚀 Início Rápido - Relatórios PHQ-9

## ✅ Pré-requisitos

1. ✓ Abra o projeto através do arquivo **PHQ-9.Rproj**
2. ✓ Todos os caminhos são relativos à raiz do projeto (não precisa `setwd()`)
3. ✓ Execute primeiro a configuração inicial (apenas uma vez):
   ```r
   source("00_configuracao_inicial.R")
   ```

---

## 📊 Gerando Relatórios

### ⭐ Opção Recomendada: Scripts Automatizados

Os scripts automatizados geram **AMBOS** os formatos (HTML e PDF) e salvam nos diretórios corretos automaticamente.

#### Relatório Básico

```r
# 1. Execute a análise básica
source("scripts/analise_phq9_basico.R")

# 2. Gere os relatórios (HTML + PDF)
source("scripts/relatorio_phq9_basico.R")
```

**Resultado:**
- `resultados/html/relatorio_phq9_basico.html`
- `resultados/pdf/relatorio_phq9_basico.pdf`

#### Relatório Avançado

```r
# 1. Execute a análise avançada
source("scripts/analise_phq9_avancado.R")

# 2. Gere os relatórios (HTML + PDF)
source("scripts/relatorio_phq9_avancado.R")
```

**Resultado:**
- `resultados/html/relatorio_phq9_avancado.html`
- `resultados/pdf/relatorio_phq9_avancado.pdf`

---

### 🔧 Opção Alternativa: Manual

Se preferir gerar apenas um formato por vez:

#### Relatório Básico (Manual)

```r
# 1. Execute a análise
source("scripts/analise_phq9_basico.R")

# 2a. Gere apenas HTML
rmarkdown::render("relatorios/relatorio_phq9_basico.Rmd", 
                  output_format = "html_document",
                  output_dir = "resultados/html")

# 2b. OU gere apenas PDF (requer TinyTeX)
rmarkdown::render("relatorios/relatorio_phq9_basico.Rmd",
                  output_format = "pdf_document",
                  output_dir = "resultados/pdf")
```

#### Relatório Avançado (Manual)

```r
# 1. Execute a análise
source("scripts/analise_phq9_avancado.R")

# 2a. Gere apenas HTML
rmarkdown::render("relatorios/relatorio_phq9_avancado.Rmd", 
                  output_format = "html_document",
                  output_dir = "resultados/html")

# 2b. OU gere apenas PDF
rmarkdown::render("relatorios/relatorio_phq9_avancado.Rmd",
                  output_format = "pdf_document",
                  output_dir = "resultados/pdf")
```

---

## 💻 Instalar TinyTeX (para PDF) - Só 1 vez

Para gerar relatórios em PDF, você precisa ter LaTeX instalado:

```r
install.packages("tinytex")
tinytex::install_tinytex()
```

**Alternativa:** Se não quiser instalar LaTeX, os scripts automatizados detectam isso e geram apenas HTML.

---

## 📁 Estrutura do Projeto

```
PHQ-9/
├── PHQ-9.Rproj                 ← Sempre abra o projeto por aqui
├── 00_configuracao_inicial.R   ← Execute PRIMEIRO (só 1 vez)
│
├── scripts/
│   ├── analise_phq9_basico.R          ← Análise básica
│   ├── analise_phq9_avancado.R        ← Análise avançada
│   ├── relatorio_phq9_basico.R        ← Gera relatório básico
│   └── relatorio_phq9_avancado.R      ← Gera relatório avançado
│
├── relatorios/
│   ├── relatorio_phq9_basico.Rmd      ← Template básico
│   └── relatorio_phq9_avancado.Rmd    ← Template avançado
│
├── resultados/
│   ├── csv/                ← Tabelas geradas pelos scripts de análise
│   ├── graficos/           ← Gráficos gerados pelos scripts de análise
│   ├── html/               ← Relatórios HTML
│   │   ├── relatorio_phq9_basico.html
│   │   └── relatorio_phq9_avancado.html
│   └── pdf/                ← Relatórios PDF
│       ├── relatorio_phq9_basico.pdf
│       └── relatorio_phq9_avancado.pdf
│
└── documentacao/
    ├── cheat_sheet.txt
    └── guia_de_uso_avancado.txt
```

---

## 🎯 Fluxo Completo (Recomendado)

```r
# ========================================
# PRIMEIRA VEZ - Execute só uma vez
# ========================================
source("00_configuracao_inicial.R")

# ========================================
# ANÁLISE BÁSICA + RELATÓRIO
# ========================================

# Passo 1: Executar análise básica
source("scripts/analise_phq9_basico.R")
# Gera: 6 CSVs em resultados/csv/ + 6 gráficos em resultados/graficos/

# Passo 2: Gerar relatórios básicos
source("scripts/relatorio_phq9_basico.R")
# Gera: HTML e PDF em resultados/html/ e resultados/pdf/

# ========================================
# ANÁLISE AVANÇADA + RELATÓRIO
# ========================================

# Passo 3: Executar análise avançada
source("scripts/analise_phq9_avancado.R")
# Gera: 5 CSVs em resultados/csv/ + 6 gráficos em resultados/graficos/

# Passo 4: Gerar relatórios avançados
source("scripts/relatorio_phq9_avancado.R")
# Gera: HTML e PDF em resultados/html/ e resultados/pdf/
```

---

## 💡 Dicas

- ✅ **Sempre use os scripts automatizados** (mais fácil e confiável)
- ✅ Use o .Rproj - não precisa configurar diretórios manualmente
- ✅ HTML é mais rápido e não precisa de LaTeX
- ✅ PDF é melhor para impressão e arquivamento formal
- ✅ Os scripts automatizados detectam se LaTeX está instalado
- ✅ Execute a análise ANTES de gerar o relatório
- ✅ Relatórios são salvos em `resultados/html/` e `resultados/pdf/`

---

## 🔧 Solução de Problemas

### Erro: "Execute primeiro o script de análise..."

**Causa:** O script de análise não foi executado  
**Solução:** Execute o script de análise correspondente:
```r
source("scripts/analise_phq9_basico.R")
# OU
source("scripts/analise_phq9_avancado.R")
```

### Erro: "LaTeX not found"

**Causa:** LaTeX não está instalado  
**Solução 1:** Instale TinyTeX:
```r
install.packages("tinytex")
tinytex::install_tinytex()
```

**Solução 2:** Use apenas HTML (scripts automatizados fazem isso automaticamente)

### Erro: "Gráficos não aparecem no relatório"

**Causa:** Arquivos PNG não foram gerados  
**Solução:** Verifique se o script de análise foi executado completamente:
```r
# Liste os arquivos gerados
list.files("resultados/graficos/")
list.files("resultados/csv/")
```

### Erro: "Arquivo não encontrado"

**Causa:** Você não está no diretório correto  
**Solução:** 
1. Feche todos os scripts
2. Abra o projeto pelo arquivo **PHQ-9.Rproj**
3. Verifique: `getwd()` deve mostrar o caminho para a pasta PHQ-9/

### Erro: "Pacote não encontrado"

**Causa:** Pacotes necessários não estão instalados  
**Solução:**
```r
source("00_configuracao_inicial.R")
```

---

## 📋 Comparação: Scripts Automatizados vs Manual

| Característica | Scripts Automatizados | Manual |
|---------------|----------------------|--------|
| **Comando** | `source("scripts/relatorio_phq9_basico.R")` | `rmarkdown::render(...)` |
| **Formatos gerados** | HTML + PDF (ambos) | Um por vez |
| **Localização saída** | `resultados/html/` e `resultados/pdf/` | Especificar manualmente |
| **Detecta LaTeX** | Sim (gera apenas HTML se não tiver) | Não |
| **Limpa temporários** | Sim (automático) | Não |
| **Verifica arquivos** | Sim (mostra erros claros) | Não |
| **Facilidade** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Recomendado?** | ✅ **SIM** | Apenas para casos especiais |

---

## 🎓 Diferença entre Básico e Avançado

### Análise Básica
- ✓ Estatísticas descritivas
- ✓ Análise por sexo e idade
- ✓ Distribuição de severidade
- ✓ Alfa de Cronbach
- ✓ 6 visualizações
- ⏱️ Tempo: ~30 segundos
- 👤 **Ideal para:** Primeira análise, relatórios rápidos

### Análise Avançada
- ✓ Tudo da básica +
- ✓ Função reutilizável `analisar_phq9()`
- ✓ Análise item por item (detalhada)
- ✓ Teste t (comparação entre sexos)
- ✓ Correlações (idade vs escore)
- ✓ Top 3 sintomas mais prevalentes
- ✓ Relatório executivo
- ⏱️ Tempo: ~45 segundos
- 👤 **Ideal para:** Publicações, análises comparativas

---

**Boa análise!** 📊🎯

---

**Versão:** 2.0  
**Última atualização:** Novembro 2025  
**Compatível com:** Estrutura de projeto versão 3.0
