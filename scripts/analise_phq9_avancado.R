################################################################################
#              ANÁLISE AVANÇADA DO PHQ-9 (Patient Health Questionnaire-9)
#                     Script de Análise Psicométrica Expandido
################################################################################
# 
# Descrição: Script completo e avançado para análise de dados do PHQ-9
#            Inclui análises bivariadas, função reutilizável, e relatórios
#
# Autor: Análise Psicológica
# Data: Outubro 2025
# Versão: 2.0 (Expandida)
#
################################################################################

# ==============================================================================
# 1. CARREGAR PACOTES NECESSÁRIOS
# ==============================================================================

cat("Verificando e instalando pacotes necessários...\n")

# Lista de pacotes necessários
pacotes <- c("tidyverse", "psych", "ggplot2", "scales", "gridExtra", 
             "knitr", "rmarkdown", "kableExtra", "corrplot")

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
# 2. FUNÇÃO REUTILIZÁVEL PARA ANÁLISE DO PHQ-9
# ==============================================================================

#' Analisar dados do PHQ-9
#'
#' Esta função processa dados do PHQ-9, calcula escores, categoriza severidade
#' e gera um relatório completo com estatísticas e visualizações
#'
#' @param dados Dataframe contendo colunas: PHQ9_1 a PHQ9_9, idade, sexo
#' @param gerar_graficos Lógico. Se TRUE, gera e salva gráficos (padrão: TRUE)
#' @param salvar_resultados Lógico. Se TRUE, salva CSVs (padrão: TRUE)
#' @param prefixo_arquivo String. Prefixo para nomes de arquivos (padrão: "PHQ9")
#'
#' @return Dataframe processado com escores e categorias
#'
#' @examples
#' resultado <- analisar_phq9(meus_dados, gerar_graficos = TRUE)
#'
analisar_phq9 <- function(dados, 
                          gerar_graficos = TRUE, 
                          salvar_resultados = TRUE,
                          prefixo_arquivo = "PHQ9") {
  
  cat("\n" %>% rep(80) %>% paste(collapse = "="), "\n")
  cat("INICIANDO ANÁLISE DO PHQ-9\n")
  cat("=" %>% rep(80) %>% paste(collapse = ""), "\n\n")
  
  # Validar dados de entrada
  colunas_necessarias <- c("PHQ9_1", "PHQ9_2", "PHQ9_3", "PHQ9_4", "PHQ9_5",
                           "PHQ9_6", "PHQ9_7", "PHQ9_8", "PHQ9_9", 
                           "idade", "sexo")
  
  if (!all(colunas_necessarias %in% names(dados))) {
    stop("Erro: O dataframe deve conter as colunas: ", 
         paste(colunas_necessarias, collapse = ", "))
  }
  
  # Calcular escores e categorias
  dados_processados <- dados %>%
    mutate(
      # Calcular escore total
      escore_total = PHQ9_1 + PHQ9_2 + PHQ9_3 + PHQ9_4 + PHQ9_5 + 
        PHQ9_6 + PHQ9_7 + PHQ9_8 + PHQ9_9,
      
      # Categorizar severidade
      severidade = case_when(
        escore_total >= 0  & escore_total <= 4  ~ "Mínima",
        escore_total >= 5  & escore_total <= 9  ~ "Leve",
        escore_total >= 10 & escore_total <= 14 ~ "Moderada",
        escore_total >= 15 & escore_total <= 19 ~ "Moderadamente Grave",
        escore_total >= 20 & escore_total <= 27 ~ "Grave",
        TRUE ~ NA_character_
      ),
      
      # Ordenar categorias
      severidade = factor(severidade, 
                          levels = c("Mínima", "Leve", "Moderada", 
                                     "Moderadamente Grave", "Grave")),
      
      # Criar faixas etárias
      faixa_etaria = case_when(
        idade >= 18 & idade < 30 ~ "18-29 anos",
        idade >= 30 & idade < 40 ~ "30-39 anos",
        idade >= 40 & idade < 50 ~ "40-49 anos",
        idade >= 50 & idade < 60 ~ "50-59 anos",
        idade >= 60 & idade <= 70 ~ "60-70 anos",
        TRUE ~ "Outra"
      ),
      faixa_etaria = factor(faixa_etaria)
    )
  
  cat("✓ Escores calculados\n")
  cat("✓ Categorias de severidade atribuídas\n\n")
  
  # Salvar dados processados
  if (salvar_resultados) {
    salvar_csv(dados_processados, 
               paste0("resultados/csv/", prefixo_arquivo, "_dados_processados.csv"))
    cat("✓ Dados processados salvos em CSV (encoding: ", ENCODING_EXPORT, ")\n\n", sep = "")
  }
  
  # Retornar dados processados
  return(dados_processados)
}

