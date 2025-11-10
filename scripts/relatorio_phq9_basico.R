################################################################################
#                  SCRIPT PARA GERAR RELATÓRIOS PHQ-9
################################################################################
#
# Descrição: Este script gera automaticamente os relatórios em HTML e PDF,
#            salvando cada um no diretório correto.
#
# Pré-requisitos:
#   - Ter executado: source("00_configuracao_inicial.R")
#   - Ter executado: source("scripts/analise_phq9_basico.R")
#   - Dados e gráficos devem existir em resultados/csv/ e resultados/graficos/
#
# Como usar: source("scripts/gerar_relatorios.R")
#
# VERSÃO: 1.0
# DATA: 29/10/2025
#
################################################################################



# Limpar console
cat("\014")

# Mensagem inicial
cat("================================================================================\n")
cat("           GERADOR DE RELATÓRIOS PHQ-9 - HTML + PDF\n")
cat("================================================================================\n\n")

# ==============================================================================
# VERIFICAR REQUISITOS
# ==============================================================================

cat("🔍 Verificando requisitos...\n")
cat("────────────────────────────────────────────────────────────────────────────────\n\n")

# Verificar se está na raiz do projeto
if (!file.exists("relatorios/relatorio_phq9_basico.Rmd")) {
  stop("\n❌ ERRO: Execute este script da RAIZ do projeto PHQ-9!\n\n",
       "Diretório atual: ", getwd(), "\n",
       "Esperado: pasta PHQ-9/\n")
}

cat("✓ Diretório correto detectado\n")

# Verificar pacotes necessários
pacotes <- c("rmarkdown", "knitr", "here")
pacotes_faltando <- c()

for (pacote in pacotes) {
  if (!require(pacote, character.only = TRUE, quietly = TRUE)) {
    pacotes_faltando <- c(pacotes_faltando, pacote)
  }
}

if (length(pacotes_faltando) > 0) {
  stop("\n❌ ERRO: Pacotes necessários não estão instalados!\n\n",
       "Pacotes faltando: ", paste(pacotes_faltando, collapse = ", "), "\n\n",
       "Solução: Execute source('00_configuracao_inicial.R')\n")
}

cat("✓ Pacotes necessários instalados\n")

# Verificar se dados e gráficos existem
arquivos_necessarios <- c(
  "resultados/csv/dados_phq9_processados.csv",
  "resultados/graficos/PHQ9_1_histograma_escore.png"
)

arquivos_faltando <- arquivos_necessarios[!file.exists(arquivos_necessarios)]

if (length(arquivos_faltando) > 0) {
  stop("\n❌ ERRO: Dados ou gráficos não encontrados!\n\n",
       "Arquivos faltando:\n",
       paste("  -", arquivos_faltando, collapse = "\n"), "\n\n",
       "Solução: Execute source('scripts/analise_phq9_basico.R')\n")
}

cat("✓ Dados e gráficos encontrados\n")

# Verificar se pastas de saída existem
if (!dir.exists("resultados/html")) {
  stop("\n❌ ERRO: Pasta resultados/html/ não existe!\n\n",
       "Solução: Execute source('00_configuracao_inicial.R')\n")
}

if (!dir.exists("resultados/pdf")) {
  stop("\n❌ ERRO: Pasta resultados/pdf/ não existe!\n\n",
       "Solução: Execute source('00_configuracao_inicial.R')\n")
}

cat("✓ Pastas de saída verificadas\n\n")

cat("✅ Todos os requisitos atendidos!\n\n")

# ==============================================================================
# GERAR RELATÓRIO HTML
# ==============================================================================

cat("================================================================================\n")
cat("📄 GERANDO RELATÓRIO HTML\n")
cat("================================================================================\n\n")

html_sucesso <- FALSE

tryCatch({
  
  cat("Processando arquivo RMarkdown para HTML...\n")
  cat("(Isso pode levar alguns segundos...)\n\n")
  
  rmarkdown::render(
    input = "relatorios/relatorio_phq9_basico.Rmd",
    output_format = html_document(self_contained = TRUE), 
    output_file = "relatorio_phq9_basico.html",
    output_dir = "resultados/html",
    quiet = FALSE,
    encoding = "UTF-8"
  )
  
  html_sucesso <- TRUE
  
  cat("\n✅ Relatório HTML gerado com SUCESSO!\n")
  cat("📁 Local: resultados/html/relatorio_phq9_basico.html\n")
  
  # Mostrar tamanho do arquivo
  tamanho_html <- file.size("resultados/html/relatorio_phq9_basico.html") / 1024
  cat(sprintf("📊 Tamanho: %.1f KB\n\n", tamanho_html))
  
}, error = function(e) {
  cat("\n❌ ERRO ao gerar HTML:\n")
  cat("   ", conditionMessage(e), "\n\n")
})

# ==============================================================================
# GERAR RELATÓRIO PDF
# ==============================================================================



cat("================================================================================\n")
cat("📄 GERANDO RELATÓRIO PDF\n")
cat("================================================================================\n\n")

# Verificar se LaTeX está disponível
latex_disponivel <- FALSE

if (requireNamespace("tinytex", quietly = TRUE)) {
  latex_disponivel <- tinytex::is_tinytex()
  if (!latex_disponivel) {
    latex_disponivel <- nzchar(Sys.which("pdflatex"))
  }
} else {
  latex_disponivel <- nzchar(Sys.which("pdflatex"))
}

