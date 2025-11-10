################################################################################
#                    CONFIGURAÇÃO INICIAL - PHQ-9 ANÁLISE
#                Script de Verificação e Instalação de Dependências
################################################################################
#
# Descrição: Este script verifica se todos os pacotes e configurações
#            necessários estão instalados e funcionando corretamente
#
# Execute este script ANTES de usar os scripts de análise pela primeira vez!
#
# Como usar: source("00_configuracao_inicial.R")
#
################################################################################

cat("\n")
cat(paste(rep("=", 80), collapse = ""), "\n")
cat("       CONFIGURAÇÃO INICIAL - SISTEMA DE ANÁLISE DO PHQ-9\n")
cat(paste(rep("=", 80), collapse = ""), "\n\n")

# ==============================================================================
# 1. VERIFICAR VERSÃO DO R
# ==============================================================================

cat("1. VERIFICANDO VERSÃO DO R\n")
cat(paste(rep("-", 80), collapse = ""), "\n")

versao_r <- R.Version()
versao_numero <- as.numeric(paste(versao_r$major, 
                                  strsplit(versao_r$minor, "\\.")[[1]][1], 
                                  sep = "."))

cat(sprintf("Versão do R instalada: %s\n", R.version.string))

if (versao_numero >= 4.0) {
  cat("✅ Versão do R adequada (>= 4.0)\n\n")
} else {
  cat("⚠️  AVISO: Recomendamos R versão 4.0 ou superior\n")
  cat("   Sua versão pode funcionar, mas atualize se possível\n")
  cat("   Download: https://cran.r-project.org/\n\n")
}

# ==============================================================================
# 2. VERIFICAR E INSTALAR PACOTES
# ==============================================================================

cat("2. VERIFICANDO PACOTES NECESSÁRIOS\n")
cat(paste(rep("-", 80), collapse = ""), "\n\n")

# Lista de pacotes necessários
pacotes_necessarios <- c(
  "tidyverse",    # Manipulação de dados
  "psych",        # Análises psicométricas
  "ggplot2",      # Visualizações
  "scales",       # Formatação de gráficos
  "gridExtra",    # Organização de plots
  "knitr",        # Relatórios
  "rmarkdown",    # Geração de PDF/HTML
  "kableExtra",   # Tabelas formatadas
  "corrplot",     # Matriz de correlação
  "here"          # Gerenciamento de caminhos de projeto
)

# Função para verificar e instalar
verificar_instalar <- function(pacote) {
  if (!require(pacote, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("⏳ Instalando %s...\n", pacote))
    install.packages(pacote, dependencies = TRUE, quiet = TRUE)
    
    # Verificar se instalou com sucesso
    if (require(pacote, character.only = TRUE, quietly = TRUE)) {
      cat(sprintf("✅ %s instalado com sucesso\n", pacote))
      return(TRUE)
    } else {
      cat(sprintf("❌ ERRO ao instalar %s\n", pacote))
      return(FALSE)
    }
  } else {
    cat(sprintf("✅ %s já instalado\n", pacote))
    return(TRUE)
  }
}

# Verificar cada pacote
resultados <- sapply(pacotes_necessarios, verificar_instalar)

# Resumo
cat("\n")
if (all(resultados)) {
  cat("✅ TODOS os pacotes instalados com sucesso!\n\n")
} else {
  cat("⚠️  ATENÇÃO: Alguns pacotes não foram instalados\n")
  pacotes_faltantes <- names(resultados)[!resultados]
  cat("   Pacotes com problema:", paste(pacotes_faltantes, collapse = ", "), "\n")
  cat("   Tente instalar manualmente:\n")
  for (p in pacotes_faltantes) {
    cat(sprintf('   install.packages("%s")\n', p))
  }
  cat("\n")
}

# ==============================================================================
# 3. VERIFICAR CONFIGURAÇÕES REGIONAIS
# ==============================================================================

cat("3. VERIFICANDO CONFIGURAÇÕES REGIONAIS\n")
cat(paste(rep("-", 80), collapse = ""), "\n")

# Configurar para português brasileiro
tryCatch({
  Sys.setlocale("LC_ALL", "pt_BR.UTF-8")
  cat("✅ Locale configurado para Português Brasileiro\n")
}, error = function(e) {
  cat("⚠️  Não foi possível configurar locale pt_BR.UTF-8\n")
  cat("   Isso pode afetar datas e caracteres especiais\n")
})

cat(sprintf("Locale atual: %s\n\n", Sys.getlocale("LC_ALL")))

# ==============================================================================
# 4. VERIFICAR ESTRUTURA DE DIRETÓRIOS
# ==============================================================================

cat("4. VERIFICANDO ESTRUTURA DE DIRETÓRIOS\n")
cat(paste(rep("-", 80), collapse = ""), "\n")

diretorios <- c(
  "scripts",
  "relatorios", 
  "documentacao",
  "dados",
  "resultados",
  "resultados/csv",
  "resultados/graficos",
  "resultados/pdf",
  "resultados/html"
)

todos_ok <- TRUE
for (dir in diretorios) {
  if (dir.exists(dir)) {
    cat(sprintf("✅ %s/\n", dir))
  } else {
    cat(sprintf("⚠️  %s/ não encontrado - criando...\n", dir))
    dir.create(dir, recursive = TRUE)
    todos_ok <- FALSE
  }
}

if (todos_ok) {
  cat("\n✅ Estrutura de diretórios OK\n\n")
} else {
  cat("\n✅ Diretórios criados com sucesso\n\n")
}

# ==============================================================================
# 5. VERIFICAR SCRIPTS DISPONÍVEIS
# ==============================================================================