# ==============================================================================
# 3. GERAR DADOS FICTÍCIOS REALISTAS DO PHQ-9
# ==============================================================================

set.seed(2025)  # Para reprodutibilidade

# Função para gerar respostas realistas
gerar_resposta_phq9 <- function(n) {
  probs <- c(0.50, 0.25, 0.15, 0.10)  # Distribuição realista
  sample(0:3, size = n, replace = TRUE, prob = probs)
}

# Criar dataset com 100 respondentes
n_respondentes <- 100

dados_phq9 <- tibble(
  id = 1:n_respondentes,
  idade = sample(18:70, n_respondentes, replace = TRUE),
  sexo = sample(c("M", "F"), n_respondentes, replace = TRUE, prob = c(0.48, 0.52))
)

# Gerar respostas para os 9 itens
itens_phq9 <- paste0("PHQ9_", 1:9)

for(item in itens_phq9) {
  dados_phq9[[item]] <- gerar_resposta_phq9(n_respondentes)
}

cat("✓ Dados fictícios gerados com sucesso!\n")
cat(sprintf("  - Total de respondentes: %d\n", n_respondentes))
cat(sprintf("  - Idade: %d a %d anos\n", min(dados_phq9$idade), max(dados_phq9$idade)))
cat(sprintf("  - Sexo: %d Masculino, %d Feminino\n\n", 
            sum(dados_phq9$sexo == "M"), sum(dados_phq9$sexo == "F")))

# ==============================================================================
# 4. PROCESSAR DADOS USANDO A FUNÇÃO
# ==============================================================================

dados_phq9 <- analisar_phq9(dados_phq9, 
                            gerar_graficos = FALSE, 
                            salvar_resultados = TRUE,
                            prefixo_arquivo = "PHQ9_analise")

# ==============================================================================
# 5. ANÁLISE DE ITENS INDIVIDUAIS
# ==============================================================================

cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")
cat("ANÁLISE DE ITENS INDIVIDUAIS DO PHQ-9\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n\n")

# Criar tabela com descrição de cada item
descricao_itens <- tibble(
  Item = paste0("PHQ9_", 1:9),
  Descrição = c(
    "1. Pouco interesse ou prazer em fazer as coisas",
    "2. Sentindo-se para baixo, deprimido ou sem esperança",
    "3. Problemas para dormir ou dormir demais",
    "4. Sentindo-se cansado ou com pouca energia",
    "5. Falta de apetite ou comendo demais",
    "6. Sentindo-se mal consigo mesmo",
    "7. Problemas de concentração",
    "8. Lentidão ou agitação psicomotora",
    "9. Pensamentos de morte ou autolesão"
  )
)

# Calcular estatísticas por item
analise_itens <- dados_phq9 %>%
  select(PHQ9_1:PHQ9_9) %>%
  pivot_longer(everything(), names_to = "Item", values_to = "Resposta") %>%
  group_by(Item) %>%
  summarise(
    N = n(),
    Média = mean(Resposta, na.rm = TRUE),
    DP = sd(Resposta, na.rm = TRUE),
    Mediana = median(Resposta, na.rm = TRUE),
    Mínimo = min(Resposta, na.rm = TRUE),
    Máximo = max(Resposta, na.rm = TRUE),
    `% Zero` = sum(Resposta == 0) / n() * 100,
    `% Três` = sum(Resposta == 3) / n() * 100,
    .groups = "drop"
  ) %>%
  left_join(descricao_itens, by = "Item") %>%
  mutate(across(where(is.numeric), ~round(.x, 2))) %>%
  arrange(desc(Média))  # Ordenar por média decrescente

