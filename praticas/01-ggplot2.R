# Isso é uma opção que evita mostrar os números com notação científica
options(scipen = 999)


# Carregar pacotes --------------------------------------------------------

library(tidyverse)

# Ler base IMDB -----------------------------------------------------------

imdb <- read_rds("dados/imdb.rds")

imdb <- imdb |> 
  mutate(lucro = receita - orcamento)


# Gráfico de pontos (dispersão) -------------------------------------------

# Apenas o canvas
imdb |>
  ggplot()

# Salvando em um objeto
p <- imdb |>
  ggplot()

# Gráfico de dispersão da receita contra o orçamento
imdb |>
  ggplot() +
  geom_point(aes(x = orcamento, y = receita))

# Inserindo uma reta horizontal: filmes com receita maior que 1 milhão!
imdb |>
  ggplot() +
  geom_point(aes(x = orcamento, y = receita)) +
  geom_hline(yintercept = 1000000, color = "red", linetype = 2)

# Observe como cada elemento é uma camada do gráfico.
# Agora colocamos a camada da linha antes da camada
# dos pontos.
imdb |>
  ggplot() +
  geom_hline(yintercept = 1000000, color = "red", linetype = 2) +
  geom_point(aes(x = orcamento, y = receita))

# Atribuindo a variável lucro aos pontos
imdb |>
  ggplot() +
  geom_point(aes(x = orcamento, y = receita, color = lucro))

# Categorizando o lucro antes
imdb |>
  drop_na(lucro)  |>
  mutate(
    lucrou = ifelse(lucro <= 0, "Não", "Sim")
  ) |>
  ggplot() +
  geom_point(aes(x = orcamento, y = receita, color = lucrou))

# Salvando um gráfico em um arquivo
imdb |>
  drop_na(lucro)  |>
  mutate(
    lucrou = ifelse(lucro <= 0, "Não", "Sim")
  ) |>
  ggplot() +
  geom_point(aes(x = orcamento, y = receita, color = lucrou), alpha = 0.5)

# se você não especificar essas parâmetros,  ele salva por default do jeito 
# que ta na sua tela do R
ggsave("meu_grafico.png")

# podemos especificar o tamanho
ggsave("meu_grafico.png", 
       dpi = 300, # resolucao
       width = 7, # largura
       height = 5 # altura
) 

# Filosofia ---------------------------------------------------------------

# Um gráfico estatístico é uma representação visual dos dados 
# por meio de atributos estéticos (posição, cor, forma, 
# tamanho, ...) de formas geométricas (pontos, linhas,
# barras, ...). Leland Wilkinson, The Grammar of Graphics

# Layered grammar of graphics: cada elemento do 
# gráfico pode ser representado por uma camada e 
# um gráfico seria a sobreposição dessas camadas.
# Hadley Wickham, A layered grammar of graphics 

# Gráfico de linhas -------------------------------------------------------

# Nota média dos filmes ao longo dos anos

imdb |>
  group_by(ano) |>
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) |>
  ggplot() +
  geom_line(aes(x = ano, y = nota_media))

# Número de filmes por ano 

imdb |>
  filter(!is.na(ano), ano != 2020) |>
  group_by(ano) |>
  summarise(num_filmes = n()) |>
  ggplot() +
  geom_line(aes(x = ano, y = num_filmes)) 

# Nota média do Robert De Niro por ano
imdb |>
  filter(str_detect(elenco, "Robert De Niro")) |>
  group_by(ano) |>
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) |>
  ggplot() +
  geom_line(aes(x = ano, y = nota_media))

# Colocando pontos no gráfico
imdb |>
  filter(str_detect(elenco, "Robert De Niro")) |>
  group_by(ano) |>
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) |>
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  geom_point(aes(x = ano, y = nota_media))

# Reescrevendo de uma forma mais agradável
imdb |>
  filter(str_detect(elenco, "Robert De Niro")) |>
  group_by(ano) |>
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) |>
  ggplot(aes(x = ano, y = nota_media)) +
  geom_line() +
  geom_point()

# Colocando as notas no gráfico
imdb |>
  filter(str_detect(elenco, "Robert De Niro")) |>
  group_by(ano) |>
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) |>
  mutate(nota_media = round(nota_media, 1)) |>
  ggplot(aes(x = ano, y = nota_media)) +
  geom_line() +
  geom_label(aes(label = nota_media))


# Gráfico de barras -------------------------------------------------------

# Número de filmes das pessoas que dirigiram filmes na base
imdb |>
  count(direcao) |>
  slice_max(order_by = n, n = 10) |>
  ggplot() +
  geom_col(aes(x = direcao, y = n))

# Tirando NA e pintando as barras
imdb |>
  count(direcao) |>
  filter(!is.na(direcao)) |>
  slice_max(order_by = n, n = 10) |>
  ggplot() +
  geom_col(
    aes(x = direcao, y = n, fill = direcao),
    show.legend = FALSE
  )

