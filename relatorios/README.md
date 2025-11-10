# 📊 Relatórios PHQ-9

Este diretório contém os **templates RMarkdown** para geração automática de relatórios de análise do PHQ-9, além dos **scripts automatizados** que facilitam a geração dos relatórios.

---

## 📄 Arquivos Disponíveis

### 🔵 Análise Básica

#### `relatorio_phq9_basico.Rmd`
Template RMarkdown compatível com `scripts/analise_phq9_basico.R`

**Conteúdo:**
- Sumário executivo
- Caracterização da amostra (n, idade, sexo)
- Estatísticas descritivas gerais
- Distribuição de severidade
- Análise por sexo e faixas etárias
- Estatísticas por item (PHQ9_1 a PHQ9_9)
- Alfa de Cronbach (confiabilidade)
- 6 visualizações profissionais
- Conclusões e referências bibliográficas

---

### 🔴 Análise Avançada

#### `relatorio_phq9_avancado.Rmd`
Template RMarkdown compatível com `scripts/analise_phq9_avancado.R`

**Conteúdo:**
- **Tudo do relatório básico, MAIS:**
- Análise item por item (detalhada com prevalências)
- Top 3 sintomas mais comuns
- Análises bivariadas:
  - Teste t (comparação entre sexos)
  - Correlações (idade vs escore, por sexo)
- Tamanho do efeito (d de Cohen)
- Visualizações avançadas e sofisticadas
- Relatório executivo consolidado
- Apêndice técnico completo

---

## 🚀 Como Usar

### ⭐ Método Recomendado: Scripts Automatizados

Os scripts automatizados na pasta `scripts/` geram **AMBOS** os formatos (HTML e PDF) automaticamente e salvam nos diretórios corretos.

#### Passo 1: Executar Análise

```r
# Para análise básica
source("scripts/analise_phq9_basico.R")

# OU para análise avançada
source("scripts/analise_phq9_avancado.R")
```

#### Passo 2: Gerar Relatórios

```r
# Para relatório básico
source("scripts/relatorio_phq9_basico.R")
# Gera: resultados/html/relatorio_phq9_basico.html
#       resultados/pdf/relatorio_phq9_basico.pdf

# OU para relatório avançado
source("scripts/relatorio_phq9_avancado.R")
# Gera: resultados/html/relatorio_phq9_avancado.html
#       resultados/pdf/relatorio_phq9_avancado.pdf
```

**Vantagens dos scripts automatizados:**
- ✅ Gera HTML e PDF de uma vez
- ✅ Salva nos diretórios corretos automaticamente
- ✅ Verifica se arquivos necessários existem
- ✅ Detecta se LaTeX está instalado
- ✅ Limpa arquivos temporários automaticamente
- ✅ Mostra progresso e tamanho dos arquivos

---

### 🔧 Método Manual (Alternativo)

Se preferir controle manual sobre cada formato:

#### Relatório Básico

```r
# Pré-requisito: executar a análise primeiro
source("scripts/analise_phq9_basico.R")

# Para HTML
rmarkdown::render("relatorios/relatorio_phq9_basico.Rmd", 
                  output_format = "html_document",
                  output_dir = "resultados/html")

# Para PDF (requer LaTeX/TinyTeX)
rmarkdown::render("relatorios/relatorio_phq9_basico.Rmd",
                  output_format = "pdf_document",
                  output_dir = "resultados/pdf")
```

#### Relatório Avançado

```r
# Pré-requisito: executar a análise primeiro
source("scripts/analise_phq9_avancado.R")

# Para HTML
rmarkdown::render("relatorios/relatorio_phq9_avancado.Rmd", 
                  output_format = "html_document",
                  output_dir = "resultados/html")

# Para PDF
rmarkdown::render("relatorios/relatorio_phq9_avancado.Rmd",
                  output_format = "pdf_document",
                  output_dir = "resultados/pdf")
```

---

