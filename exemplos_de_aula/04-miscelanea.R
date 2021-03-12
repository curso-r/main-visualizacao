library(sf)
library(dplyr)
library(tidyr)
library(leaflet)
library(plotly)
library(highcharter)
library(gtsummary)
library(reactable)
# para o gganimate funcionar perfeitamente, instale também
# install.packages(c("gifski", "av"))
library(gganimate)
library(patchwork)

# gt ----------------------------------------------------------------------

## O {gt} é um extenso trabalho para criar uma gramática de tabelas.
## O gt assume que uma tabela possui os seguintes elementos:
## - o cabeçalho
## - o cantinho (que separa linhas e colunas) 
## - rótulos das colunas (ou grupos de colunas)
## - conteúdo 
## - rodapé.
## Geralmente os códigos do gt são mais longos, mas eles te dão controle
## sobre o que você vai fazer.

## tabela base

dados_summ <- municipios %>% 
  as_tibble() %>% 
  group_by(ano, abbrev_state) %>% 
  summarise(
    pop = sum(pop),
    gini = mean(gini),
    .groups = "drop"
  ) %>% 
  pivot_wider(names_from = ano, values_from = c(pop, gini))

dados_summ %>% 
  # cria tabela base
  gt(rowname_col = "abbrev_state") %>% 
  # adiciona headers
  tab_header(
    title = "População e GINI",
    subtitle = "Região Sul, por ano censitário"
  ) %>% 
  # cantinho
  tab_stubhead("Estado") %>% 
  # rotulos das colunas
  cols_label(
    pop_1991 = "1991",
    pop_2000 = "2000",
    pop_2010 = "2010",
    gini_1991 = "1991",
    gini_2000 = "2000",
    gini_2010 = "2010"
  ) %>% 
  # cria labels de colunas agrupadas
  tab_spanner(
    label = "População",
    columns = starts_with("pop_")
  ) %>% 
  tab_spanner(
    label = "Índice de Gini",
    columns = starts_with("gini_")
  ) %>% 
  # edita colunas
  fmt_number(
    columns = starts_with("pop_"),
    sep_mark = ".", 
    dec_mark = ",", 
    decimals = 0,
    suffixing = "K"
  ) %>% 
  fmt_number(
    columns = starts_with("gini_"),
    sep_mark = ".", 
    dec_mark = ",", 
    decimals = 3
  ) %>% 
  # rodapé
  tab_source_note(
    "Fonte: Atlas do Desenvolvimento Humano (PNUD)"
  )

# gtsummary ---------------------------------------------------------------

## O {gtsummary} é uma simplificação do {gt}, com coisas já pré programadas

municipios %>% 
  as_tibble() %>% 
  select(abbrev_state, pop, gini) %>% 
  tbl_summary(by = "abbrev_state")

## tambem ajuda a fazer sumarios de regressao

modelo <- lm(idhm ~ I(rdpc/1000) + gini, data = municipios)
tbl_regression(modelo)

# htmlwidgets =============================================================

# leaflet -----------------------------------------------------------------

## O leaflet ajuda a fazer mapas interativos, em uma sintaxe muito parecida
## com o ggplot2. Você inicia com um mapa vazio e vai adicionando layers.

## Mapa de pontos

#### codigo da aula de mapas
iqa_cetesb <-
  st_read(
    "dados/shp/VWM_IQA_CETESB_2018_PTOPoint.shp",
    quiet = TRUE,
    options = "ENCODING=WINDOWS-1252"
  ) %>%
  # limpar o nome das colunas
  janitor::clean_names()

iqa_cetesb %>% 
  # adiciona leaflet vazio
  leaflet() %>% 
  # adiciona mapinha
  addTiles() %>% 
  # adiciona marcadores
  addMarkers(
    popup = ~klocal,
    clusterOptions = markerClusterOptions()
  )

## mapa temático

dados_idh_muni <- abjData::pnud_min %>% 
  mutate(code_muni = as.numeric(muni_id))

municipios <- geobr::read_municipality() %>% 
  filter(abbrev_state %in% c("RS", "PR", "SC")) %>% 
  inner_join(dados_idh_muni)

### transformador de numeros em cores
pal <- colorNumeric("YlOrRd", municipios$idhm)
pal(0.7)
pal(0.81)

municipios %>% 
  filter(ano == 2010) %>% 
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
  filter(ano == 2010) %>% 
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

# gganimate ---------------------------------------------------------------

## gganimate transforma um conjunto de gráficos em animações
## Geralmente é usado para substituir facets por animações

anim <- municipios %>% 
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
  gifski_renderer("~/Downloads/gif.gif")
)

## salvar em video
animate(
  anim, 
  width = 800, height = 400, 
  nframes = 20,
  duration = 10, 
  fps = 2, 
  detail = 1,
  av_renderer("~/Downloads/video.mp4")
)

## Mapa

### install.packages("transformr")
anim <- municipios %>% 
  filter(abbrev_state == "PR") %>% 
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
