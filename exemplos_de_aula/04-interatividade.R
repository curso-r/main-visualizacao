library(tidyverse)
library(dados)
library(leaflet)
library(reactable)

## ---- results='asis'-----------------------------------------------------------
reactable(
  mtcarros, 
  compact = TRUE, 
  defaultPageSize = 4, 
  striped = TRUE
)

## ------------------------------------------------------------------------------
p <- ggplot(mtcarros) +
  geom_point(aes(x = peso, y = milhas_por_galao))

plotly::ggplotly(p, height = 400)

## ------------------------------------------------------------------------------

leaflet(height = 300) |> 
  addTiles() |>   # Adiciona a camada gráfica do OpenStreetMap (padrão)
  addMarkers(
    lng = -46.6623969, 
    lat = -23.5581664, 
    popup = "A Curso-R morava aqui antes da pandemia. Agora ela mora no mundo todo!"
  )