## 💻 Instalação do LaTeX (para PDF)

Para gerar relatórios em PDF, você precisa ter LaTeX instalado.

### Opção 1: TinyTeX (Recomendado - mais leve)

```r
install.packages("tinytex")
tinytex::install_tinytex()
```

**Vantagens:** Instalação simples, leve (~100 MB), mantido automaticamente

### Opção 2: Distribuições LaTeX completas

- **Windows:** [MiKTeX](https://miktex.org/download) (~200 MB)
- **Mac:** [MacTeX](https://www.tug.org/mactex/) (~4 GB)
- **Linux:** `sudo apt-get install texlive-full` (~5 GB)

### Opção 3: Sem LaTeX - usar apenas HTML

Se não quiser instalar LaTeX:
1. Use apenas HTML nos scripts (automático se LaTeX não instalado)
2. Abra o HTML no navegador
3. Use: **Arquivo → Imprimir → Salvar como PDF**

Resultado: PDF de alta qualidade sem instalar LaTeX!

---

## 📁 Estrutura de Dependências

Os relatórios dependem de arquivos gerados pelos scripts de análise:

### Relatório Básico necessita de:

#### CSVs (em `resultados/csv/`):
```
resultados/csv/
├── PHQ9_BAS_dados_processados.csv        ← Dataset completo processado
├── PHQ9_BAS_estatisticas_descritivas.csv ← Estatísticas gerais
├── PHQ9_BAS_distribuicao_severidade.csv  ← Contagem por categoria
├── PHQ9_BAS_analise_sexo.csv             ← Comparação M vs F
├── PHQ9_BAS_faixas_etarias.csv           ← Análise por idade
└── PHQ9_BAS_confiabilidade.csv           ← Alfa de Cronbach
```

#### Gráficos (em `resultados/graficos/`):
```
resultados/graficos/
├── PHQ9_BAS_1_distribuicao_escores.png   ← Histograma
├── PHQ9_BAS_2_severidade_barras.png      ← Categorias
├── PHQ9_BAS_3_comparacao_sexos.png       ← Boxplot M vs F
├── PHQ9_BAS_4_idade_dispersao.png        ← Idade vs escore
├── PHQ9_BAS_5_faixas_etarias.png         ← Violin plots
└── PHQ9_BAS_6_heatmap_itens.png          ← Correlações
```

---

### Relatório Avançado necessita de:

#### CSVs (em `resultados/csv/`):
```
resultados/csv/
├── PHQ9_analise_dados_processados.csv    ← Dataset completo
├── PHQ9_analise_itens_detalhada.csv      ← Estatísticas por item
├── PHQ9_analise_bivariada.csv            ← Testes estatísticos
├── PHQ9_confiabilidade.csv               ← Alfa de Cronbach
└── PHQ9_relatorio_executivo.csv          ← Resumo executivo
```

#### Gráficos (em `resultados/graficos/`):
```
resultados/graficos/
├── PHQ9_AVA_1_analise_itens.png          ← Média por item
├── PHQ9_AVA_2_comparacao_sexos.png       ← Boxplot + teste t
├── PHQ9_AVA_3_idade_escore_dispersao.png ← Dispersão + correlação
├── PHQ9_AVA_4_heatmap_respostas.png      ← Padrão de respostas
├── PHQ9_AVA_5_severidade_sexo_prop.png   ← Proporções por sexo
└── PHQ9_AVA_6_violin_faixa_etaria.png    ← Violin plots
```

---

## 🔧 Solução de Problemas

### ❌ Erro: "Execute primeiro o script de análise..."

**Causa:** O script de análise correspondente não foi executado.

**Solução:** Execute o script de análise antes de gerar o relatório:
```r
# Para relatório básico
source("scripts/analise_phq9_basico.R")

# Para relatório avançado
source("scripts/analise_phq9_avancado.R")
```

**Como verificar:** Liste os arquivos gerados:
```r
list.files("resultados/csv/")
list.files("resultados/graficos/")
```

---

### ❌ Erro: "LaTeX not found"

**Causa:** LaTeX não está instalado no sistema.

**Solução 1 (Recomendada):** Instale TinyTeX:
```r
install.packages("tinytex")
tinytex::install_tinytex()
```

**Solução 2:** Use apenas HTML (scripts automatizados fazem isso):
```r
source("scripts/relatorio_phq9_basico.R")
# Se LaTeX não instalado, gera apenas HTML automaticamente
```

**Solução 3:** Gere HTML e converta para PDF no navegador:
1. Abra o HTML gerado no navegador
2. **Arquivo → Imprimir → Salvar como PDF**
3. Ajuste margens se necessário

---

### ❌ Erro: "Arquivo [X] não encontrado"

**Causa:** Arquivos CSV ou gráficos não foram gerados.

**Diagnóstico:**
```r
# Verifique o que foi gerado
list.files("resultados/csv/")
list.files("resultados/graficos/")

# Conte quantos arquivos existem
length(list.files("resultados/csv/"))      # Deve ter 5-6
length(list.files("resultados/graficos/")) # Deve ter 6
```

**Solução:** Execute o script de análise completamente:
```r
source("scripts/analise_phq9_basico.R")
# Aguarde até aparecer "Análise concluída com sucesso!"
```

---

### ❌ Gráficos não aparecem no relatório

**Causa 1:** Arquivos PNG não foram gerados corretamente.

**Solução:**
```r
# Re-execute o script de análise
source("scripts/analise_phq9_basico.R")

# Verifique se os PNGs existem
list.files("resultados/graficos/", pattern = "\\.png$")
```

**Causa 2:** Caminho incorreto no .Rmd.

**Solução:** Verifique que você está usando o projeto .Rproj:
```r
getwd()  # Deve mostrar o caminho para PHQ-9/
```

---

### ❌ Erro: "Pandoc not found"

**Causa:** Pandoc não está instalado.

**Solução:** Use RStudio (já inclui Pandoc) ou instale:
- Windows/Mac: https://pandoc.org/installing.html
- Linux: `sudo apt-get install pandoc`

---

### ❌ Caracteres com acentuação aparecem errados no PDF

**Causa:** Problema de encoding LaTeX.

**Solução:** Os templates já estão configurados corretamente com:
```yaml
output:
  pdf_document:
    latex_engine: xelatex
```

Se ainda houver problema, verifique:
```r
Sys.getlocale()  # Deve incluir "UTF-8"
```

---

## 💡 Dicas e Boas Práticas

### Workflow Recomendado

```r
# 1️⃣ Primeira vez - Configure o projeto (só uma vez)
source("00_configuracao_inicial.R")

# 2️⃣ Execute a análise
source("scripts/analise_phq9_basico.R")
# OU
source("scripts/analise_phq9_avancado.R")

# 3️⃣ Gere os relatórios
source("scripts/relatorio_phq9_basico.R")
# OU
source("scripts/relatorio_phq9_avancado.R")

# 4️⃣ Pronto! Veja os resultados em:
# - resultados/html/
# - resultados/pdf/
```

### Personalização dos Templates

1. **Para alterar textos:** Edite os arquivos .Rmd diretamente
2. **Para adicionar seções:** Adicione novos chunks de código
3. **Para mudar formatação:** Modifique o YAML header
4. **Para incluir logo:** Adicione no YAML:
   ```yaml
   output:
     pdf_document:
       includes:
         in_header: header.tex
   ```

### Dicas de Apresentação

- ✅ **HTML** é melhor para:
  - Apresentações online
  - Compartilhamento rápido
  - Visualização em diferentes dispositivos
  - Gráficos interativos (futuro)

- ✅ **PDF** é melhor para:
  - Documentação formal
  - Arquivamento
  - Impressão
  - Submissão para publicações

### Performance

- Para amostras grandes (>5000):
  - HTML é mais rápido (~30 segundos)
  - PDF pode demorar 1-2 minutos

- Use `knitr` cache para relatórios complexos:
  ```yaml
  output:
    html_document:
      cache: true
  ```

---

## 📝 Customização Avançada

### Alterar tema do HTML

No YAML header do .Rmd:
```yaml
output:
  html_document:
    theme: flatly  # Opções: default, cerulean, journal, flatly, etc.
```

### Adicionar índice (TOC)

```yaml
output:
  html_document:
    toc: true
    toc_float: true
    toc_depth: 3
```

### Personalizar PDF

```yaml
output:
  pdf_document:
    toc: true
    number_sections: true
    fig_caption: true
    keep_tex: false
```

---

## 📄 Saída dos Relatórios

Os relatórios gerados são salvos em:

### HTML
- **Localização:** `resultados/html/`
- **Arquivos:**
  - `relatorio_phq9_basico.html`
  - `relatorio_phq9_avancado.html`
- **Tamanho típico:** 500 KB - 2 MB
- **Abrir com:** Qualquer navegador

### PDF
- **Localização:** `resultados/pdf/`
- **Arquivos:**
  - `relatorio_phq9_basico.pdf`
  - `relatorio_phq9_avancado.pdf`
- **Tamanho típico:** 800 KB - 3 MB
- **Abrir com:** Adobe Reader, navegador, visualizador PDF

---

## 📚 Recursos Adicionais

### Documentação Completa
- Ver: `documentacao/guia_de_uso_avancado.txt`
- Referência rápida: `documentacao/cheat_sheet.txt`

### RMarkdown
- Site oficial: https://rmarkdown.rstudio.com/
- Galeria: https://rmarkdown.rstudio.com/gallery.html
- Livro: https://bookdown.org/yihui/rmarkdown/

### Customização Visual
- HTML themes: https://bootswatch.com/
- Pacote: https://cran.r-project.org/web/packages/prettydoc/

---

## 🎓 Comparação: Básico vs Avançado

| Característica | Básico | Avançado |
|---------------|--------|----------|
| **Páginas** | 8-10 | 12-15 |
| **Estatísticas** | Descritivas | Descritivas + Inferenciais |
| **Testes** | Alfa de Cronbach | Alfa + Teste t + Correlações |
| **Análise de itens** | Resumo | Detalhada com prevalências |
| **Visualizações** | 6 gráficos | 6 gráficos avançados |
| **Tempo geração** | ~30 seg | ~45 seg |
| **Uso recomendado** | Primeira análise | Publicações científicas |
| **Relatório executivo** | Não | Sim |
| **Interpretações** | Básicas | Completas com contexto |

---

## ⚠️ Observações Importantes

1. **Sempre** abra o projeto pelo arquivo **PHQ-9.Rproj** para garantir caminhos corretos
2. Execute o script de **análise ANTES** de gerar o relatório
3. Os templates usam **caminhos relativos** - não use `setwd()`
4. Verifique que todos os arquivos necessários foram gerados antes de gerar relatório
5. Para **dados reais**, modifique os scripts de análise, não os templates .Rmd

---

## 🔒 Segurança e Privacidade

- ⚠️ Relatórios podem conter **dados sensíveis** de saúde mental
- Sempre **anonimize** dados antes de compartilhar
- Não inclua informações identificáveis nos relatórios
- Siga a **LGPD** e regulamentações locais
- Use **senhas** ao compartilhar PDFs com dados sensíveis:
  ```r
  # Proteger PDF com senha (usando pacote qpdf)
  system('qpdf --encrypt "senha" "senha" 128 -- input.pdf output.pdf')
  ```

---

**Última atualização:** Novembro 2025  
**Versão:** 2.0  
**Compatível com:** Estrutura de projeto versão 3.0  
**Mantido por:** Equipe PHQ-9 Analysis System
