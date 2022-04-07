## ---------------------------------------------------------
library(sf)
library(geobr)
library(tidyverse)
library(abjData) # remotes::install_github("abjur/abjData")


## ---------------------------------------------------------
# geobr::read_country() # importa a delimitação do Brasil
# geobr::read_state() # importa a delimitação dos estados do Brasil
# geobr::read_state("DF") # importa a delimitação de um Estado específico, usando a sigla
# geobr::read_municipality() # importa a delimitação de todos os municípios do Brasil. É uma base mais pesada!
# geobr::read_municipality(code_muni = 3550308) # importa a delimitação de um município específico, usando o código do IBGE do município.


## ---------------------------------------------------------

dados_geobr <- geobr::read_municipality("SC")
## Se a internet não contribuir, rode
# dados_geobr <- readr::read_rds("dados/geobr/dados_geobr.rds")

dados_com_pnud <- dados_geobr |> 
  mutate(muni_id = as.character(code_muni)) |> 
  inner_join(pnud_min, by = "muni_id") |> 
  filter(ano == 2010)

dados_com_pnud %>%
  ggplot() +
  geom_sf()

ggplot() +
  geom_sf(data = dados_com_pnud, fill = "royalblue") +
  theme_bw()


## ---------------------------------------------------------
dados_com_pnud %>% 
  filter(substr(name_muni, 1, 1) %in% c("A", "Á")) %>% 
  ggplot() +
  geom_sf(data = dados_com_pnud) +
  geom_sf(fill = "royalblue") +
  ggrepel::geom_label_repel(
    aes(x = lon, y = lat, label = muni_nm), 
    size = 3,
    colour = "black",
    alpha = .8
  )

## ---------------------------------------------------------
dados_com_pnud  %>% 
  ggplot(aes(fill = idhm)) +
  geom_sf() +
  theme_void()

## ---------------------------------------------------------

# alguns detalhamentos com o {ggspatial}
dados_com_pnud  %>% 
  ggplot(aes(fill = idhm)) +
  geom_sf(colour = "black", size = .1) +
  scale_fill_viridis_b(option = "A", begin = .1, end = .9) +
  theme_void() +
  ggspatial::annotation_scale() +
  ggspatial::annotation_north_arrow(location = "br")

# animado

dados_com_pnud_anos <- dados_geobr |> 
  mutate(muni_id = as.character(code_muni)) |> 
  inner_join(pnud_min, by = "muni_id") |> 
  mutate(ano = as.numeric(ano))


library(gganimate)
anim <- dados_com_pnud_anos  %>% 
  ggplot(aes(fill = idhm)) +
  geom_sf(colour = "black", size = .1) +
  scale_fill_viridis_b(option = "A", begin = .1, end = .9) +
  theme_void() +
  ggspatial::annotation_scale() +
  ggspatial::annotation_north_arrow(location = "br") +
  labs(title = "Ano: {frame_time}") +
  gganimate::transition_time(ano) +
  gganimate::enter_fade()

gganimate::animate(anim, nframes = 20, width = 800, height = 600)
