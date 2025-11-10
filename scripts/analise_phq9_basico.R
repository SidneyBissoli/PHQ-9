################################################################################
#                     ANÁLISE DO PHQ-9 (Patient Health Questionnaire-9)
#                          Script de Análise Psicométrica
################################################################################
# 
# Descrição: Script completo para análise de dados do PHQ-9, incluindo
#            geração de dados fictícios, cálculo de escores, análises
#            descritivas, visualizações e análise de confiabilidade
#
# Autor: Análise Psicológica
# Data: Outubro 2025
#
################################################################################

# ==============================================================================
# 1. CARREGAR PACOTES NECESSÁRIOS
# ==============================================================================

cat("Verificando e instalando pacotes necessários...\n")

# Lista de pacotes necessários
pacotes <- c("tidyverse", "psych", "ggplot2", "scales", "gridExtra")

# Função para instalar e carregar pacotes
instalar_carregar <- function(pacote) {
  if (!require(pacote, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("  Instalando %s...\n", pacote))
    install.packages(pacote, dependencies = TRUE, quiet = TRUE)
    library(pacote, character.only = TRUE, quietly = TRUE)
    cat(sprintf("  ✓ %s instalado e carregado\n", pacote))
  } else {
    cat(sprintf("  ✓ %s já instalado e carregado\n", pacote))
  }
}

# Instalar e carregar cada pacote
suppressWarnings({
  for(pacote in pacotes) {
    instalar_carregar(pacote)
  }
})

cat("\n✓ Todos os pacotes carregados com sucesso!\n\n")

# ==============================================================================
# 1.5. CONFIGURAÇÃO REGIONAL E ENCODING
# ==============================================================================

cat("Configurando locale para Português Brasileiro...\n")

# Configurar locale para português brasileiro
# Isso garante que datas, números e caracteres especiais funcionem corretamente
Sys.setlocale("LC_ALL", "pt_BR.UTF-8")

# Definir encoding padrão para exportação
# Use "latin1" para melhor compatibilidade com Excel no Windows
# Use "UTF-8" para compatibilidade moderna e melhor suporte a caracteres
ENCODING_EXPORT <- "latin1"  # Altere para "UTF-8" se preferir

cat(sprintf("✓ Locale configurado para português brasileiro\n"))
cat(sprintf("✓ Encoding de exportação: %s\n\n", ENCODING_EXPORT))

# Nota: Arquivos CSV são salvos com readr::write_csv2()
# - Usa vírgula como separador decimal (padrão pt_BR)
# - Usa ponto e vírgula como separador de colunas
# - Formato correto para Excel em português brasileiro
# - UTF-8 encoding para caracteres acentuados

# Função auxiliar para salvar CSV com formato e encoding corretos para Excel pt_BR
salvar_csv <- function(dados, arquivo) {
  # Converte para data.frame se necessário (para evitar problemas com tibble)
  if (inherits(dados, "tbl_df")) {
    dados <- as.data.frame(dados)
  }
  
  # IMPORTANTE: Usar write.csv2() base do R com encoding latin1
  # - Vírgula como separador decimal (8,6)
  # - Ponto e vírgula como separador de colunas
  # - Latin1 encoding (correto para Excel Windows pt_BR)
  write.csv2(dados, 
             file = arquivo,
             row.names = FALSE,
             fileEncoding = "latin1",
             na = "")
  
  invisible(arquivo)
}


# ==============================================================================
# 1.7. CRIAR DIRETÓRIOS DE RESULTADOS (SE NÃO EXISTIREM)
# ==============================================================================

# Criar pastas de resultados se não existirem
dir.create("resultados", showWarnings = FALSE)
dir.create("resultados/csv", showWarnings = FALSE, recursive = TRUE)
dir.create("resultados/graficos", showWarnings = FALSE, recursive = TRUE)

# ==============================================================================
# 2. GERAR DADOS FICTÍCIOS REALISTAS DO PHQ-9
# ==============================================================================

set.seed(2025)  # Para reprodutibilidade

# Função para gerar respostas realistas (mais respostas baixas, algumas altas)
gerar_resposta_phq9 <- function(n) {
  # Usa uma distribuição binomial negativa para simular dados realistas
  # A maioria das pessoas tem escores baixos, algumas têm escores altos
  probs <- c(0.50, 0.25, 0.15, 0.10)  # Probabilidades para 0, 1, 2, 3
  sample(0:3, size = n, replace = TRUE, prob = probs)
}

