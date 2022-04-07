library(tidyverse)
library(leaflet)
library(dados)
library(abjData) # remotes::install_github("abjur/abjData")

# dados -------------------------------------------------------------------

dados_geobr <- geobr::read_municipality("SC")
## Se a internet não contribuir, rode
# dados_geobr <- readr::read_rds("dados/geobr/dados_geobr.rds")

dados_com_pnud <- dados_geobr |> 
  mutate(muni_id = as.character(code_muni)) |> 
  inner_join(pnud_min, by = "muni_id") |> 
  filter(ano == 2010)

## ---------------------------------------------------------
dados_com_pnud |> 
  # adiciona leaflet vazio
  leaflet() |> 
  # adiciona mapinha
  addTiles() |> 
  # adiciona marcadores
  addMarkers(
    lng = ~lon,
    lat = ~lat,
    popup = ~muni_nm,
    clusterOptions = markerClusterOptions()
  )


## ---------------------------------------------------------

### transformador de numeros em cores
pal <- colorNumeric("YlOrRd", dados_com_pnud$idhm)
pal(0.7)
pal(0.81)

dados_com_pnud %>% 
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