if (!latex_disponivel) {
  cat("⚠️ AVISO: LaTeX não foi detectado no sistema.\n\n")
  cat("Para gerar relatórios PDF, você precisa ter LaTeX instalado.\n\n")
  cat("Opções de instalação:\n")
  cat("  1. TinyTeX (recomendado para R):\n")
  cat("     install.packages('tinytex')\n")
  cat("     tinytex::install_tinytex()\n\n")
  cat("  2. MiKTeX (Windows): http://miktex.org\n")
  cat("  3. MacTeX (macOS): https://tug.org/mactex/\n")
  cat("  4. TeX Live (Linux): sudo apt-get install texlive-full\n\n")
  
  cat("⏭️ Pulando geração de PDF.\n\n")
  
  # Pular para resumo final
  pdf_sucesso <- FALSE
  
} else {
  
  pdf_sucesso <- FALSE
  
  tryCatch({
    
    cat("Processando arquivo RMarkdown para PDF...\n")
    cat("(Isso pode levar alguns segundos...)\n\n")
    
   
    
    rmarkdown::render(
      input = "relatorios/relatorio_phq9_basico.Rmd",
      output_format = pdf_document(),
      output_file = "relatorio_phq9_basico.pdf",
      output_dir = "resultados/pdf",
      quiet = FALSE,
      encoding = "UTF-8"
    )
    
    pdf_sucesso <- TRUE
    
    cat("\n✅ Relatório PDF gerado com SUCESSO!\n")
    cat("📁 Local: resultados/pdf/relatorio_phq9_basico.pdf\n")
    
    # Mostrar tamanho do arquivo
    tamanho_pdf <- file.size("resultados/pdf/relatorio_phq9_basico.pdf") / 1024
    cat(sprintf("📊 Tamanho: %.1f KB\n\n", tamanho_pdf))
    
  }, error = function(e) {
    cat("\n❌ ERRO ao gerar PDF:\n")
    cat("   ", conditionMessage(e), "\n\n")
    
    if (!latex_disponivel) {
      cat("💡 Causa provável: LaTeX não está instalado corretamente.\n")
      cat("   Instale o TinyTeX: tinytex::install_tinytex()\n\n")
    }
  })
}

# ==============================================================================
# LIMPAR ARQUIVOS TEMPORÁRIOS
# ==============================================================================

cat("================================================================================\n")
cat("🧹 LIMPANDO ARQUIVOS TEMPORÁRIOS\n")
cat("================================================================================\n\n")

# Lista de arquivos temporários do LaTeX
arquivos_temp <- c(
  "relatorios/relatorio_phq9_basico.tex",
  "relatorios/relatorio_phq9_basico.log",
  "relatorios/relatorio_phq9_basico.aux",
  "relatorios/relatorio_phq9_basico.toc",
  "relatorios/relatorio_phq9_basico.out",
  "relatorios/relatorio_phq9_basico.fls",
  "relatorios/relatorio_phq9_basico.fdb_latexmk",
  "relatorios/relatorio_phq9_basico.synctex.gz"
)

# Pastas temporárias
pastas_temp <- c(
  "relatorios/relatorio_phq9_basico_files",
  "relatorios/relatorio_phq9_basico_cache"
)

arquivos_removidos <- 0

# Remover arquivos
for (arquivo in arquivos_temp) {
  if (file.exists(arquivo)) {
    file.remove(arquivo)
    cat("  ✓ Removido:", basename(arquivo), "\n")
    arquivos_removidos <- arquivos_removidos + 1
  }
}

# Remover pastas
for (pasta in pastas_temp) {
  if (dir.exists(pasta)) {
    unlink(pasta, recursive = TRUE)
    cat("  ✓ Removido:", basename(pasta), "/\n")
    arquivos_removidos <- arquivos_removidos + 1
  }
}

if (arquivos_removidos == 0) {
  cat("  ℹ️ Nenhum arquivo temporário encontrado\n")
} else {
  cat(sprintf("\n✓ Total de itens removidos: %d\n", arquivos_removidos))
}

cat("\n")

# ==============================================================================
# RESUMO FINAL
# ==============================================================================

cat("================================================================================\n")
cat("✅ PROCESSO CONCLUÍDO!\n")
cat("================================================================================\n\n")

cat("📊 RELATÓRIOS GERADOS:\n")
cat("────────────────────────────────────────────────────────────────────────────────\n")

if (html_sucesso) {
  cat("✓ HTML: resultados/html/relatorio_phq9_basico.html\n")
}

if (pdf_sucesso) {
  cat("✓ PDF:  resultados/pdf/relatorio_phq9_basico.pdf\n")
}

if (!html_sucesso && !pdf_sucesso) {
  cat("❌ Nenhum relatório foi gerado com sucesso\n")
  cat("   Verifique os erros acima\n")
}

cat("\n")

if (html_sucesso || pdf_sucesso) {
  cat("💡 COMO ABRIR OS RELATÓRIOS:\n")
  cat("────────────────────────────────────────────────────────────────────────────────\n")
  
  if (html_sucesso) {
    cat("• HTML: Navegue até resultados/html/ e abra o arquivo no navegador\n")
  }
  
  if (pdf_sucesso) {
    cat("• PDF:  Navegue até resultados/pdf/ e abra o arquivo com leitor de PDF\n")
  }
  
  cat("\n")
  cat("🎉 Análise PHQ-9 concluída com sucesso!\n\n")
}

cat("================================================================================\n\n")

################################################################################
# FIM DO SCRIPT
################################################################################
