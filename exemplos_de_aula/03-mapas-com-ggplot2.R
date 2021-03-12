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
# Isso só precisa ser feito uma vez!

# Criar a pasta onde colocaremos os arquivos
fs::dir_create("dados/shp")

# URL do arquivo shapefile
u_shp <-
  "http://datageo.ambiente.sp.gov.br/geoserver/datageo/VWM_IQA_CETESB_2018_PTO/wfs?version=1.0.0&request=GetFeature&outputFormat=SHAPE-ZIP&typeName=VWM_IQA_CETESB_2018_PTO"

# Fazer o download do arquivo zip
httr::GET(u_shp,
          httr::write_disk("dados/shp/datageo.zip"),
          httr::progress())


# Descompactar os arquivos
unzip("dados/shp/datageo.zip", exdir = "dados/shp/")

# Ver quais arquivos estão na pasta que criamos
fs::dir_ls("dados/shp")


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

iqa_cetesb %>%
  ggplot() +
  geom_sf()

iqa_cetesb %>%
  ggplot() +
  geom_sf(aes(color = classe))

iqa_cetesb %>%
  ggplot() +
  geom_sf(aes(color = valor))


## Trabalhando com bases não georreferenciadas ------------

# Identificar a unidade de análise, e com os joins, unir com uma
# base georreferenciada.

# O pacote **geobr** (Pereira and Goncalves 2020) é um pacote que
# disponibiliza funções para realizar o download de diversas bases de dados
# espaciais oficiais do Brasil. Você pode saber mais no repositório do pacote
# no GitHub: https://ipeagit.github.io/geobr/


# Datasets do Brasil ---------------

# Quais funções para acessar cada dataset:
geobr::list_geobr()

## Importar as bases ---------

##  Delimitação do Brasil

brasil <- geobr::read_country()

## Delimitação dos Estados
estados <- geobr::read_state()

## Delimitação de um Estado específico
estado_sp <- geobr::read_state("SP")

## Delimitação dos Municípios

municipios <- geobr::read_municipality()

## Delimitação de um município específico

municipio_sp <- geobr::read_municipality(code_muni = 3550308)

## Explorar os dados -------

# Qual é a classe?
class(brasil)

brasil %>%
  ggplot() +
  geom_sf()


estados %>%
  ggplot() +
  geom_sf()

municipios %>%
  ggplot() +
  geom_sf()

# simplificando o shapefile para plotar mais rapido
municipios %>%
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
glimpse(municipios)

dados_iqa_municipios <-
  iqa_cetesb %>%
  st_join(municipios)

glimpse(dados_iqa_municipios)

## Podemos filtrar os dados como fazemos em tibbles "comuns"

dados_iqa_filtrados <- dados_iqa_municipios %>%
  filter(name_muni == "São Paulo")

glimpse(dados_iqa_filtrados)

## Mapas temáticos

# remotes::install_github("abjur/abjData")

dados_idh_muni <- abjData::pnud_min %>% 
  filter(ano == 2010) %>% 
  mutate(code_muni = as.numeric(muni_id))

municipios %>% 
  filter(abbrev_state == "SP") %>% 
  inner_join(dados_idh_muni, "code_muni") %>% 
  ggplot(aes(fill = idhm)) +
  geom_sf() +
  theme_void()

# Patchwork  ----------

# O pacote possibilita combinar ggplots em uma única imagem.
# Precisamos compor os gráficos separadamente, salvá-los em objetos,
# e depois fazer a composição.

# Gráfico do Brasil
gg_brasil <- ggplot() +
  geom_sf(data = brasil) +
  geom_sf(data = estado_sp, fill = "lightblue") +
  theme_bw()


# Gráfico do estado de SP
gg_estado <- ggplot() +
  geom_sf(data = estado_sp) +
  geom_sf(data = municipio_sp, fill = "lightblue") +
  theme_bw()


# Gráfico dos pontos no coleta no município de São Paulo
gg_iqa_saopaulo <- ggplot() +
  geom_sf(data = municipio_sp) +
  geom_sf(data = dados_iqa_filtrados) +
  theme_bw() +
  coord_sf()


# Fazer uma composição com patchwork
library(patchwork)

(gg_estado + gg_brasil) / gg_iqa_saopaulo