cat("5.1. ESTATÍSTICAS POR ITEM (Ordenado por Prevalência)\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n\n")
print(as.data.frame(analise_itens))
cat("\n")

# Identificar os 3 itens mais prevalentes
top3_itens <- analise_itens %>%
  slice_head(n = 3) %>%
  select(Item, Descrição, Média)

cat("5.2. SINTOMAS MAIS PREVALENTES (Top 3)\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n\n")
for(i in 1:nrow(top3_itens)) {
  cat(sprintf("%d. %s\n   Média: %.2f\n\n", 
              i, top3_itens$Descrição[i], top3_itens$Média[i]))
}

# Salvar análise de itens
salvar_csv(analise_itens, "resultados/csv/PHQ9_analise_itens_detalhada.csv")
cat("✓ Análise de itens salva em: resultados/csv/PHQ9_analise_itens_detalhada.csv\n\n")

# ==============================================================================
# 6. ANÁLISE BIVARIADA
# ==============================================================================

cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")
cat("ANÁLISE BIVARIADA\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n\n")

# 6.1 Teste t: Comparação entre sexos
cat("6.1. COMPARAÇÃO DE ESCORES ENTRE SEXOS (Teste t)\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n\n")

# Estatísticas descritivas por sexo
stats_sexo <- dados_phq9 %>%
  group_by(sexo) %>%
  summarise(
    N = n(),
    Média = mean(escore_total, na.rm = TRUE),
    DP = sd(escore_total, na.rm = TRUE),
    EP = DP / sqrt(N),
    IC95_inferior = Média - 1.96 * EP,
    IC95_superior = Média + 1.96 * EP,
    .groups = "drop"
  ) %>%
  mutate(across(where(is.numeric) & !N, ~round(.x, 2)))

print(as.data.frame(stats_sexo))
cat("\n")

# Realizar teste t independente
teste_t <- t.test(escore_total ~ sexo, data = dados_phq9, var.equal = FALSE)

cat("Teste t de Student para amostras independentes:\n")
cat(sprintf("  t(%.0f) = %.3f\n", as.numeric(teste_t$parameter), as.numeric(teste_t$statistic)))
cat(sprintf("  p-valor = %.4f\n", teste_t$p.value))
cat(sprintf("  IC 95%% da diferença: [%.2f, %.2f]\n", 
            teste_t$conf.int[1], teste_t$conf.int[2]))

if (teste_t$p.value < 0.05) {
  cat("\n  ✓ Diferença estatisticamente significativa (p < 0.05)\n")
  diferenca <- diff(teste_t$estimate)
  genero_maior <- ifelse(diferenca > 0, "Mulheres", "Homens")
  genero_menor <- ifelse(diferenca > 0, "homens", "mulheres")
  cat(sprintf("  → %s apresentam escore %.2f pontos maior que %s\n",
              genero_maior, abs(diferenca), genero_menor))
} else {
  cat("\n  ✗ Não há diferença estatisticamente significativa (p >= 0.05)\n")
}

# Calcular tamanho do efeito (d de Cohen)
d_cohen <- (diff(teste_t$estimate)) / 
  sqrt(((stats_sexo$N[1]-1)*stats_sexo$DP[1]^2 + 
          (stats_sexo$N[2]-1)*stats_sexo$DP[2]^2) / 
         (stats_sexo$N[1] + stats_sexo$N[2] - 2))

# Determinar interpretação do d de Cohen
interpretacao_d <- if (abs(d_cohen) < 0.2) {
  "trivial"
} else if (abs(d_cohen) < 0.5) {
  "pequeno"
} else if (abs(d_cohen) < 0.8) {
  "médio"
} else {
  "grande"
}

cat(sprintf("  d de Cohen = %.3f (%s)\n\n", abs(d_cohen), interpretacao_d))

# 6.2 Correlação: Idade vs Escore Total
cat("6.2. CORRELAÇÃO ENTRE IDADE E ESCORE TOTAL\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n\n")

