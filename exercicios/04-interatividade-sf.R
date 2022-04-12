library(tidyverse)
library(dados)
library(leaflet)
library(reactable)
library(highcharter)
library(plotly)

# exercícios htmlwidgets --------------------------------------------------

# 1. [plotly]

# a partir desse gráfico
p <- dados_starwars |> 
  ggplot(aes(massa, altura, colour = genero)) +
  geom_point()

# a. utilize ggplotly() para gerar uma versão plotly do gráfico.

# b. teste o ggplotly com essas opções. 
# Quais funcionam e quais não funcionam como desejado?

p + theme_minimal(20)
p + theme(legend.position = "bottom")
p + theme(text = element_text(family = "Times"))
  
# c. faça o mesmo gráfico usando a sintaxe plot_ly
# d. coloque a legenda de (c) na parte de baixo
# e. tente usar o que você aprendeu em (d) para colocar a legenda 
# de (a) na parte de baixo

# 2. [highcharter]

# a partir desse gráfico
dados_starwars |> 
  ggplot(aes(genero, fill = sexo_biologico)) +
  geom_bar(position = "dodge")

# a. utilize hchart() para gerar uma versão highcharter do gráfico.
# b. estude o tutorial: https://jkunst.com/highcharter/articles/highcharts-api.html
# c. faça uma versão em highchart() desse gráfico

# 3. [reactable]

# a partir dessa tabela

dados_gapminder


# a. Monte uma tabela que mostra o país, a expectativa de vida máxima
#  e o ano em que a expectativa de vida máxima foi atingida.
#  Utilize colDef() para ajustar os nomes das colunas.

# b. Agrupe a tabela por continente

# c. Deixe a tabela no modo "striped" (listrado)

# d. Adicione a coluna "melhorou", indicando se, na data mais recente (2007),
#  a expectativa de vida é maior ou menor que a máxima do país.

# e. Pinte a coluna "melhorou" de verde se o país tiver melhorado ou mantido,
#  e de vermelho se tiver piorado
## Dica: https://glin.github.io/reactable/articles/examples.html#conditional-styling

# 4. [leaflet] 
# a. Faça o mapa temático da aula prática mudando o estado e as cores.
# b. Mude a label para mostrar o estado e o IDHM.
## Dica: crie uma coluna com a label completa.

# exercícios com mapas ----------------------------------------------------

library(sf)
library(geobr)

# 1. Importe a base de terras indígenas usando o pacote geobr,
# e salve em um objeto.
# Dica: função read_indigenous_land()


# 2. Identifique as 2 etnias (etnia_nome) com maior quantidade
# de terra (superficie)


# 3. Filtre a base de terras indígenas, para conter apenas 
# as duas etnias encontradas no exercício 2. Salve o resultado em um objeto.


# 4. Usando a base gerada no exercício 3,
# faça um mapa plotando as terras das duas etnias encontradas.
# Pinte o mapa com as categorias


# 5. Usando o pacote geobr, baixe a base de biomas, 
# filtre apenas para o bioma Amazônia, e salve em um objeto.
# Dica: função read_biomes()


# 6. Adicione os biomas no mapa das terras indígenas (feito no exercício 4)
## tente colocar de uma forma que o mapa não fique muito poluído

# 7. Customize o mapa com os temas e pacotes extras à sua escolha!