# Criar dataset com 100 respondentes
n_respondentes <- 100

dados_phq9 <- tibble(
  id = 1:n_respondentes,
  idade = sample(18:70, n_respondentes, replace = TRUE),
  sexo = sample(c("M", "F"), n_respondentes, replace = TRUE, prob = c(0.48, 0.52))
)

# Gerar respostas para os 9 itens do PHQ-9
# Cada item avalia frequência de sintomas nas últimas 2 semanas
# 0 = Nenhuma vez, 1 = Vários dias, 2 = Mais da metade dos dias, 3 = Quase todos os dias

itens_phq9 <- c(
  "PHQ9_1",  # Pouco interesse ou prazer em fazer as coisas
  "PHQ9_2",  # Sentindo-se para baixo, deprimido ou sem esperança
  "PHQ9_3",  # Problemas para adormecer, continuar dormindo ou dormir demais
  "PHQ9_4",  # Sentindo-se cansado ou com pouca energia
  "PHQ9_5",  # Falta de apetite ou comendo demais
  "PHQ9_6",  # Sentindo-se mal consigo mesmo ou que é um fracasso
  "PHQ9_7",  # Problemas de concentração
  "PHQ9_8",  # Lentidão ou agitação psicomotora
  "PHQ9_9"   # Pensamentos de morte ou autolesão
)

# Adicionar respostas dos 9 itens
for(item in itens_phq9) {
  dados_phq9[[item]] <- gerar_resposta_phq9(n_respondentes)
}

cat("✓ Dados fictícios gerados com sucesso!\n")
cat(sprintf("  - Total de respondentes: %d\n", n_respondentes))
cat(sprintf("  - Idade: %d a %d anos\n", min(dados_phq9$idade), max(dados_phq9$idade)))
cat(sprintf("  - Sexo: %d Masculino, %d Feminino\n\n", 
            sum(dados_phq9$sexo == "M"), sum(dados_phq9$sexo == "F")))

# ==============================================================================
# 3. CALCULAR ESCORES E CATEGORIAS
# ==============================================================================

dados_phq9 <- dados_phq9 %>%
  mutate(
    # Calcular escore total (soma dos 9 itens)
    escore_total = PHQ9_1 + PHQ9_2 + PHQ9_3 + PHQ9_4 + PHQ9_5 + 
                   PHQ9_6 + PHQ9_7 + PHQ9_8 + PHQ9_9,
    
    # Categorizar severidade da depressão
    severidade = case_when(
      escore_total >= 0  & escore_total <= 4  ~ "Mínima",
      escore_total >= 5  & escore_total <= 9  ~ "Leve",
      escore_total >= 10 & escore_total <= 14 ~ "Moderada",
      escore_total >= 15 & escore_total <= 19 ~ "Moderadamente Grave",
      escore_total >= 20 & escore_total <= 27 ~ "Grave",
      TRUE ~ NA_character_
    ),
    
    # Ordenar categorias de severidade
    severidade = factor(severidade, 
                       levels = c("Mínima", "Leve", "Moderada", 
                                 "Moderadamente Grave", "Grave")),
    
    # Criar faixas etárias
    faixa_etaria = case_when(
      idade >= 18 & idade < 30 ~ "18-29 anos",
      idade >= 30 & idade < 40 ~ "30-39 anos",
      idade >= 40 & idade < 50 ~ "40-49 anos",
      idade >= 50 & idade < 60 ~ "50-59 anos",
      idade >= 60 & idade <= 70 ~ "60-70 anos"
    ),
    faixa_etaria = factor(faixa_etaria)
  )

cat("✓ Escores e categorias calculados!\n\n")

# ==============================================================================
# 4. ANÁLISES DESCRITIVAS
# ==============================================================================

cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")
cat("ESTATÍSTICAS DESCRITIVAS DO PHQ-9\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n\n")

# 4.1 Estatísticas do escore total
cat("4.1. ESCORE TOTAL\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n")