# Calcular correlação de Pearson
cor_teste <- cor.test(dados_phq9$idade, dados_phq9$escore_total, 
                      method = "pearson")

cat(sprintf("Correlação de Pearson: r = %.3f\n", as.numeric(cor_teste$estimate)))
cat(sprintf("p-valor = %.4f\n", cor_teste$p.value))
cat(sprintf("IC 95%%: [%.3f, %.3f]\n", cor_teste$conf.int[1], cor_teste$conf.int[2]))

if (cor_teste$p.value < 0.05) {
  cat("\n  ✓ Correlação estatisticamente significativa (p < 0.05)\n")
  
  # Determinar intensidade
  intensidade <- if (abs(as.numeric(cor_teste$estimate)) < 0.3) {
    "fraca"
  } else if (abs(as.numeric(cor_teste$estimate)) < 0.7) {
    "moderada"
  } else {
    "forte"
  }
  
  direcao <- ifelse(as.numeric(cor_teste$estimate) > 0, "positiva", "negativa")
  cat(sprintf("  → Correlação %s %s entre idade e escore\n", 
              intensidade, direcao))
} else {
  cat("\n  ✗ Não há correlação estatisticamente significativa (p >= 0.05)\n")
}
cat("\n")

# 6.3 Correlação: Idade vs Escore por Sexo
cat("6.3. CORRELAÇÃO POR SEXO\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n\n")

cor_por_sexo <- dados_phq9 %>%
  group_by(sexo) %>%
  summarise(
    N = n(),
    r = cor(idade, escore_total, use = "complete.obs"),
    p_valor = cor.test(idade, escore_total)$p.value,
    .groups = "drop"
  ) %>%
  mutate(
    Significativo = ifelse(p_valor < 0.05, "Sim", "Não"),
    across(c(r, p_valor), ~round(.x, 4))
  )

print(as.data.frame(cor_por_sexo))
cat("\n")

# Salvar resultados da análise bivariada
resultados_bivariada <- tibble(
  Análise = c("Teste t (M vs F)", "Correlação (idade x escore)", 
              "Correlação Masculino", "Correlação Feminino"),
  Estatística = c(sprintf("t = %.3f", as.numeric(teste_t$statistic)),
                  sprintf("r = %.3f", as.numeric(cor_teste$estimate)),
                  sprintf("r = %.3f", cor_por_sexo$r[cor_por_sexo$sexo == "M"]),
                  sprintf("r = %.3f", cor_por_sexo$r[cor_por_sexo$sexo == "F"])),
  `P-valor` = c(teste_t$p.value, cor_teste$p.value, 
                cor_por_sexo$p_valor[cor_por_sexo$sexo == "M"],
                cor_por_sexo$p_valor[cor_por_sexo$sexo == "F"]),
  Significativo = ifelse(`P-valor` < 0.05, "Sim", "Não")
) %>%
  mutate(`P-valor` = round(`P-valor`, 4))

salvar_csv(resultados_bivariada, "resultados/csv/PHQ9_analise_bivariada.csv")
cat("✓ Resultados bivariados salvos em: resultados/csv/PHQ9_analise_bivariada.csv\n\n")

# ==============================================================================
# 7. VISUALIZAÇÕES AVANÇADAS
# ==============================================================================

cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")
cat("GERANDO VISUALIZAÇÕES AVANÇADAS\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n\n")

# Tema personalizado
tema_phq9 <- theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5, color = "gray40"),
    axis.title = element_text(face = "bold", size = 11),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

# 7.1 Gráfico de barras: Análise de itens individuais
p1 <- analise_itens %>%
  mutate(Item_num = as.numeric(gsub("PHQ9_", "", Item))) %>%
  ggplot(aes(x = reorder(Item, Média), y = Média, fill = Média)) +
  geom_col(alpha = 0.8, color = "white") +
  geom_errorbar(aes(ymin = Média - DP, ymax = Média + DP), 
                width = 0.3, alpha = 0.6) +
  geom_text(aes(label = sprintf("%.2f", Média)), 
            hjust = -0.3, size = 3.5, fontface = "bold") +
  scale_fill_gradient(low = "#3498db", high = "#e74c3c") +
  coord_flip() +
  labs(
    title = "Média de Respostas por Item do PHQ-9",
    subtitle = "Barras de erro representam ± 1 DP",
    x = "Item",
    y = "Média da Resposta (0-3)"
  ) +
  tema_phq9 +
  theme(legend.position = "none") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2)))

