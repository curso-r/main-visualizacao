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
geobr::list_geobr()

# Exemplos:

# geobr::read_country() # importa a delimitação do Brasil

# geobr::read_state() # importa a delimitação dos estados do Brasil

# geobr::read_state("SP") # importa a delimitação de um Estado específico,
# usando a sigla

# geobr::read_municipality() # importa a delimitação de todos os municípios do
# Brasil. É uma base mais pesada!

# geobr::read_municipality(code_muni = 3550308) # importa a delimitação de um
# município específico, usando o código do IBGE do município.

## Importar as bases ---------

# Não usar View()!

## Delimitação dos Estados
 estados <- geobr::read_state()

# OU
# estados <- readr::read_rds("dados/geobr/estados.Rds")

estado_sp <- geobr::read_state("SP")

# OU
# estados_sp <- readr::read_rds("dados/geobr/estado_sp.Rds")



## Explorar os dados -------

# Qual é a classe?
class(estados)

# Usamos o pacote ggplot2 para criar os mapas,
# utilizando o geom_sf()

estados %>%
  ggplot() +
  geom_sf()


## Empilhando as bases usando os geom's -----------
ggplot() +
  geom_sf(data = estados) +
  geom_sf(data = estado_sp, fill = "blue") +
  theme_bw()

## Usando o dplyr com objetos sf ----

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
  left_join(abjData::pnud_uf, by = c("code_state" = "uf")) %>%
  glimpse()

class(pnud_uf_sf)


## Mapas temáticos

glimpse(pnud_uf_sf)

pnud_uf_sf  %>% 
  ggplot(aes(fill = idhm)) +
  geom_sf() +
  theme_void()

