# 📊 PHQ-9 Statistical Analysis System

[![R Version](https://img.shields.io/badge/R-%E2%89%A54.0-blue.svg)](https://www.r-project.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status: Active](https://img.shields.io/badge/Status-Active-success.svg)]()
[![Language: Portuguese](https://img.shields.io/badge/Language-PT--BR-green.svg)]()

> **Sistema profissional de análise estatística para dados do questionário PHQ-9 (Patient Health Questionnaire-9) de avaliação de depressão.**

---

## 📑 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Funcionalidades](#-funcionalidades)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Instalação](#-instalação)
- [Uso Rápido](#-uso-rápido)
- [Exemplos](#-exemplos)
- [Documentação](#-documentação)
- [Contribuindo](#-contribuindo)
- [Licença](#-licença)
- [Contato](#-contato)

---

## 🎯 Sobre o Projeto

O **PHQ-9 Statistical Analysis System** é um conjunto de ferramentas em R para análise completa de dados do questionário PHQ-9, amplamente utilizado para rastreamento e monitoramento de sintomas depressivos.

### Características Principais

- ✅ **Análise Básica e Avançada** - Dois níveis de complexidade
- ✅ **Geração Automática de Relatórios** - PDF e HTML profissionais
- ✅ **Função Reutilizável** - `analisar_phq9()` para múltiplos datasets
- ✅ **Visualizações Profissionais** - 6 gráficos de alta qualidade (300 DPI)
- ✅ **Testes Estatísticos** - t-test, correlações, Cronbach's alpha
- ✅ **Locale PT-BR** - Configurado para português brasileiro
- ✅ **Documentação Completa** - Guias detalhados e exemplos

### Público-Alvo

- Psicólogos e profissionais de saúde mental
- Pesquisadores em saúde pública
- Estudantes de psicologia e estatística
- Analistas de dados em saúde

---

## ⚡ Funcionalidades

### Análise Básica (`analise_phq9_basico.R`)

- Cálculo de escores totais (0-27)
- Categorização de severidade (Mínima, Leve, Moderada, Moderadamente Grave, Grave)
- Estatísticas descritivas (média, mediana, DP)
- Análise por sexo e faixas etárias
- Alfa de Cronbach (confiabilidade)
- 6 gráficos profissionais

### Análise Avançada (`analise_phq9_avancado.R`)

- **Tudo da análise básica +**
- Função reutilizável `analisar_phq9()`
- Análise item por item (prevalência)
- Teste t para comparação entre grupos
- Correlação idade × escore
- Top 3 sintomas mais prevalentes
- Estatísticas por faixa etária

### Relatórios Automáticos

- **Básico**: `relatorio_phq9_basico.R` → PDF/HTML
- **Avançado**: `relatorio_phq9_avancado.R` → PDF/HTML
- Inclui tabelas, gráficos e interpretação clínica
- Formatação profissional para publicação

---

## 📂 Estrutura do Projeto

```
PHQ-9/
├── 00_configuracao_inicial.R    # Setup: instala pacotes e cria estrutura
├── PHQ-9.Rproj                  # Projeto RStudio
│
├── scripts/                     # Scripts de análise
│   ├── analise_phq9_basico.R
│   ├── analise_phq9_avancado.R
│   ├── relatorio_phq9_basico.R
│   ├── relatorio_phq9_avancado.R
│   └── README.md
│
├── relatorios/                  # Templates R Markdown
│   ├── relatorio_phq9_basico.Rmd
│   └── relatorio_phq9_avancado.Rmd
│
├── dados/                       # Dados de entrada
│   └── exemplo_phq9.csv
│
├── resultados/                  # Saídas geradas
│   ├── csv/                     # Tabelas processadas
│   ├── graficos/                # Visualizações PNG
│   ├── pdf/                     # Relatórios PDF
│   └── html/                    # Relatórios HTML
│
└── documentacao/                # Guias e manuais
    ├── cheat_sheet.txt
    └── guia_de_uso_avancado.txt
```

---

## 🔧 Instalação

### Pré-requisitos

- R ≥ 4.0
- RStudio (recomendado)
- Pacotes: `tidyverse`, `psych`, `knitr`, `rmarkdown`

### Setup Rápido

```r
# 1. Clone o repositório
git clone https://github.com/SEU_USUARIO/PHQ-9.git
cd PHQ-9

# 2. Abra o projeto no RStudio
# Clique em PHQ-9.Rproj

# 3. Execute o script de configuração
source("00_configuracao_inicial.R")
```

O script `00_configuracao_inicial.R` automaticamente:
- ✅ Instala todos os pacotes necessários
- ✅ Cria estrutura de diretórios
- ✅ Configura locale para PT-BR

### Instalação Manual de Pacotes

```r
install.packages(c("tidyverse", "psych", "knitr", "rmarkdown"))

# Para geração de PDF
install.packages("tinytex")
tinytex::install_tinytex()
```

---

## 🚀 Uso Rápido

### Análise Básica com Dados Fictícios

```r
# Executa análise básica
source("scripts/analise_phq9_basico.R")

# Gera relatório
source("scripts/relatorio_phq9_basico.R")
```

### Análise com Seus Dados

```r
# 1. Carregue o script avançado
source("scripts/analise_phq9_avancado.R")

# 2. Importe seus dados
library(tidyverse)
meus_dados <- read_csv("dados/meus_questionarios.csv")

# 3. Execute a análise
resultado <- analisar_phq9(meus_dados)

# 4. Gere o relatório
source("scripts/relatorio_phq9_avancado.R")
```

### Formato dos Dados

Seu CSV deve conter as colunas:

```
id, idade, sexo, PHQ9_1, PHQ9_2, PHQ9_3, PHQ9_4, PHQ9_5, PHQ9_6, PHQ9_7, PHQ9_8, PHQ9_9
```

**Exemplo:**
```csv
id,idade,sexo,PHQ9_1,PHQ9_2,PHQ9_3,PHQ9_4,PHQ9_5,PHQ9_6,PHQ9_7,PHQ9_8,PHQ9_9
1,25,F,2,1,1,0,2,1,1,0,1
2,34,M,0,0,1,1,0,0,0,0,0
```

---

## 💡 Exemplos

### Múltiplos Estudos

```r
source("scripts/analise_phq9_avancado.R")

# Estudo 1: Clínica A
dados_clinica_a <- read_csv("dados/clinica_a.csv")
resultado_a <- analisar_phq9(dados_clinica_a, prefixo_arquivo = "ClinicaA")

# Estudo 2: Clínica B
dados_clinica_b <- read_csv("dados/clinica_b.csv")
resultado_b <- analisar_phq9(dados_clinica_b, prefixo_arquivo = "ClinicaB")
```

### Processar Sem Salvar Arquivos

```r
# Apenas processamento em memória
resultado <- analisar_phq9(
  dados = meus_dados,
  gerar_graficos = FALSE,
  salvar_resultados = FALSE
)

# Use o resultado diretamente
summary(resultado$escore_total)
table(resultado$severidade)
```

---

## 📚 Documentação

### Documentação Completa

- **[Cheat Sheet](documentacao/cheat_sheet.txt)** - Referência rápida de comandos
- **[Guia Avançado](documentacao/guia_de_uso_avancado.txt)** - Uso detalhado
- **[README Scripts](scripts/README.md)** - Descrição de cada script
- **[Início Rápido](INICIO_RAPIDO.md)** - Como começar em 3 passos

### Funções Principais

#### `analisar_phq9()`

```r
analisar_phq9(
  dados,                    # Dataframe com dados PHQ-9 (obrigatório)
  gerar_graficos = TRUE,    # Criar gráficos? (padrão: TRUE)
  salvar_resultados = TRUE, # Salvar CSVs? (padrão: TRUE)
  prefixo_arquivo = "PHQ9"  # Prefixo dos arquivos (padrão: "PHQ9")
)
```

**Retorna:** Dataframe com colunas originais + `escore_total`, `severidade`, `faixa_etaria`

---

## 🤝 Contribuindo

Contribuições são muito bem-vindas! Para contribuir:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add: Amazing Feature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Diretrizes

- Siga o estilo de código existente
- Documente novas funcionalidades
- Adicione testes quando aplicável
- Atualize o README se necessário

**Veja [CONTRIBUTING.md](CONTRIBUTING.md) para mais detalhes.**

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 📬 Contato

**Sidney da S. P. Bissoli** - Psicólogo | Data Science | R Programming

- GitHub: [@SidneyBissoli](https://github.com/SidneyBissoli)
- Email: sbissoli76@gmail.com

**Link do Projeto:** [https://github.com/SidneyBissoli/PHQ-9](https://github.com/SidneyBissoli/PHQ-9)

---

## 🙏 Agradecimentos

- [PHQ-9 Scale](https://www.phqscreeners.com/) - Instrumento original
- [Tidyverse](https://www.tidyverse.org/) - Ferramentas essenciais de análise
- Comunidade R Brasil

---

## 📊 Estatísticas do Projeto

![GitHub last commit](https://img.shields.io/github/last-commit/SEU_USUARIO/PHQ-9)
![GitHub issues](https://img.shields.io/github/issues/SEU_USUARIO/PHQ-9)
![GitHub pull requests](https://img.shields.io/github/issues-pr/SEU_USUARIO/PHQ-9)

---

**⭐ Se este projeto foi útil para você, considere dar uma estrela!**

---

<div align="center">
Desenvolvido com ❤️ para a comunidade de saúde mental
</div>