# 7.2 Boxplot comparativo: Escore por sexo (com teste estatístico)
p2 <- ggplot(dados_phq9, aes(x = sexo, y = escore_total, fill = sexo)) +
  geom_boxplot(alpha = 0.7, outlier.shape = 21, outlier.size = 2) +
  geom_jitter(width = 0.2, alpha = 0.3, size = 1.5) +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 4, 
               fill = "yellow", color = "darkred") +
  scale_fill_manual(values = c("M" = "#3498db", "F" = "#e74c3c")) +
  labs(
    title = "Comparação de Escores entre Sexos",
    subtitle = sprintf("Teste t: t = %.2f, p = %.4f | d de Cohen = %.3f",
                       as.numeric(teste_t$statistic), teste_t$p.value, abs(d_cohen)),
    x = "Sexo",
    y = "Escore Total PHQ-9 (0-27)",
    caption = "Losango amarelo = média | Pontos = observações individuais"
  ) +
  tema_phq9 +
  theme(legend.position = "none")

# Adicionar linha conectando as médias
medias_sexo <- dados_phq9 %>%
  group_by(sexo) %>%
  summarise(media = mean(escore_total))

p2 <- p2 + 
  geom_segment(data = medias_sexo,
               aes(x = 1, xend = 2, y = media[1], yend = media[2]),
               color = "darkred", linetype = "dashed", alpha = 0.5)

# 7.3 Gráfico de dispersão: Idade vs Escore, colorido por sexo
p3 <- ggplot(dados_phq9, aes(x = idade, y = escore_total, color = sexo)) +
  geom_point(size = 3, alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE, alpha = 0.2) +
  scale_color_manual(values = c("M" = "#3498db", "F" = "#e74c3c"),
                     labels = c("M" = "Masculino", "F" = "Feminino")) +
  labs(
    title = "Relação entre Idade e Escore Total do PHQ-9",
    subtitle = sprintf("Correlação geral: r = %.3f, p = %.4f", 
                       as.numeric(cor_teste$estimate), cor_teste$p.value),
    x = "Idade (anos)",
    y = "Escore Total PHQ-9 (0-27)",
    color = "Sexo",
    caption = "Linhas representam regressão linear com IC 95%"
  ) +
  tema_phq9 +
  theme(legend.position = "right")

# 7.4 Heatmap de respostas por item e respondente
# Selecionar uma amostra aleatória de 30 respondentes para visualização
set.seed(2025)
amostra_ids <- sample(dados_phq9$id, 30)

dados_heatmap <- dados_phq9 %>%
  filter(id %in% amostra_ids) %>%
  select(id, PHQ9_1:PHQ9_9) %>%
  pivot_longer(-id, names_to = "Item", values_to = "Resposta")

p4 <- ggplot(dados_heatmap, aes(x = Item, y = factor(id), fill = factor(Resposta))) +
  geom_tile(color = "white", size = 0.5) +
  scale_fill_manual(values = c("0" = "#2ecc71", "1" = "#f39c12", 
                               "2" = "#e67e22", "3" = "#c0392b"),
                    labels = c("0 = Nunca", "1 = Vários dias", 
                               "2 = >Metade dos dias", "3 = Quase todo dia")) +
  labs(
    title = "Padrão de Respostas ao PHQ-9 (Amostra de 30 Respondentes)",
    subtitle = "Visualização das respostas individuais por item",
    x = "Item do PHQ-9",
    y = "ID do Respondente",
    fill = "Resposta"
  ) +
  tema_phq9 +
  theme(axis.text.y = element_text(size = 6),
        legend.position = "bottom")

