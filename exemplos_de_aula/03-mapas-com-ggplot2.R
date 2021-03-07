# Carregar pacotes -------------
library(ggplot2)
library(sf)
library(geobr)
library(magrittr)

# O pacote **sf** (Simple Features for R) (Pebesma 2020, 2018) possibilita
# trabalhar com bases de dados espaciais. 

# Duas abordagens:
# - Bases que são georreferenciadas
# - Bases que não são georreferenciadas


## Trabalhando com bases georreferenciadas -----------------

# FAZER UM EXEMPLO COM SHP


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

##  Delimitação do Brasil

brasil <- geobr::read_country() 

# Qual é a classe?
class(brasil)

brasil %>% 
  ggplot() +
  geom_sf()

# Delimitação dos Estados
estados <- geobr::read_state()

estados %>% 
  ggplot() +
  geom_sf()

# Delimitação dos Municípios

municipios <- geobr::read_municipality()

municipios %>% 
  ggplot() +
  geom_sf()



# Materiais interessantes ---------------------------------------------
#   
#   https://mauriciovancine.github.io/disciplina-analise-geoespacial-r/
#   
#   https://raw.githubusercontent.com/rstudio/cheatsheets/master/sf.pdf

