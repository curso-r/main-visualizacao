library(tidyverse)
library(dados)
library(gghighlight)
library(patchwork)
library(ggrepel)
library(ggridges)

# 1) Abaixo temos dois gráficos referentes aos filmes da Pixar:

# Gráfico da bilheteria em dólares
grafico_bilheteria <- pixar_bilheteria |>
  left_join(pixar_filmes, by = "filme") |>
  ggplot() +
  geom_point(aes(y = bilheteria_mundial, x = data_lancamento)) +
  scale_y_continuous(labels = scales::dollar) +
  ggthemes::theme_solarized() +
  labs(x = "Ano de lançamento", y = "Bilheteria mundial (em dólares)")

grafico_bilheteria

# Gráfico da nota segundo o público

grafico_notas <- pixar_avalicao_publico |>
  left_join(pixar_filmes, by = "filme") |>
  ggplot() +
  geom_point(aes(y = nota_rotten_tomatoes, x = data_lancamento)) +
  ggthemes::theme_solarized() +
  scale_y_continuous(limits = c(0, 100)) +
  labs(x = "Ano de lançamento", y = "Nota no site Rotten Tomatoes")

grafico_notas

# a) Destaque no gráfico de bilheteria, usando gghighlight,
# os filmes que foram lançados de 2020 em diante:
grafico_bilheteria_2020_em_diante <- grafico_bilheteria  #+
  # a....

grafico_bilheteria_2020_em_diante

# b) Destaque no gráfico de avaliação do público, usando gghighlight,
# os filmes que foram lançados de 2020 em diante:
grafico_notas_2020_em_diante <- grafico_notas #+
  # b....

grafico_notas_2020_em_diante

# c) Vamos ver esses gráficos lado a lado?
# Use o pacote pathwork e una os gráficos criados 
# nos exercícios (a) e (b)

# d) Como você interpretaria esses dois gráficos?

# 2) O gráfico abaixo apresenta os filmes da pixar,
# segundo a bilheteria e com o nome dos seus filmes.
# Porém os rótulos ficaram uns em cima dos outros!!
# Tente melhorar essa visualização para que os rótulos
# não fiquem dessa forma.

pixar_bilheteria |>
  left_join(pixar_filmes, by = "filme") |>
  mutate(bilheteria_mundial_milhoes = bilheteria_mundial / 1000000) |> 
  ggplot(aes(y = bilheteria_mundial_milhoes, x = data_lancamento)) +
  geom_point() +
  scale_y_continuous(labels = scales::dollar) +
  ggthemes::theme_solarized() +
  labs(x = "Ano de lançamento", y = "Bilheteria mundial (em milhões de dólares)") +
  geom_label(aes(label = filme))

# 3) No gráfico abaixo, descomente e substitua os ... no código. 
# use o ggtext para substituir os nomes dos personagens
# pelas suas fotos! 
# Dica: lembre-se que pelo glue() é possível inserir uma variável,
# por exemplo variavel <- 2; glue::glue('texto texto {variavel}')
# retorna 'texto texto 2'.
# Obs: O gráfico pode demorar um pouco para carregar!
# referencia: exercicios/03-starwars.png

img_starwars <- dados_starwars |> 
  mutate(img = case_when(
    nome == "Luke Skywalker" ~ "exercicios/star_wars/luke.jpeg",
    nome == "Leia Organa" ~ "exercicios/star_wars/leia.jpeg",
    nome == "Han Solo" ~ "exercicios/star_wars/hansolo.jpeg"
  )) |>  
  drop_na(img) 

img_starwars |>
  ggplot() +
  geom_col(aes(y = nome, x = massa, fill = nome), show.legend = FALSE) +
  scale_fill_brewer(palette = "Set1") +
  ggthemes::theme_economist() +
  labs(x = "Massa") #+
# scale_y_discrete(
# name = NULL,
# labels = glue::glue("<img src='...'  width='...' >")
# ) +
#  theme(... = ...)


# 4) O código abaixo apresenta histogramas do comprimento
# do bico dos pinguins da base Palmer Penguins.
# Transforme esse gráfico usando o pacote ggridges,
# e também remova o facet.
# referencia: exercicios/03-pinguins_histogram.png

pinguins |>
  ggplot(aes(
    x = comprimento_bico,
    fill = especie
  )) +
  scale_fill_brewer(palette = "Set2") +
  ggthemes::theme_solarized() + 
  labs(x = "Comprimento do bico", y = "Espécie") +
  geom_histogram(show.legend = FALSE) + 
  facet_wrap(~especie, nrow = 3)