estatisticas_escore <- dados_phq9 %>%
  summarise(
    N = n(),
    Média = mean(escore_total, na.rm = TRUE),
    DP = sd(escore_total, na.rm = TRUE),
    Mediana = median(escore_total, na.rm = TRUE),
    Mínimo = min(escore_total, na.rm = TRUE),
    Máximo = max(escore_total, na.rm = TRUE),
    Q1 = quantile(escore_total, 0.25, na.rm = TRUE),
    Q3 = quantile(escore_total, 0.75, na.rm = TRUE)
  )

print(as.data.frame(estatisticas_escore))
cat("\n")

# 4.2 Distribuição de categorias de severidade
cat("4.2. DISTRIBUIÇÃO DE SEVERIDADE\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n")

dist_severidade <- dados_phq9 %>%
  count(severidade) %>%
  mutate(
    Percentual = (n / sum(n)) * 100,
    Percentual = round(Percentual, 1)
  ) %>%
  rename(Severidade = severidade, N = n)

print(as.data.frame(dist_severidade))
cat("\n")

# 4.3 Análise por sexo
cat("4.3. ANÁLISE POR SEXO\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n")

analise_sexo <- dados_phq9 %>%
  group_by(sexo) %>%
  summarise(
    N = n(),
    Média = mean(escore_total, na.rm = TRUE),
    DP = sd(escore_total, na.rm = TRUE),
    Mediana = median(escore_total, na.rm = TRUE),
    Mínimo = min(escore_total, na.rm = TRUE),
    Máximo = max(escore_total, na.rm = TRUE)
  ) %>%
  rename(Sexo = sexo)

print(as.data.frame(analise_sexo))
cat("\n")

# 4.4 Análise por faixa etária
cat("4.4. ANÁLISE POR FAIXA ETÁRIA\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n")

analise_idade <- dados_phq9 %>%
  group_by(faixa_etaria) %>%
  summarise(
    N = n(),
    Média = mean(escore_total, na.rm = TRUE),
    DP = sd(escore_total, na.rm = TRUE),
    Mediana = median(escore_total, na.rm = TRUE)
  ) %>%
  rename(`Faixa Etária` = faixa_etaria)

print(as.data.frame(analise_idade))
cat("\n")

# 4.5 Estatísticas por item
cat("4.5. ESTATÍSTICAS POR ITEM DO PHQ-9\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n")

dados_itens <- dados_phq9 %>%
  select(starts_with("PHQ9_")) %>%
  pivot_longer(cols = everything(), names_to = "Item", values_to = "Resposta")

estatisticas_itens <- dados_itens %>%
  group_by(Item) %>%
  summarise(
    Média = mean(Resposta, na.rm = TRUE),
    DP = sd(Resposta, na.rm = TRUE),
    Mediana = median(Resposta, na.rm = TRUE),
    `% Zero` = sum(Resposta == 0) / n() * 100,
    `% Três` = sum(Resposta == 3) / n() * 100
  ) %>%
  mutate(across(where(is.numeric), ~round(.x, 2)))

print(as.data.frame(estatisticas_itens))
cat("\n")

# ==============================================================================
# 5. VISUALIZAÇÕES
# ==============================================================================

cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")
cat("GERANDO VISUALIZAÇÕES\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n\n")

# Configurar tema para os gráficos
tema_phq9 <- theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5, color = "gray40"),
    axis.title = element_text(face = "bold", size = 11),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

# 5.1 Histograma do escore total
p1 <- ggplot(dados_phq9, aes(x = escore_total)) +
  geom_histogram(binwidth = 1, fill = "#3498db", color = "white", alpha = 0.8) +
  geom_vline(aes(xintercept = mean(escore_total)), 
             color = "#e74c3c", linetype = "dashed", size = 1) +
  labs(
    title = "Distribuição do Escore Total do PHQ-9",
    subtitle = sprintf("Média = %.2f | DP = %.2f | N = %d",
                      mean(dados_phq9$escore_total),
                      sd(dados_phq9$escore_total),
                      nrow(dados_phq9)),
    x = "Escore Total (0-27)",
    y = "Frequência"
  ) +
  scale_x_continuous(breaks = seq(0, 27, 3)) +
  tema_phq9