# 7.5 Distribuição de severidade por sexo (100% stacked bar)
p5 <- dados_phq9 %>%
  count(sexo, severidade) %>%
  group_by(sexo) %>%
  mutate(prop = n / sum(n) * 100) %>%
  ggplot(aes(x = sexo, y = prop, fill = severidade)) +
  geom_col(position = "fill", alpha = 0.8, color = "white") +
  geom_text(aes(label = sprintf("%.1f%%", prop)),
            position = position_fill(vjust = 0.5),
            size = 3, fontface = "bold") +
  scale_fill_manual(values = c(
    "Mínima" = "#2ecc71",
    "Leve" = "#f39c12",
    "Moderada" = "#e67e22",
    "Moderadamente Grave" = "#e74c3c",
    "Grave" = "#c0392b"
  )) +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Distribuição Proporcional de Severidade por Sexo",
    subtitle = "Comparação percentual das categorias",
    x = "Sexo",
    y = "Proporção",
    fill = "Severidade"
  ) +
  tema_phq9

# 7.6 Violin plot: Distribuição dos escores por faixa etária
p6 <- dados_phq9 %>%
  ggplot(aes(x = faixa_etaria, y = escore_total, fill = faixa_etaria)) +
  geom_violin(alpha = 0.7, draw_quantiles = c(0.25, 0.5, 0.75)) +
  geom_jitter(width = 0.1, alpha = 0.3, size = 1) +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3,
               fill = "yellow", color = "darkred") +
  scale_fill_brewer(palette = "Set3") +
  labs(
    title = "Distribuição de Escores por Faixa Etária",
    subtitle = "Violin plots com quartis (25%, 50%, 75%)",
    x = "Faixa Etária",
    y = "Escore Total PHQ-9 (0-27)",
    caption = "Losango amarelo = média"
  ) +
  tema_phq9 +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1))

# Salvar todos os gráficos
cat("✓ Salvando gráficos avançados...\n")

ggsave("resultados/graficos/PHQ9_AVA_1_analise_itens.png", plot = p1, 
       width = 12, height = 8, dpi = 300)
ggsave("resultados/graficos/PHQ9_AVA_2_comparacao_sexos.png", plot = p2, 
       width = 10, height = 7, dpi = 300)
ggsave("resultados/graficos/PHQ9_AVA_3_idade_escore_dispersao.png", plot = p3, 
       width = 12, height = 7, dpi = 300)
ggsave("resultados/graficos/PHQ9_AVA_4_heatmap_respostas.png", plot = p4, 
       width = 12, height = 10, dpi = 300)
ggsave("resultados/graficos/PHQ9_AVA_5_severidade_sexo_prop.png", plot = p5, 
       width = 10, height = 7, dpi = 300)
ggsave("resultados/graficos/PHQ9_AVA_6_violin_faixa_etaria.png", plot = p6, 
       width = 12, height = 7, dpi = 300)

cat("✓ Todos os gráficos avançados salvos com sucesso!\n\n")

# ==============================================================================
# 8. ANÁLISE DE CONFIABILIDADE (ALFA DE CRONBACH)
# ==============================================================================

cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")
cat("ANÁLISE DE CONFIABILIDADE\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n\n")

# Selecionar apenas os 9 itens
itens_matriz <- dados_phq9 %>%
  select(PHQ9_1:PHQ9_9)

# Calcular alfa de Cronbach
alfa <- psych::alpha(itens_matriz, check.keys = TRUE)

cat("8.1. ALFA DE CRONBACH\n")
cat("-" %>% rep(80) %>% paste(collapse = ""), "\n")
cat(sprintf("Alfa de Cronbach bruto: %.4f\n", alfa$total$raw_alpha))
cat(sprintf("Alfa de Cronbach padronizado: %.4f\n", alfa$total$std.alpha))
cat(sprintf("Número de itens: %d\n", ncol(itens_matriz)))
cat(sprintf("Média inter-item: %.4f\n\n", alfa$total$average_r))

