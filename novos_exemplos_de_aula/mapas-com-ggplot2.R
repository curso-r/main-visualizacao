# Carregar pacotes -------------
library(sf)
library(geobr)
library(ggplot2)
library(dplyr)
# remotes::install_github("abjur/abjData")
library(abjData)


# O pacote {sf} (Simple Features for R) (Pebesma 2020, 2018) possibilita
# trabalhar com bases de dados espaciais.

# Importar dados:
## Duas abordagens:
# - Bases que não são georreferenciadas
# - Bases que são georreferenciadas


## Trabalhando com bases não georreferenciadas ------------

# Identificar a unidade de análise, e com os joins, unir com uma
# base georreferenciada.

# O pacote **geobr** (Pereira and Goncalves 2020) é um pacote que
# disponibiliza funções para realizar o download de diversas bases de dados
# espaciais oficiais do Brasil. Você pode saber mais no repositório do pacote
# no GitHub: https://ipeagit.github.io/geobr/

# Datasets do Brasil ---------------

# Quais funções para acessar cada dataset:
knitr::kable(geobr::list_geobr())

# Exemplos:

# geobr::read_country() # importa a delimitação do Brasil

# geobr::read_state() # importa a delimitação dos estados do Brasil

# geobr::read_state("DF") # importa a delimitação de um Estado específico,
# usando a sigla

# geobr::read_municipality() # importa a delimitação de todos os municípios do
# Brasil. É uma base mais pesada!

# geobr::read_municipality(code_muni = 3550308) # importa a delimitação de um
# município específico, usando o código do IBGE do município.

# Exemplo 1: Trabalhando com os estados brasileiros ------
## Importar as bases

# Não usar View()!

## Delimitação dos Estados
# a) Todos os estados do Brasil
estados <- readr::read_rds("dados/geobr/estados.Rds")

# Como obter essa mesma base?
# estados <- geobr::read_state()

# b) Apenas um estado: DF
estado_df <- readr::read_rds("dados/geobr/estado_df.Rds")

# Como obter essa mesma base?
# estado_df <- geobr::read_state("DF")



## Explorar os dados 

# Qual é a classe?
class(estados)

# Usamos o pacote ggplot2 para criar os mapas,
# utilizando o geom_sf()

estados %>%
  ggplot() +
  geom_sf()


## Empilhando as bases usando os geom's 
ggplot() +
  geom_sf(data = estados) +
  geom_sf(data = estado_df, fill = "blue") +
  theme_bw()

## Usando o dplyr com objetos sf 

## glimpse - observar o que a base contém
glimpse(estados)


## filter - conseguimos filtrar!

estados %>% 
  filter(name_region == "Nordeste") %>% 
  ggplot() +
  geom_sf() 

## join

class(abjData::pnud_uf)


pnud_uf_sf <- estados %>% 
  left_join(abjData::pnud_uf, by = c("code_state" = "uf")) 

class(pnud_uf_sf)


## Mapas temáticos

glimpse(pnud_uf_sf)

pnud_uf_sf  %>% 
  ggplot(aes(fill = idhm)) +
  geom_sf() +
  theme_void()

# Exemplo 2: Escolas em Brasília, DF -----------------------
# Carregar os pacotes usados
library(magrittr)
library(dplyr)
library(ggplot2)

# Carregar os dados usados

# a) Escolas em Brasília
escolas_brasilia <- readr::read_rds("dados/geobr/escolas_brasilia.Rds")

# Como obter essa mesma base?
# escolas <- geobr::read_schools()
# escolas_brasilia <- escolas %>% 
#   filter(abbrev_state == "DF", name_muni == "Brasília") 

# b) Delimitação de Brasília
municipio_brasilia <- readr::read_rds("dados/geobr/municipio_brasilia.Rds")

# Como obter essa mesma base?
# municipio_brasilia <- geobr::read_municipality(5300108)

# Fazer um mapa! 
# Passo 1: colocar a delimitação do município e também as escolas
ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = escolas_brasilia) 

# Passo 2: Colorir as escolas por "government_level"
ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = escolas_brasilia, aes(color = government_level)) 

# Passo 3: Fazer um facet com "government_level"
ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = escolas_brasilia, aes(color = government_level)) + 
  facet_wrap(~ government_level)

# Passo 4: Remover a legenda, mudar o tema, 
# adicionar um título e centralizar o título

ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = escolas_brasilia, aes(color = government_level), show.legend = FALSE) + 
  facet_wrap(~ government_level) +
  theme_void() + 
  labs(title = "Escolas em Brasília \n") + 
  theme(plot.title = element_text(hjust = 0.5))


# Exemplo 3 - Rodovias em DF ----

library(sf)
library(geobr)

# Como buscar a base? Se quiser baixar, descomente os códigos abaixo

# Link que disponibiliza a base
# u_shp <- "https://www.gov.br/infraestrutura/pt-br/centrais-de-conteudo/rodovias-zip"

# Cirar a pasta para baixar o arquivo
# dir.create("dados/shp_rod")

# Fazer o download do arquivo zip
# httr::GET(u_shp,
#           httr::write_disk("dados/shp_rod/rodovias.zip"),
#           httr::progress())

# Descompactar o zip
# unzip("dados/shp_rod/rodovias.zip", exdir = "dados/shp_rod/")

# Importar a base em arquivo .shp (Trabalhando com bases georreferenciadas)
rodovias <-
  st_read(
    "dados/shp_rod/rodovias.shp",
    quiet = TRUE#,
    #options = "ENCODING=WINDOWS-1252"
  ) %>%
  # limpar o nome das colunas
  janitor::clean_names()

# filtrar para DF
rodovias_df <- rodovias %>% 
  filter(sg_uf == "DF") 

# Fazendo um mapa simples
ggplot() +
  geom_sf(data = rodovias_df)


# Juntar os 3 exemplos! ------

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