# Invertendo as coordenadas
imdb |>
  count(direcao) |>
  filter(!is.na(direcao)) |>
  slice_max(order_by = n, n = 10) |>
  ggplot() +
  geom_col(
    aes(x = n, y = direcao, fill = direcao),
    show.legend = FALSE
  ) 


# Ordenando as barras
imdb |>
  count(direcao) |>
  filter(!is.na(direcao)) |>
  slice_max(order_by = n, n = 10) |>
  mutate(
    direcao = forcats::fct_reorder(direcao, n)
  ) |>
  ggplot() +
  geom_col(
    aes(x = n, y = direcao, fill = direcao),
    show.legend = FALSE
  ) 

# Colocando label nas barras
top_10_direcao <- imdb |>
  count(direcao) |>
  filter(!is.na(direcao)) |>
  slice_max(order_by = n, n = 10) 

top_10_direcao |>
  mutate(
    direcao = forcats::fct_reorder(direcao, n)
  ) |>
  ggplot() +
  geom_col(
    aes(x = n, y = direcao, fill = direcao),
    show.legend = FALSE
  ) +
  geom_label(aes(x = n/2, y = direcao, label = n)) 


# Histogramas e boxplots --------------------------------------------------

# Histograma do lucro dos filmes do Steven Spielberg 
imdb |>
  filter(direcao == "Steven Spielberg") |>
  ggplot() +
  geom_histogram(aes(x = lucro))

# Arrumando o tamanho das bases
imdb |>
  filter(direcao == "Steven Spielberg") |>
  ggplot() +
  geom_histogram(
    aes(x = lucro), 
    binwidth = 100000000,
    color = "white"
  )

# Boxplot do lucro dos filmes das pessoas que dirigiram
# mais de 15 filmes (que temos informações sobre o lucro)
imdb |>
  drop_na(direcao, lucro) |>
  group_by(direcao) |>
  filter(n() >= 15) |>
  ggplot() +
  geom_boxplot(aes(y = direcao, x = lucro))

# Ordenando pela mediana

imdb |>
  drop_na(direcao, lucro) |>
  group_by(direcao) |>
  filter(n() >= 15) |>
  ungroup() |>
  mutate(
    direcao = forcats::fct_reorder(direcao, lucro, .fun = median)
  ) |>
  ggplot() +
  geom_boxplot(aes(y = direcao, x = lucro))

# Título e labels ---------------------------------------------------------

# Labels
imdb |>
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita, color = lucro)) +
  labs(
    x = "Orçamento ($)",
    y = "Receita ($)",
    color = "Lucro ($)",
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento",
    caption = "Fonte: imdb.com"
  )

# Escalas
imdb |>
  group_by(ano) |>
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) |>
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  scale_x_continuous(breaks = seq(1880, 2020, 10)) +
  scale_y_continuous(breaks = seq(0, 10, 2))

# Visão do gráfico

imdb |>
  group_by(ano) |>
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) |>
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  scale_x_continuous(breaks = seq(1880, 2020, 10), limits = c(1910, 2020)) +
  scale_y_continuous(breaks = seq(0, 10, 2), limits = c(0, 10))


# Cores -------------------------------------------------------------------

# Escolhendo cores pelo nome
imdb |>
  count(direcao) |>
  filter(!is.na(direcao)) |>
  slice_max(order_by = n, n = 5) |>
  ggplot() +
  geom_col(
    aes(x = n, y = direcao, fill = direcao), 
    show.legend = FALSE
  ) +
  scale_fill_manual(values = c("orange", "royalblue", "purple", "salmon", "darkred"))
# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf

# Escolhendo pelo hexadecimal
imdb |>
  count(direcao) |>
  filter(!is.na(direcao)) |>
  slice_max(order_by = n, n = 5) |>
  ggplot() +
  geom_col(
    aes(x = n, y = direcao, fill = direcao), 
    show.legend = FALSE
  ) +
  scale_fill_manual(
    values = c("#ff4500", "#268b07", "#ff7400", "#abefaf", "#33baba")
  )

# Mudando textos da legenda
imdb |>
  mutate(sucesso_nota = case_when(nota_imdb >= 7 ~ "sucesso_nota_imbd",
                                  TRUE ~ "sem_sucesso_nota_imdb")) |>
  group_by(ano, sucesso_nota) |>
  summarise(num_filmes = n()) |>
  ggplot() +
  geom_line(aes(x = ano, y = num_filmes, color = sucesso_nota)) +
  scale_color_discrete(labels = c("Nota menor que 7", "Nota maior ou igual à 7"))

# Definindo cores das formas geométricas
imdb |>
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita), color = "#ff7400")

# Tema --------------------------------------------------------------------

# Temas prontos
imdb |>
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita)) +
  # theme_bw() 
  # theme_classic() 
  # theme_dark()
  theme_minimal()

# A função theme()
imdb |>
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita)) +
  labs(
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  )