cat("5. VERIFICANDO SCRIPTS DISPONÍVEIS\n")
cat(paste(rep("-", 80), collapse = ""), "\n")

scripts <- c(
  "scripts/analise_phq9_basico.R",
  "scripts/analise_phq9_avancado.R",
  "relatorios/relatorio_phq9_basico.Rmd",
  "relatorios/relatorio_phq9_avancado.Rmd"
)

for (script in scripts) {
  if (file.exists(script)) {
    cat(sprintf("✅ %s\n", script))
  } else {
    cat(sprintf("❌ %s não encontrado\n", script))
  }
}
cat("\n")

# ==============================================================================
# 6. VERIFICAR TINYTEX (PARA PDF)
# ==============================================================================

cat("6. VERIFICANDO TINYTEX (OPCIONAL - PARA RELATÓRIOS PDF)\n")
cat(paste(rep("-", 80), collapse = ""), "\n")

if (requireNamespace("tinytex", quietly = TRUE)) {
  if (tinytex::is_tinytex()) {
    cat("✅ TinyTeX instalado\n")
    cat("   Você pode gerar relatórios em PDF\n\n")
  } else {
    cat("⚠️  TinyTeX não detectado\n")
    cat("   Para gerar PDFs, instale com:\n")
    cat("   install.packages('tinytex')\n")
    cat("   tinytex::install_tinytex()\n\n")
  }
} else {
  cat("⚠️  Pacote tinytex não instalado\n")
  cat("   Para gerar PDFs, instale com:\n")
  cat("   install.packages('tinytex')\n")
  cat("   tinytex::install_tinytex()\n\n")
}

# ==============================================================================
# 7. TESTE RÁPIDO
# ==============================================================================

cat("7. TESTE RÁPIDO DE FUNCIONALIDADE\n")
cat(paste(rep("-", 80), collapse = ""), "\n")

tryCatch({
  # Testar tidyverse
  library(tidyverse, quietly = TRUE)
  teste_tibble <- tibble(x = 1:5, y = 6:10)
  cat("✅ Tidyverse funcional\n")
  
  # Testar ggplot2
  suppressWarnings({
    p <- ggplot(teste_tibble, aes(x, y)) + geom_point()
  })
  cat("✅ ggplot2 funcional\n")
  
  # Testar psych
  library(psych, quietly = TRUE)
  cat("✅ psych funcional\n")
  
  cat("\n✅ Todos os testes passaram!\n\n")
  
}, error = function(e) {
  cat("❌ Erro durante os testes:\n")
  cat(sprintf("   %s\n\n", e$message))
})

# ==============================================================================
# 8. RESUMO FINAL E PRÓXIMOS PASSOS
# ==============================================================================

cat(paste(rep("=", 80), collapse = ""), "\n")
cat("RESUMO DA CONFIGURAÇÃO\n")
cat(paste(rep("=", 80), collapse = ""), "\n\n")

cat("STATUS DO SISTEMA:\n\n")

# Verificar se tudo está OK
tudo_instalado <- all(resultados)

if (tudo_instalado && all(sapply(scripts, file.exists))) {
  cat("🎉 SISTEMA PRONTO PARA USO!\n\n")
  
  cat("PRÓXIMOS PASSOS:\n")
  cat("───────────────\n\n")
  
  cat("1️⃣  EXECUTAR ANÁLISE DE DEMONSTRAÇÃO:\n")
  cat('   source("scripts/analise_phq9_basico.R")\n')
  cat("   (Gera dados fictícios e análise completa)\n\n")
  
  cat("2️⃣  ANALISAR SEUS PRÓPRIOS DADOS:\n")
  cat('   a) Coloque seu CSV em dados/\n')
  cat('   b) Carregue: library(tidyverse)\n')
  cat('                meus_dados <- read_csv("dados/seu_arquivo.csv")\n')
  cat('   c) Execute:  source("scripts/analise_phq9_avancado.R")\n')
  cat('   d) Analise:  resultado <- analisar_phq9(meus_dados)\n\n')
  
  cat("3️⃣  GERAR RELATÓRIOS:\n")
  cat("   Relatório Básico (HTML + PDF):\n")
  cat('   source("scripts/relatorio_phq9_basico.R")\n\n')
  cat("   Relatório Avançado (HTML + PDF):\n")
  cat('   source("scripts/relatorio_phq9_avancado.R")\n\n')
  cat("   Localização dos relatórios gerados:\n")
  cat('   • HTML: resultados/html/\n')
  cat('   • PDF: resultados/pdf/\n\n')
  cat("   Nota: Para gerar PDF, instale LaTeX:\n")
  cat('   install.packages("tinytex")\n')
  cat('   tinytex::install_tinytex()\n\n')
  
  cat("📚 DOCUMENTAÇÃO:\n")
  cat("   • README.md - Documentação principal\n")
  cat("   • INICIO_RAPIDO.md - Guia rápido em 3 passos\n")
  cat("   • documentacao/guia_de_uso_avancado.txt - Manual completo\n")
  cat("   • documentacao/cheat_sheet.txt - Referência rápida\n\n")
  
} else {
  cat("⚠️  SISTEMA COM PROBLEMAS\n\n")
  cat("Por favor, resolva os problemas acima antes de continuar.\n")
  cat("Consulte o README.md para mais informações.\n\n")
}

cat(paste(rep("=", 80), collapse = ""), "\n")
cat("CONFIGURAÇÃO CONCLUÍDA\n")
cat(paste(rep("=", 80), collapse = ""), "\n\n")

################################################################################
# FIM DO SCRIPT DE CONFIGURAÇÃO
################################################################################
