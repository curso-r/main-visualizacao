## ---------------------------------------------------------
escolas_brasilia <- readr::read_rds("../dados/geobr/escolas_brasilia.Rds")


## ---------------------------------------------------------
dados_idh_muni <- abjData::pnud_min %>% 
  mutate(code_muni = as.numeric(muni_id))

# unir a base de municipios do geobr com a base de IDH
municipios <- readr::read_rds("../dados/geobr/municipios_todos.rds") %>%
  inner_join(dados_idh_muni)

# se quiser buscar esses dados com o pacote geobr, 
# o código é o seguinte
# municipios <- geobr::read_municipality()


## ---------------------------------------------------------
estado_para_filtrar <- municipios %>%
  dplyr::pull(abbrev_state) %>% 
  unique() %>%
  sample(1)


## ---------------------------------------------------------
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


## ---------------------------------------------------------

### transformador de numeros em cores
pal <- colorNumeric("YlOrRd", filter(municipios, ano == 2010)$idhm)
pal(0.7)
pal(0.81)

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