# 5.2 Gráfico de barras das categorias de severidade
p2 <- dados_phq9 %>%
  count(severidade) %>%
  mutate(
    percentual = n / sum(n) * 100,
    label = sprintf("%d (%.1f%%)", n, percentual)
  ) %>%
  ggplot(aes(x = severidade, y = n, fill = severidade)) +
  geom_col(alpha = 0.8, color = "white") +
  geom_text(aes(label = label), vjust = -0.5, fontface = "bold", size = 3.5) +
  scale_fill_manual(values = c(
    "Mínima" = "#2ecc71",
    "Leve" = "#f39c12",
    "Moderada" = "#e67e22",
    "Moderadamente Grave" = "#e74c3c",
    "Grave" = "#c0392b"
  )) +
  labs(
    title = "Distribuição de Categorias de Severidade",
    subtitle = "Classificação segundo o PHQ-9",
    x = "Categoria de Severidade",
    y = "Número de Respondentes"
  ) +
  tema_phq9 +
  theme(legend.position = "none") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15)))

# 5.3 Boxplot do escore por sexo
p3 <- ggplot(dados_phq9, aes(x = sexo, y = escore_total, fill = sexo)) +
  geom_boxplot(alpha = 0.7, outlier.shape = 21, outlier.size = 2) +
  geom_jitter(width = 0.2, alpha = 0.3, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3, 
               fill = "red", color = "darkred") +
  scale_fill_manual(values = c("M" = "#3498db", "F" = "#e74c3c")) +
  labs(
    title = "Escore Total do PHQ-9 por Sexo",
    subtitle = "Boxplot com pontos individuais (losango vermelho = média)",
    x = "Sexo",
    y = "Escore Total (0-27)"
  ) +
  tema_phq9 +
  theme(legend.position = "none")

# 5.4 Heatmap de correlações entre itens
matriz_itens <- dados_phq9 %>%
  select(starts_with("PHQ9_")) %>%
  cor()

# Preparar dados para heatmap
dados_heatmap <- matriz_itens %>%
  as.data.frame() %>%
  rownames_to_column("Item1") %>%
  pivot_longer(-Item1, names_to = "Item2", values_to = "Correlacao")

p4 <- ggplot(dados_heatmap, aes(x = Item1, y = Item2, fill = Correlacao)) +
  geom_tile(color = "white") +
  geom_text(aes(label = sprintf("%.2f", Correlacao)), size = 2.5) +
  scale_fill_gradient2(low = "#3498db", mid = "white", high = "#e74c3c",
                       midpoint = 0, limits = c(-1, 1)) +
  labs(
    title = "Matriz de Correlações entre Itens do PHQ-9",
    subtitle = "Correlações de Pearson",
    x = "", y = ""
  ) +
  tema_phq9 +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 5.5 Gráfico de perfil médio por item
dados_perfil <- dados_phq9 %>%
  select(starts_with("PHQ9_")) %>%
  pivot_longer(everything(), names_to = "Item", values_to = "Resposta") %>%
  group_by(Item) %>%
  summarise(
    Media = mean(Resposta, na.rm = TRUE),
    EP = sd(Resposta, na.rm = TRUE) / sqrt(n()),
    .groups = "drop"
  )

p5 <- ggplot(dados_perfil, aes(x = Item, y = Media)) +
  geom_line(group = 1, color = "#3498db", size = 1) +
  geom_point(size = 3, color = "#2c3e50") +
  geom_errorbar(aes(ymin = Media - EP, ymax = Media + EP), 
                width = 0.2, color = "#34495e") +
  labs(
    title = "Perfil Médio de Respostas aos Itens do PHQ-9",
    subtitle = "Médias com erro padrão",
    x = "Item",
    y = "Média da Resposta (0-3)"
  ) +
  scale_y_continuous(limits = c(0, 3), breaks = 0:3) +
  tema_phq9

# 5.6 Distribuição de severidade por faixa etária
p6 <- dados_phq9 %>%
  count(faixa_etaria, severidade) %>%
  group_by(faixa_etaria) %>%
  mutate(prop = n / sum(n) * 100) %>%
  ggplot(aes(x = faixa_etaria, y = prop, fill = severidade)) +
  geom_col(position = "stack", alpha = 0.8) +
  scale_fill_manual(values = c(
    "Mínima" = "#2ecc71",
    "Leve" = "#f39c12",
    "Moderada" = "#e67e22",
    "Moderadamente Grave" = "#e74c3c",
    "Grave" = "#c0392b"
  )) +
  labs(
    title = "Distribuição de Severidade por Faixa Etária",
    subtitle = "Percentual em cada categoria",
    x = "Faixa Etária",
    y = "Percentual (%)",
    fill = "Severidade"
  ) +
  tema_phq9 +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Salvar todos os gráficos
