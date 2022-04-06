## ----setup, include=FALSE---------------------------------
knitr::opts_chunk$set(
  echo = TRUE,
  message = FALSE,
  warning = FALSE,
  fig.align = "center",
  cache = TRUE
)


## ---------------------------------------------------------
library(sf)
library(geobr)
library(ggplot2)
library(dplyr)
# remotes::install_github("abjur/abjData")
library(abjData)


## ---------------------------------------------------------
knitr::kable(geobr::list_geobr())


## ---------------------------------------------------------
# geobr::read_country() # importa a delimitação do Brasil

# geobr::read_state() # importa a delimitação dos estados do Brasil

# geobr::read_state("DF") # importa a delimitação de um Estado específico, usando a sigla

# geobr::read_municipality() # importa a delimitação de todos os municípios do Brasil. É uma base mais pesada!

# geobr::read_municipality(code_muni = 3550308) # importa a delimitação de um município específico, usando o código do IBGE do município.


## ---------------------------------------------------------
estados <- readr::read_rds("../dados/geobr/estados.Rds")

# Como obter essa mesma base?
# estados <- geobr::read_state()



## ---------------------------------------------------------
estado_df <- readr::read_rds("../dados/geobr/estado_df.Rds")

# Como obter essa mesma base?
# estado_df <- geobr::read_state("DF")



## ---------------------------------------------------------
class(estados)


## ---------------------------------------------------------
estados %>%
  ggplot() +
  geom_sf()



## ---------------------------------------------------------
ggplot() +
  geom_sf(data = estados) +
  geom_sf(data = estado_df, fill = "blue") +
  theme_bw()


## ---------------------------------------------------------
glimpse(estados)


## ---------------------------------------------------------
estados %>% 
  filter(name_region == "Nordeste") %>% 
  ggplot() +
  geom_sf() 


## ---------------------------------------------------------
class(abjData::pnud_uf)

pnud_uf_sf <- estados %>% 
  left_join(abjData::pnud_uf, by = c("code_state" = "uf")) 

class(pnud_uf_sf)


## ---------------------------------------------------------
# glimpse(pnud_uf_sf)

pnud_uf_sf  %>% 
  ggplot(aes(fill = idhm)) +
  geom_sf() +
  theme_void()


## ---------------------------------------------------------
library(magrittr)
library(dplyr)
library(ggplot2)


## ---------------------------------------------------------
escolas_brasilia <- readr::read_rds("../dados/geobr/escolas_brasilia.Rds")

# Como obter essa mesma base?
# escolas <- geobr::read_schools()
# escolas_brasilia <- escolas %>% 
#   filter(abbrev_state == "DF", name_muni == "Brasília") 


## ---------------------------------------------------------
municipio_brasilia <- readr::read_rds("../dados/geobr/municipio_brasilia.Rds")

# Como obter essa mesma base?
# municipio_brasilia <- geobr::read_municipality(5300108)


## ---------------------------------------------------------
ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = escolas_brasilia) 


## ---------------------------------------------------------
ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = escolas_brasilia, aes(color = government_level)) 


## ---------------------------------------------------------
ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = escolas_brasilia, aes(color = government_level)) + 
  facet_wrap(~ government_level)


## ---------------------------------------------------------
ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = escolas_brasilia, aes(color = government_level), show.legend = FALSE) + 
  facet_wrap(~ government_level) +
  theme_void() + 
  labs(title = "Escolas em Brasília \n") + 
  theme(plot.title = element_text(hjust = 0.5))


## ---------------------------------------------------------
library(sf)
library(geobr)
library(magrittr)


## ---------------------------------------------------------

# Link que disponibiliza a base
# u_shp <- "https://www.gov.br/infraestrutura/pt-br/centrais-de-conteudo/rodovias-zip"

# Cirar a pasta para baixar o arquivo
# dir.create("../dados/shp_rod")

# Fazer o download do arquivo zip
# httr::GET(u_shp,
#           httr::write_disk("../dados/shp_rod/rodovias.zip"),
#           httr::progress())

# Descompactar o zip
# unzip("../dados/shp_rod/rodovias.zip", exdir = "../dados/shp_rod/")


# Importar a base em arquivo .shp
# rodovias <-
#   st_read(
#     "../dados/shp_rod/rodovias.shp",
#     quiet = TRUE#,
#     #options = "ENCODING=WINDOWS-1252"
#   ) %>%
#   # limpar o nome das colunas
#   janitor::clean_names()

# filtrar para DF

# rodovias_df <- rodovias %>% 
#   filter(sg_uf == "DF") 



## ---------------------------------------------------------
rodovias_df <- readr::read_rds("../dados/rodovias_df.Rds")


## ---------------------------------------------------------
ggplot() +
  geom_sf(data = rodovias_df)


## ---------------------------------------------------------
# Inicio do ggplot
ggplot() +
  # limite do estado
  geom_sf(data = estado_df, color = "gray") +
  # escolas
  geom_sf(data = escolas_brasilia, aes(color = government_level), show.legend = FALSE) +
  # rodovias
  geom_sf(data = rodovias_df, color = "black") +
  # adicionar tema
  theme_void()