# Interpretação
interpretacao_alfa <- case_when(
  alfa$total$raw_alpha >= 0.90 ~ "Excelente (>= 0.90)",
  alfa$total$raw_alpha >= 0.80 ~ "Bom (0.80 - 0.89)",
  alfa$total$raw_alpha >= 0.70 ~ "Aceitável (0.70 - 0.79)",
  alfa$total$raw_alpha >= 0.60 ~ "Questionável (0.60 - 0.69)",
  alfa$total$raw_alpha >= 0.50 ~ "Pobre (0.50 - 0.59)",
  TRUE ~ "Inaceitável (< 0.50)"
)
cat(sprintf("Interpretação: %s\n\n", interpretacao_alfa))

# Salvar estatísticas de confiabilidade
confiabilidade_resumo <- tibble(
  Métrica = c("Alfa de Cronbach (bruto)", 
              "Alfa de Cronbach (padronizado)",
              "Número de itens", 
              "Média inter-item correlação", 
              "Interpretação"),
  Valor = c(sprintf("%.4f", alfa$total$raw_alpha),
            sprintf("%.4f", alfa$total$std.alpha),
            as.character(ncol(itens_matriz)),  # Usar ncol em vez de alfa$total$n
            sprintf("%.4f", alfa$total$average_r),
            interpretacao_alfa)
)

salvar_csv(confiabilidade_resumo, "resultados/csv/PHQ9_confiabilidade.csv")
cat("✓ Estatísticas de confiabilidade salvas\n\n")

# ==============================================================================
# 9. RELATÓRIO RESUMIDO FINAL
# ==============================================================================

cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")
cat("RELATÓRIO RESUMIDO FINAL\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n\n")

# Criar relatório executivo
relatorio_executivo <- tibble(
  Seção = c(
    "Amostra",
    "",
    "",
    "Escore Total",
    "",
    "",
    "Severidade",
    "",
    "",
    "",
    "",
    "Confiabilidade",
    "Análise Bivariada",
    "",
    "Sintoma Mais Prevalente"
  ),
  Descrição = c(
    "Tamanho da amostra",
    "Idade média (DP)",
    "Distribuição por sexo",
    "Média (DP)",
    "Mediana",
    "Intervalo",
    "Mínima",
    "Leve",
    "Moderada",
    "Moderadamente Grave",
    "Grave",
    "Alfa de Cronbach",
    "Diferença M vs F (teste t)",
    "Correlação idade x escore",
    "Item com maior média"
  ),
  Resultado = c(
    sprintf("N = %d", nrow(dados_phq9)),
    sprintf("%.1f (%.1f) anos", mean(dados_phq9$idade), sd(dados_phq9$idade)),
    sprintf("%d M (%.1f%%) | %d F (%.1f%%)", 
            sum(dados_phq9$sexo == "M"), 
            sum(dados_phq9$sexo == "M")/nrow(dados_phq9)*100,
            sum(dados_phq9$sexo == "F"), 
            sum(dados_phq9$sexo == "F")/nrow(dados_phq9)*100),
    sprintf("%.2f (%.2f)", mean(dados_phq9$escore_total), 
            sd(dados_phq9$escore_total)),
    sprintf("%.0f", median(dados_phq9$escore_total)),
    sprintf("%d - %d", min(dados_phq9$escore_total), 
            max(dados_phq9$escore_total)),
    sprintf("%d (%.1f%%)", 
            sum(dados_phq9$severidade == "Mínima", na.rm = TRUE),
            sum(dados_phq9$severidade == "Mínima", na.rm = TRUE)/nrow(dados_phq9)*100),
    sprintf("%d (%.1f%%)", 
            sum(dados_phq9$severidade == "Leve", na.rm = TRUE),
            sum(dados_phq9$severidade == "Leve", na.rm = TRUE)/nrow(dados_phq9)*100),
    sprintf("%d (%.1f%%)", 
            sum(dados_phq9$severidade == "Moderada", na.rm = TRUE),
            sum(dados_phq9$severidade == "Moderada", na.rm = TRUE)/nrow(dados_phq9)*100),
    sprintf("%d (%.1f%%)", 
            sum(dados_phq9$severidade == "Moderadamente Grave", na.rm = TRUE),
            sum(dados_phq9$severidade == "Moderadamente Grave", na.rm = TRUE)/nrow(dados_phq9)*100),
    sprintf("%d (%.1f%%)", 
            sum(dados_phq9$severidade == "Grave", na.rm = TRUE),
            sum(dados_phq9$severidade == "Grave", na.rm = TRUE)/nrow(dados_phq9)*100),
    sprintf("α = %.3f (%s)", alfa$total$raw_alpha, interpretacao_alfa),
    sprintf("p = %.4f %s", teste_t$p.value, 
            ifelse(teste_t$p.value < 0.05, "(sig.)", "(n.s.)")),
    sprintf("r = %.3f, p = %.4f %s", as.numeric(cor_teste$estimate), cor_teste$p.value,
            ifelse(cor_teste$p.value < 0.05, "(sig.)", "(n.s.)")),
    sprintf("%s (M = %.2f)", top3_itens$Descrição[1], top3_itens$Média[1])
  )
)