cat("✓ Salvando gráficos...\n")

ggsave("resultados/graficos/PHQ9_1_histograma_escore.png", plot = p1, 
       width = 10, height = 6, dpi = 300)
ggsave("resultados/graficos/PHQ9_2_categorias_severidade.png", plot = p2, 
       width = 10, height = 6, dpi = 300)
ggsave("resultados/graficos/PHQ9_3_boxplot_sexo.png", plot = p3, 
       width = 8, height = 6, dpi = 300)
ggsave("resultados/graficos/PHQ9_4_heatmap_correlacoes.png", plot = p4, 
       width = 10, height = 8, dpi = 300)
ggsave("resultados/graficos/PHQ9_5_perfil_itens.png", plot = p5, 
       width = 10, height = 6, dpi = 300)
ggsave("resultados/graficos/PHQ9_6_severidade_idade.png", plot = p6, 
       width = 10, height = 6, dpi = 300)

cat("✓ Gráficos salvos com sucesso!\n\n")

# ==============================================================================
# 6. ANÁLISE DE CONFIABILIDADE (ALFA DE CRONBACH)
# ==============================================================================

cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")
cat("ANÁLISE DE CONFIABILIDADE\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n\n")

# Selecionar apenas os 9 itens do PHQ-9
itens_matriz <- dados_phq9 %>%
  select(PHQ9_1:PHQ9_9)

# Calcular alfa de Cronbach
alfa <- psych::alpha(itens_matriz, check.keys = TRUE)

cat("6.1. ALFA DE CRONBACH\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n")
cat(sprintf("Alfa de Cronbach bruto: %.4f\n", alfa$total$raw_alpha))
cat(sprintf("Alfa de Cronbach padronizado: %.4f\n", alfa$total$std.alpha))
cat(sprintf("Número de itens: %d\n", alfa$total$n))
cat(sprintf("Média inter-item: %.4f\n", alfa$total$average_r))
cat("\n")

cat("Interpretação do Alfa de Cronbach:\n")
interpretacao_alfa <- case_when(
  alfa$total$raw_alpha >= 0.90 ~ "Excelente (≥ 0.90)",
  alfa$total$raw_alpha >= 0.80 ~ "Bom (0.80 - 0.89)",
  alfa$total$raw_alpha >= 0.70 ~ "Aceitável (0.70 - 0.79)",
  alfa$total$raw_alpha >= 0.60 ~ "Questionável (0.60 - 0.69)",
  alfa$total$raw_alpha >= 0.50 ~ "Pobre (0.50 - 0.59)",
  TRUE ~ "Inaceitável (< 0.50)"
)
cat(sprintf("→ %s\n\n", interpretacao_alfa))

cat("6.2. ESTATÍSTICAS DE CONFIABILIDADE POR ITEM\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n")

# Estatísticas de cada item
item_stats <- alfa$item.stats %>%
  rownames_to_column("Item") %>%
  select(Item, n, raw.r, std.r, `r.cor`, `r.drop`, mean, sd) %>%
  mutate(across(where(is.numeric), ~round(.x, 3)))

print(as.data.frame(item_stats))
cat("\n")

cat("6.3. ALFA SE O ITEM FOR EXCLUÍDO\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n")

alfa_drop <- alfa$alpha.drop %>%
  rownames_to_column("Item") %>%
  select(Item, `raw_alpha`, `std.alpha`) %>%
  mutate(across(where(is.numeric), ~round(.x, 4))) %>%
  rename(
    `Alfa bruto` = raw_alpha,
    `Alfa padronizado` = std.alpha
  )

print(as.data.frame(alfa_drop))
cat("\n")

# Análise de dimensionalidade (análise paralela)
cat("6.4. ANÁLISE DE DIMENSIONALIDADE\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n")

# Análise paralela para determinar número de fatores
# (Suprimindo warnings normais do procedimento)
parallel <- suppressWarnings({
  fa.parallel(itens_matriz, fa = "fa", n.iter = 100, 
              main = "Análise Paralela do PHQ-9", show.legend = FALSE)
})

cat(sprintf("Número de fatores sugeridos pela análise paralela: %d\n\n", 
            parallel$nfact))

