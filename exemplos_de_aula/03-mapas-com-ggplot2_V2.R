# Carregar pacotes -------------
library(sf)
library(geobr)
library(ggplot2)
library(dplyr)
library(fs)

# O pacote {sf} (Simple Features for R) (Pebesma 2020, 2018) possibilita
# trabalhar com bases de dados espaciais.

# Importar dados:
## Duas abordagens:
# - Bases que são georreferenciadas
# - Bases que não são georreferenciadas

# Trabalhando com bases georreferenciadas -----------------

## Primeiro vamos baixar os dados -------------------------

# Veja se os arquivos estão nessa pasta. 
# Se não estiver, descomente o código abaixo para baixá-los.
fs::dir_ls("dados/shp")

# # Isso só precisa ser feito uma vez! 
# 
# # Criar a pasta onde colocaremos os arquivos
# fs::dir_create("dados/shp")
# 
# 
# # URL do arquivo shapefile
# u_shp <-
#   "http://datageo.ambiente.sp.gov.br/geoserver/datageo/VWM_IQA_CETESB_2018_PTO/wfs?version=1.0.0&request=GetFeature&outputFormat=SHAPE-ZIP&typeName=VWM_IQA_CETESB_2018_PTO"
# 
# # Fazer o download do arquivo zip
# httr::GET(u_shp,
#           httr::write_disk("dados/shp/datageo.zip"),
#           httr::progress())
# 
# 
# # Descompactar os arquivos
# unzip("dados/shp/datageo.zip", exdir = "dados/shp/", overwrite = TRUE) # PARA O WINDOWS, NAO USAR A BARRA
# 
# 
# # Ver quais arquivos estão na pasta que criamos
# fs::dir_ls("dados/shp")


## Importar os dados ----------------------------

iqa_cetesb <-
  st_read(
    "dados/shp/VWM_IQA_CETESB_2018_PTOPoint.shp",
    quiet = TRUE,
    options = "ENCODING=WINDOWS-1252"
  ) %>%
  # limpar o nome das colunas
  janitor::clean_names()

# explorar as colunas da base. EVITE usar o View()
glimpse(iqa_cetesb)

##  Exemplo de visualização ----------------------

# Usamos o pacote ggplot2 para criar os mapas,
# utilizando o geom_sf()

ggplot() +
  geom_sf(data = iqa_cetesb, aes(geometry = geometry))

iqa_cetesb %>%
  ggplot() +
  geom_sf()

iqa_cetesb %>%
  ggplot() +
  geom_sf(aes(color = classe))

iqa_cetesb %>%
  ggplot() +
  geom_sf(aes(color = valor))


ggplot() +
  geom_sf(data = iqa_cetesb, aes(geometry = geometry))

## Trabalhando com bases não georreferenciadas ------------

# Identificar a unidade de análise, e com os joins, unir com uma
# base georreferenciada.

# O pacote **geobr** (Pereira and Goncalves 2020) é um pacote que
# disponibiliza funções para realizar o download de diversas bases de dados
# espaciais oficiais do Brasil. Você pode saber mais no repositório do pacote
# no GitHub: https://ipeagit.github.io/geobr/

# Veja se os arquivos estão nessa pasta. 
# Se não estiver, descomente o código abaixo para baixá-los.
fs::dir_ls("dados/geobr")

# # Geobr está instável, baixe os arquivos por aqui
# 
# fs::dir_create("dados/geobr")
# 
# # URL do arquivo shapefile
# zip_geobr <- "https://curso-r.github.io/202103-visualizacao/dados/geobr.zip"
# 
# # Fazer o download do arquivo zip
# httr::GET(zip_geobr,
#           httr::write_disk("dados/geobr.zip"),
#           httr::progress())
# 
# 
# # Descompactar os arquivos
# unzip("dados/geobr.zip", exdir = "dados/") 
# # quem usa windows tem que tirar a ultima barra do exdir
# 
# # Ver quais arquivos estão na pasta que criamos
# fs::dir_ls("dados/geobr/")

# Datasets do Brasil ---------------

# Quais funções para acessar cada dataset:
geobr::list_geobr()

## Importar as bases ---------

##  Delimitação do Brasil

# brasil <- geobr::read_country()

# OU
brasil <- readr::read_rds("dados/geobr/brasil.Rds")

## Delimitação dos Estados
# estados <- geobr::read_state()

# OU
estados <- readr::read_rds("dados/geobr/estados.Rds")

## Delimitação de um Estado específico
# estado_sp <- geobr::read_state("SP")

# OU
estado_sp <- readr::read_rds("dados/geobr/estado_sp.Rds")


## Delimitação dos Municípios

# municipios_brasil <- geobr::read_municipality()

# OU

municipios_brasil <- readr::read_rds("dados/geobr/municipios_todos.rds")


## Delimitação de um município específico

# municipio_sp <- geobr::read_municipality(code_muni = 3550308)

# OU
municipio_sp <- readr::read_rds("dados/geobr/municipio_sp.Rds") 



## Explorar os dados -------

# Qual é a classe?
class(brasil)

brasil %>%
  ggplot() +
  geom_sf()


estados %>%
  ggplot() +
  geom_sf()

# Muito pesado!!
# municipios_brasil %>%
#   ggplot() +
#   geom_sf()

# simplificando o shapefile para plotar mais rapido
municipios_brasil %>%
  st_simplify(dTolerance = .01) %>% 
  ggplot() +
  geom_sf()


## Empilhando as bases -----------
ggplot() +
  geom_sf(data = estado_sp) +
  geom_sf(data = iqa_cetesb) +
  theme_bw()

# Usando os verbos do dplyr --------------------------------
## Também podemos agrupar os dados espaciais! ---------------

estados %>%
  ggplot() +
  geom_sf()

# Exemplo de mapa que não fica bom - MUDAR ESSE EXEMPLO!!!
estados %>%
  st_simplify(dTolerance = .01) %>% 
  group_by(name_region) %>%
  summarise() %>%
  ungroup() %>%
  ggplot() +
  geom_sf() +
  theme_bw()


## Joins Espaciais ----------------------------------
# Podemos fazer JOINS com objetos espaciais
# Neste exemplo: pontos de coleta no município de São Paulo

glimpse(iqa_cetesb) 

glimpse(municipios_brasil)

dados_iqa_municipios <-
  iqa_cetesb %>%
  st_join(municipios_brasil)

glimpse(dados_iqa_municipios)


## Podemos filtrar os dados como fazemos em tibbles "comuns"

dados_iqa_filtrados <- dados_iqa_municipios %>%
  filter(name_muni == "São Paulo")

glimpse(dados_iqa_filtrados)

## Mapas temáticos

# remotes::install_github("abjur/abjData")

dados_idh_muni <- abjData::pnud_min %>% 
  filter(ano == 2010) %>% 
  mutate(code_muni = as.double(muni_id))


municipios_brasil %>% 
  filter(abbrev_state  == "SP") %>% 
  inner_join(dados_idh_muni, "code_muni") %>% 
  ggplot(aes(fill = idhm)) +
  geom_sf() +
  theme_void()