print(as.data.frame(relatorio_executivo))
cat("\n")

salvar_csv(relatorio_executivo, "resultados/csv/PHQ9_relatorio_executivo.csv")
cat("✓ Relatório executivo salvo\n\n")

# ==============================================================================
# 10. SUMÁRIO DE ARQUIVOS GERADOS
# ==============================================================================

cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")
cat("ANÁLISE CONCLUÍDA COM SUCESSO!\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n\n")

cat("ARQUIVOS CSV GERADOS:\n")
cat("────────────────────\n")
cat("  1. resultados/csv/PHQ9_analise_dados_processados.csv - Dataset completo processado\n")
cat("  2. resultados/csv/PHQ9_analise_itens_detalhada.csv - Estatísticas por item\n")
cat("  3. resultados/csv/PHQ9_analise_bivariada.csv - Resultados de testes estatísticos\n")
cat("  4. resultados/csv/PHQ9_confiabilidade.csv - Alfa de Cronbach e métricas\n")
cat("  5. resultados/csv/PHQ9_relatorio_executivo.csv - Resumo executivo completo\n\n")

cat("GRÁFICOS PNG GERADOS (300 DPI):\n")
cat("────────────────────────────────\n")
cat("  1. resultados/graficos/PHQ9_AVA_1_analise_itens.png - Média por item\n")
cat("  2. resultados/graficos/PHQ9_AVA_2_comparacao_sexos.png - Boxplot com teste t\n")
cat("  3. resultados/graficos/PHQ9_AVA_3_idade_escore_dispersao.png - Dispersão com regressão\n")
cat("  4. resultados/graficos/PHQ9_AVA_4_heatmap_respostas.png - Padrão de respostas\n")
cat("  5. resultados/graficos/PHQ9_AVA_5_severidade_sexo_prop.png - Distribuição proporcional\n")
cat("  6. resultados/graficos/PHQ9_AVA_6_violin_faixa_etaria.png - Violin plots por idade\n\n")

cat("PRINCIPAIS ACHADOS:\n")
cat("───────────────────\n")
cat(sprintf("• Escore médio: %.2f (DP = %.2f)\n", 
            mean(dados_phq9$escore_total), sd(dados_phq9$escore_total)))
cat(sprintf("• Alfa de Cronbach: %.3f (%s)\n", 
            alfa$total$raw_alpha, interpretacao_alfa))
cat(sprintf("• Diferença entre sexos: p = %.4f %s\n", 
            teste_t$p.value, 
            ifelse(teste_t$p.value < 0.05, "(significativo)", "(não significativo)")))
cat(sprintf("• Correlação idade-escore: r = %.3f, p = %.4f %s\n",
            as.numeric(cor_teste$estimate), cor_teste$p.value,
            ifelse(cor_teste$p.value < 0.05, "(significativo)", "(não significativo)")))
cat(sprintf("• Sintoma mais prevalente: %s (M = %.2f)\n",
            gsub("\\d+\\. ", "", top3_itens$Descrição[1]), top3_itens$Média[1]))

cat("\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")
cat("Para gerar o relatório em PDF, execute: rmarkdown::render('relatorio_phq9.Rmd')\n")
cat("=" %>% rep(80) %>% paste(collapse = ""), "\n")

################################################################################
# FIM DO SCRIPT
################################################################################