# ==============================================================================
# 7. EXPORTAR DADOS PROCESSADOS
# ==============================================================================

cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")
cat("EXPORTANDO DADOS\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n\n")

# Salvar dados processados em CSV
salvar_csv(dados_phq9, "resultados/csv/dados_phq9_processados.csv")
cat("✓ Dados salvos em: resultados/csv/dados_phq9_processados.csv\n")

# Salvar estatísticas descritivas
salvar_csv(dist_severidade, "resultados/csv/tabela_severidade.csv")
salvar_csv(analise_sexo, "resultados/csv/analise_por_sexo.csv")
salvar_csv(analise_idade, "resultados/csv/analise_por_idade.csv")
salvar_csv(estatisticas_itens, "resultados/csv/estatisticas_por_item.csv")
cat("✓ Tabelas de análise salvas em CSV\n")

# Criar relatório resumido
relatorio <- tibble(
  Metrica = c("N total", "Média escore total", "DP escore total", 
              "Mediana escore total", "Min-Max",
              "% Mínima", "% Leve", "% Moderada", 
              "% Moderadamente Grave", "% Grave",
              "Alfa de Cronbach"),
  Valor = c(
    as.character(nrow(dados_phq9)),
    sprintf("%.2f", mean(dados_phq9$escore_total)),
    sprintf("%.2f", sd(dados_phq9$escore_total)),
    sprintf("%.1f", median(dados_phq9$escore_total)),
    sprintf("%d-%d", min(dados_phq9$escore_total), max(dados_phq9$escore_total)),
    sprintf("%.1f%%", dist_severidade$Percentual[1]),
    sprintf("%.1f%%", dist_severidade$Percentual[2]),
    sprintf("%.1f%%", dist_severidade$Percentual[3]),
    sprintf("%.1f%%", dist_severidade$Percentual[4]),
    sprintf("%.1f%%", dist_severidade$Percentual[5]),
    sprintf("%.4f", alfa$total$raw_alpha)
  )
)

salvar_csv(relatorio, "resultados/csv/relatorio_resumido_phq9.csv")
cat("✓ Relatório resumido salvo\n\n")

# ==============================================================================
# 8. RESUMO FINAL
# ==============================================================================

cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")
cat("ANÁLISE CONCLUÍDA COM SUCESSO!\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n\n")

cat("ARQUIVOS GERADOS:\n")
cat("─────────────────\n")
cat("Dados:\n")
cat("  • resultados/csv/dados_phq9_processados.csv - Dataset completo com escores\n")
cat("  • resultados/csv/tabela_severidade.csv - Distribuição de categorias\n")
cat("  • resultados/csv/analise_por_sexo.csv - Estatísticas por sexo\n")
cat("  • resultados/csv/analise_por_idade.csv - Estatísticas por faixa etária\n")
cat("  • resultados/csv/estatisticas_por_item.csv - Análise de cada item\n")
cat("  • resultados/csv/relatorio_resumido_phq9.csv - Resumo executivo\n\n")

cat("Gráficos:\n")
cat("  • resultados/graficos/PHQ9_1_histograma_escore.png\n")
cat("  • resultados/graficos/PHQ9_2_categorias_severidade.png\n")
cat("  • resultados/graficos/PHQ9_3_boxplot_sexo.png\n")
cat("  • resultados/graficos/PHQ9_4_heatmap_correlacoes.png\n")
cat("  • resultados/graficos/PHQ9_5_perfil_itens.png\n")
cat("  • resultados/graficos/PHQ9_6_severidade_idade.png\n\n")

cat("PRINCIPAIS RESULTADOS:\n")
cat("──────────────────────\n")
cat(sprintf("• Escore médio: %.2f (DP = %.2f)\n", 
            mean(dados_phq9$escore_total), sd(dados_phq9$escore_total)))
cat(sprintf("• Alfa de Cronbach: %.4f (%s)\n", 
            alfa$total$raw_alpha, interpretacao_alfa))
cat(sprintf("• Categoria mais frequente: %s (%.1f%%)\n",
            dist_severidade$Severidade[which.max(dist_severidade$N)],
            max(dist_severidade$Percentual)))
cat("\n")

cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")
cat("Análise realizada com sucesso!\n")
cat("Script desenvolvido para análise psicométrica do PHQ-9\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")

################################################################################
# FIM DO SCRIPT
################################################################################