library(tidyverse)
library(forcats)
library(dados)
library(lubridate)
library(ggthemes)

# O objetivo dos exercícios abaixo é praticar conceitos de otimização visual
# usando temas, cores e escalas no ggplot2. 
# Oferecemos um gráfico simples e instruções de como otimizá-lo. 
# Para cada um deles, existe um arquivo .png com o mesmo completo,
# para que você possa comparar/se inspirar.

# 1. Usando o gráfico a seguir, faça os exercícios:
# a) adicione o tema `theme_fivethirtyeight` usando o pacote ggthemes
# b) adicione a escala de cor brewer aos pontos, com a escala
# do tipo qualitativa, e a paleta n.2 . Dica: veja a documentação da função!
# c) adicione um título informativo com a função labs().
# Exemplo de resultado: 02-pinguins.png
pinguins |>
  ggplot() +
  geom_point(aes(
    x = massa_corporal,
    y = comprimento_bico,
    color = especie,
    shape = especie
  ),
  alpha = 0.8) #+
  # a....
  # b ...
  # c ...

# 2. Usando o gráfico a seguir, faça os exercícios:
# a) adicione o tema `theme_solarized` usando o pacote ggthemes
# b) adicione uma escala de cor viridis aos pontos
# c) adicione um limite no eixo x: as notas podem ser de 0 a 100
# d) adicione as legendas corretas com a função labs() .
# e) usando a função theme(), deixe o tamanho dos valores
# dos eixos x e y com o tamanho 8, e o tamanho do texto dos
# títulos dos eixos com tamanho 15.
# Exemplo de resultado: 02-pixar.png
pixar_avalicao_publico |>
  drop_na(nota_rotten_tomatoes) |>
  mutate(filme = forcats::fct_reorder(filme, nota_rotten_tomatoes)) |>
  ggplot() +
  geom_point(
    aes(x = nota_rotten_tomatoes, y = filme, color = nota_rotten_tomatoes),
    size = 5,
    show.legend = FALSE
  ) #+
  # a) ....
  # b) ....
  # c) ....
  # d)...
  # e) ...

# 3. Usando o gráfico a seguir, faça os exercícios:
# a) adicione o tema `theme_hc` usando o pacote ggthemes
# b) altere a legenda do eixo x. Dica: é uma variável datetime.
# configure os argumentos para que apareça as marcações de 
# 3 em 3 meses, e para que os meses apareçam com o formato mes/ano, 
# numérico. Ex: 03/13
# c) adicione a escala de cor manual aos pontos, e use a cor 
# azul claro ("#76A3E6") para representar o dia em que, em média,
# os vôos saíram mais adiantados, e azul escuro para os dias 
# em que os vôos em média saíram mais atrasados.
# d) adicione as legendas corretas com a função labs() .
# e) com a função theme(): centralize o título do gráfico,
# altere a posição da legenda para que ela fique no topo do gráfico 
# (abaixo do título), altere os tamanhos da fonte, usando:
# - tamanho 12 para o título do gráfico
# - tamanho 9 para o título da legenda
# - tamanho 10 para os título dos eixos x e y
# - tamanho 8 para as legendas dos eixos x e y
# - Exemplo de resultado: 02-voos.png

voos |>
  filter(companhia_aerea == "UA") |>
  mutate(dia_mes_ano = lubridate::floor_date(data_hora, "day")) |>
  group_by(dia_mes_ano) |>
  summarise(media_atraso_chegada = mean(atraso_chegada, na.rm = TRUE)) |>
  mutate(voo_atrasou = ifelse(media_atraso_chegada > 0 , "Sim",  "Não")) |>
  ggplot() +
  geom_col(aes(x = dia_mes_ano, y = media_atraso_chegada, fill =  voo_atrasou)) #+
  # a) ....
  # b) ....
  # c) ...
  # d) ...
  # e) ...

