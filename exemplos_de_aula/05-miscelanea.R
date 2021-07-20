library(sf)
library(dplyr)
library(leaflet)
library(plotly)
library(highcharter)
library(reactable)
# para o gganimate funcionar perfeitamente, instale também
# install.packages(c("gifski", "av"))
library(gganimate)
library(patchwork)
library(ggrepel)


# dados -------------------------------------------------------------------

## codigos da aula de mapas

# escolas de brasilia
escolas_brasilia <- readr::read_rds("dados/geobr/escolas_brasilia.Rds")

# IDH dos municipios
dados_idh_muni <- abjData::pnud_min %>% 
  mutate(code_muni = as.numeric(muni_id))

# unir a base de municipios do geobr com a base de idh
municipios <- readr::read_rds("dados/geobr/municipios_todos.rds") %>%
  inner_join(dados_idh_muni)

# se quiser buscar esses dados com o pacote geobr, 
# o código é o seguinte
# municipios <- geobr::read_municipality()


# htmlwidgets =============================================================

# leaflet -----------------------------------------------------------------

## O leaflet ajuda a fazer mapas interativos, em uma sintaxe muito parecida
## com o ggplot2. Você inicia com um mapa vazio e vai adicionando layers.

## Mapa de pontos

escolas_brasilia %>%
  # adiciona leaflet vazio
  leaflet() %>%
  # adiciona mapinha
  addTiles() %>%
  # adiciona marcadores
  addMarkers(
    popup = ~ name_school,
    clusterOptions = markerClusterOptions()
  )

## mapa temático ---

### transformador de numeros em cores
pal <- colorNumeric("YlOrRd", filter(municipios, ano == 2010)$idhm)
pal(0.7)
pal(0.81)


# Sortear um estado para filtrar
estado_para_filtrar <- municipios$abbrev_state %>%
  unique() %>%
  tibble::as_tibble() %>%
  dplyr::sample_n(1) %>% 
  dplyr::pull(value)

municipios %>% 
  # filtrar para o ano de 2010, e apenas 1 estado
  dplyr::filter(ano == 2010, abbrev_state == estado_para_filtrar) %>% 
  # adiciona mapa vazio
  leaflet() %>% 
  # adiciona mapinha
  addTiles() %>% 
  # adiciona shapes
  addPolygons(
    label = ~muni_nm, 
    weight = 1,
    color = "black",
    fillColor = ~pal(idhm),
    fillOpacity = .8
  )

# plotly ------------------------------------------------------------------

## https://plot.ly é uma empresa bem grande de visualização de dados.
## Eles produzem ferramentas para R, python, JavaScript
## e têm uma solução própria para fazer dashboards.

## Para essa parte, vamos nos limitar ao ggplotly(), que é um transformador
## de ggplot em plotly:

gg_idhm <- municipios %>% 
  ggplot(aes(x = gini, y = idhm, colour = espvida)) +
  geom_point() +
  facet_wrap(~ano)

plotly::ggplotly(gg_idhm)

# highcharter -------------------------------------------------------------

## https://www.highcharts.com também é uma grande empresa de visualização
## O {highcharter} é uma adaptação do highcharts para R
## Assim como no plotly, o highcharter tenta se aproximar da linguagem R
## através do ggplot2. No entanto, a abordagem é diferente: é fornecida
## uma sintaxe parecida com o ggplot2, com algumas adaptações.

municipios %>% 
  filter(ano == 2010, abbrev_state == estado_para_filtrar) %>% 
  hchart("scatter", hcaes(x = gini, y = idhm, color = espvida))

## para graficos univariados, basta passar o vetor

### histograma
municipios %>% 
  pull(gini) %>% 
  hchart()

### densidade
municipios %>% 
  pull(gini) %>% 
  density() %>% 
  hchart()

# reactable ---------------------------------------------------------------

## {reactable} e {DT} são os melhores pacotes para fazer tabelas 
## interativas. Aqui, vamos mostrar o {reactable}

# tabela base

dados_summ <- municipios %>% 
  as_tibble() %>% 
  group_by(ano, abbrev_state) %>% 
  summarise(
    pop = sum(pop),
    gini = mean(gini),
    .groups = "drop"
  ) %>% 
  tidyr::pivot_wider(
    names_from = ano, 
    values_from = c(pop, gini)
  )
