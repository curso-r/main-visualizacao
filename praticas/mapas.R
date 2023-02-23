# pacotes -----------------------------------------------------------------

library(tidyverse)
library(sf)
library(geobr) # dados georreferenciados
# remotes::install_github("abjur/abjData")
library(abjData) # bases de dados




# geobr -------------------------------------------------------------------

geobr::list_geobr() |> View()

read_country() 
read_state()
read_state("SP")
read_municipality("SP")
read_municipality(3513801)


# unir dados --------------------------------------------------------------

abjData::pnud_min |> View()

dados_geobr <- geobr::read_municipality("MA")



dados_com_pnud <- dados_geobr |> 
  mutate(code_muni = as.character(code_muni)) |> 
  left_join(pnud_min, by = c("code_muni" = "muni_id")) |> 
  filter(ano == 2010)
  

# colocar em um gráfico ---------------------------------------------------

dados_com_pnud |> 
  ggplot() +
  geom_sf()


dados_com_pnud |> 
  ggplot() +
  geom_sf(aes(fill =  idhm)) +
  theme_bw()



# destacar com repel ------------------------------------------------------

dados_com_pnud |> 
  filter(stringr::str_starts(name_muni, "Pedreiras")) |> 
  ggplot() + 
  geom_sf(data = dados_com_pnud) +
  geom_sf(fill = "royalblue") +
  ggrepel::geom_label_repel(
    aes(x = lon, y = lat, label = muni_nm), 
    size = 3, nudge_y = 10, nudge_x = 3, arrow = arrow(type = "closed",
                                                       length = unit(0.3, "cm"))
  )


br <- read_country()

dados_com_pnud |> 
  filter(stringr::str_starts(name_muni, c("Santa"))) |> 
  ggplot() + 
  # geom_sf(data = br) + 
  geom_sf(data = dados_com_pnud) +
  geom_sf(fill = "royalblue") #+
  # ggrepel::geom_label_repel(
  #   aes(x = lon, y = lat, label = muni_nm), 
  #   size = 3, 
  #   arrow = arrow(type = "closed", length = unit(0.3, "cm"))
  # )


# ggspatial ---------------------------------------------------------------

dados_com_pnud |> 
  ggplot() +
  geom_sf(aes(fill = idhm), color = "black", size = 0.1) +
  scale_fill_viridis_b(option = "A", begin = 0.1, end = 0.9) +
  theme_void() +
  ggspatial::annotation_scale(location = "br") + 
  ggspatial::annotation_north_arrow(location = "tr") # tr/ tl / br/ bl



# importante: tratar os dados antes para o join dar certo!!
"IGARAPÉ DO MEIO" |> 
  stringr::str_to_lower() |> 
  abjutils::rm_accent()




# leaflet -----------------------------------------------------------------
library(leaflet)

dados_com_pnud |> 
  leaflet() |> 
  addTiles() |> 
  addMarkers(lng = ~lon, lat = ~lat, popup = ~muni_nm, clusterOptions = markerClusterOptions())



providers$Thunderforest.SpinalMap


estado_ma <- read_state("MA")

dados_com_pnud |>
  leaflet() |>
  addProviderTiles(provider = providers$Esri.WorldImagery) |>
  addPolygons(
    data = leaflet::getMapData(leaflet::leaflet(estado_ma)),
    fill = "white", color = "black"
  ) |> 
  addMarkers(
    lng = ~ lon,
    lat = ~ lat,
    popup = ~ muni_nm,
    clusterOptions = markerClusterOptions()
  )
