# 🚀 INÍCIO RÁPIDO - PHQ-9 Análise

## ⚡ Em 3 Passos

### 1️⃣ Configurar Sistema (Primeira Vez Apenas)

```r
# Execute este comando no R/RStudio a partir da raiz do projeto
source("00_configuracao_inicial.R")
```

**O que faz:**
- ✅ Verifica versão do R
- ✅ Instala pacotes necessários
- ✅ Configura português brasileiro
- ✅ Cria estrutura de diretórios

---

### 2️⃣ Executar Análise

**Opção A: Dados Fictícios (Demonstração)**

```r
source("scripts/analise_phq9_basico.R")
```

**Opção B: Seus Próprios Dados**

```r
# 1. Carregar pacotes
library(tidyverse)

# 2. Carregar script
source("scripts/analise_phq9_avancado.R")

# 3. Carregar seus dados
meus_dados <- read_csv("dados/questionarios.csv")

# 4. Analisar
resultado <- analisar_phq9(meus_dados)
```

---

### 3️⃣ Ver Resultados e Gerar Relatórios

**Tabelas CSV:**
```
resultados/csv/
```

**Gráficos PNG:**
```
resultados/graficos/
```

**Gerar Relatório Básico (HTML + PDF):**
```r
source("scripts/relatorio_phq9_basico.R")
```

**Gerar Relatório Avançado (HTML + PDF):**
```r
source("scripts/relatorio_phq9_avancado.R")
```

**Localização dos relatórios gerados:**
- HTML: `resultados/html/`
- PDF: `resultados/pdf/`

**Observações:**
- Os scripts geram automaticamente HTML e PDF (se LaTeX estiver instalado)
- Para apenas HTML ou PDF, edite o script correspondente
- Relatórios também disponíveis como arquivos `.Rmd` em `relatorios/`

---

## 📋 Formato de Dados Necessário

Seu CSV deve ter estas colunas:

| Coluna | Tipo | Valores |
|--------|------|---------|
| idade | Número | 18-100 |
| sexo | Texto | "M" ou "F" |
| PHQ9_1 a PHQ9_9 | Número | 0, 1, 2 ou 3 |

**Exemplo:**
```csv
id,idade,sexo,PHQ9_1,PHQ9_2,PHQ9_3,PHQ9_4,PHQ9_5,PHQ9_6,PHQ9_7,PHQ9_8,PHQ9_9
1,25,F,0,1,2,1,0,0,1,0,0
2,42,M,1,0,0,0,1,1,0,0,0
```

Veja exemplo completo em: `dados/exemplo_dados_phq9.csv`

---

## 🆘 Problemas Comuns

### "Pacote não encontrado"
```r
install.packages("tidyverse")
install.packages("psych")
```

### "Coluna não encontrada"
→ Verifique nomes: `PHQ9_1`, `PHQ9_2`, etc. (case-sensitive)

### Acentos aparecem errados no Excel
→ Abra CSV no Excel: "Dados" → "De Texto" → "Latin 1"

### Não consigo gerar PDF
```r
install.packages("tinytex")
tinytex::install_tinytex()
```

### Erro: "caminhos não encontrados" ao gerar relatório
→ Execute sempre a partir da raiz do projeto (onde está o arquivo .Rproj)

---

## 📚 Onde Buscar Ajuda

- **Preso?** → Leia `README.md`
- **Dúvida específica?** → Veja `documentacao/guia_de_uso_avancado.txt`
- **Referência rápida?** → Consulte `documentacao/cheat_sheet.txt`
- **Como gerar relatórios?** → Leia `relatorios/INICIO_RAPIDO.md`

---

## 🎯 Resumo

1. **Configure** → `source("00_configuracao_inicial.R")`
2. **Analise** → `source("scripts/analise_phq9_basico.R")`
3. **Explore** → Arquivos em `resultados/`
4. **Relate** → `source("scripts/relatorio_phq9_basico.R")`

**Tempo total:** ~5 minutos (primeira vez) | ~30 segundos (próximas vezes)

---

✅ **Pronto!** Agora você tem análises profissionais do PHQ-9 em segundos.

**💡 Dica Importante:** Sempre execute os comandos a partir da raiz do projeto (onde está o arquivo .Rproj) para garantir que todos os caminhos funcionem corretamente.