# criando a tabela 
dados_summ %>%
  reactable(
    columns = list(
      abbrev_state = colDef("Estado"),
      pop_1991 = colDef("1991", format = colFormat(separators = TRUE)),
      pop_2000 = colDef("2000", format = colFormat(separators = TRUE)),
      pop_2010 = colDef("2010", format = colFormat(separators = TRUE)),
      gini_1991 = colDef("1991", format = colFormat(digits = 3)),
      gini_2000 = colDef("2000", format = colFormat(digits = 3)),
      gini_2010 = colDef("2010", format = colFormat(digits = 3))
    ),
    columnGroups = list(
      colGroup(
        name = "População",
        columns = c("pop_1991", "pop_2000", "pop_2010")
      ),
      colGroup(
        name = "Índice de Gini",
        columns = c("gini_1991", "gini_2000", "gini_2010")
      )
    )
  )

# extensoes ggplot2 =======================================================

# ggalt e gghighlight --------------------------------------------

# geom_encircle é interessante para destacar pontos distantes da nuvem de pontos

library(ggalt)
# install.packages("remotes")
# remotes::install_github("cienciadedatos/dados")
library(dados)

dados <- clima %>% 
  filter(origem == "JFK") %>% 
  group_by(dia_do_ano = lubridate::floor_date(data_hora, "day")) %>% 
  summarise(temperatura = min(temperatura))

dia_estranho <- dados %>% 
  filter(dia_do_ano == as.Date("2013-05-08"))

dados %>% 
  ggplot(aes(x = dia_do_ano, y = temperatura)) + 
  geom_point() + 
  ggalt::geom_encircle(
    data = dia_estranho, 
    color = "red", s_shape = .1, expand = .01, size = 3
  )

# Também é possível obter resultados similares usando gghighlight

# dados %>% 
#   mutate(dia_do_ano = as.Date(dia_do_ano)) %>% 
#   ggplot(aes(x = dia_do_ano, y = temperatura)) + 
#   geom_point() + 
#   gghighlight::gghighlight(
#     dia_do_ano == "2013-05-08" & temperatura < 20,
#     label_key = dia_do_ano,
#     label_params = list(size = 10)
#   ) +
#  geom_label(aes(label = dia_do_ano), vjust = -1)

## ggrepel -------------------------

mtcars %>% 
  tibble::rownames_to_column() %>% 
  ggplot(aes(disp, mpg)) +
  geom_point() +
  # geom_label(aes(label = rowname))
  ggrepel::geom_label_repel(aes(label = rowname))


# gganimate ---------------------------------------------------------------

## gganimate transforma um conjunto de gráficos em animações
## Geralmente é usado para substituir facets por animações

anim <- municipios %>% 
  filter(abbrev_state == estado_para_filtrar) %>% 
  mutate(ano = as.numeric(ano)) %>% 
  ggplot(aes(rdpc, espvida, size = sqrt(pop))) +
  geom_point() +
  facet_wrap(~abbrev_state) +
  scale_x_log10() +
  # Aqui começa o gganimate
  labs(title = 'Ano: {frame_time}', x = 'Renda', y = 'Expectativa de vida') +
  transition_time(ano)

## mostrar o gif!
animate(anim, nframes = 20, width = 800, height = 400)

## salvar o gif
animate(
  anim, 
  width = 800, height = 400, 
  nframes = 20,
  duration = 10, 
  fps = 2, 
  detail = 1,
  gifski_renderer("exemplos_de_aula/gif.gif")
)

## salvar em video
animate(
  anim, 
  width = 800, height = 400, 
  nframes = 20,
  duration = 10, 
  fps = 2, 
  detail = 1,
  av_renderer("exemplos_de_aula/video.mp4")
)

## Mapa

### install.packages("transformr")
anim <- municipios %>% 
  filter(abbrev_state == estado_para_filtrar) %>% 
  mutate(ano = as.numeric(ano)) %>% 
  ggplot(aes(fill = idhm)) +
  geom_sf(colour = "black", size = .1) +
  theme_void(12) +
  labs(title = 'Ano: {frame_time}') +
  transition_time(ano) +
  enter_fade()

animate(
  anim, nframes = 20, fps = 8,
  width = 800, height = 400
)

## Salvar o gif
animate(
  anim, 
  width = 800, height = 400, 
  nframes = 20,
  duration = 5, 
  fps = 4, 
  detail = 1,
  gifski_renderer("~/Downloads/gif.gif")
)
