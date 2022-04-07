# Revisão ggplot2 ---------------------------------------------------------

library(tidyverse)
library(dados)

# o lego do ggplot2 -------------------------------------------------------

## Passo 1: A base

# o ggplot2 é iniciado com o tapetinho cinza
ggplot()

# também podemos começar com os dados
ggplot(dados_starwars)

# alternativa com pipe
dados_starwars |> 
  ggplot()

## Passo 2: Mapeamento estético

# utilizamos a função aes(), de aestethics
ggplot(dados_starwars, aes(x = massa)) 
ggplot(dados_starwars, aes(x = massa, y = altura))
ggplot(dados_starwars, aes(massa, altura))

# alternativa
ggplot(dados_starwars) + # não esqueça de usar + no lugar do |>
  aes(x = massa, y = altura)

# alternativa
dados_starwars |> 
  ggplot() +
  aes(x = massa, y = altura)

# outros mapeamentos só aparecem quando incluímos formas geométricas
dados_starwars |> 
  ggplot() +
  aes(x = massa, y = altura, colour = sexo_biologico)

## Passo 3: Formas geométricas

# temos muitos geom_* disponíveis. Eles podem ser agrupados em 2 tipos:
# geoms individuais (representa uma linha da base)
# geoms agrupados (representa um resumo ou conjunto de linhas)

### geom_point

# utilização básica
dados_starwars |> 
  ggplot() +
  aes(x = massa, y = altura, colour = genero) +
  geom_point()

dados_starwars |>
  filter(massa < 1000) |> 
  ggplot() +
  aes(x = massa, y = altura, colour = genero) +
  geom_point()

# Obs: não é de bom tom usar azul para masculino e vermelho para feminino...
# veremos o que fazer com as cores na próxima aula.

# fora do aes() e dentro do aes()
# dentro -> colunas da base
# fora -> valores fora da base
dados_starwars |>
  filter(massa < 1000) |> 
  ggplot() +
  aes(x = massa, y = altura) +
  geom_point(colour = "royalblue")

# errado
dados_starwars |>
  filter(massa < 1000) |>
  ggplot() +
  aes(x = massa, y = altura) +
  geom_point(colour = genero)

# errado
dados_starwars |>
  filter(massa < 1000) |>
  ggplot() +
  aes(x = massa, y = altura, colour = "royalblue") +
  geom_point()


# aes() dentro da geom vs aes() global
dados_starwars |>
  filter(massa < 1000) |> 
  ggplot() +
  geom_point(aes(x = massa, y = altura, colour = genero))

dados_starwars |>
  filter(massa < 1000) |> 
  ggplot() +
  aes(x = massa, y = altura) +
  geom_point(aes(colour = genero), size = 4) +
  geom_point()
  
### geom_bar e geom_col

# geom_bar faz conta
dados_starwars |> 
  ggplot() +
  aes(x = genero) +
  geom_bar()

# geom_col não faz
dados_starwars |> 
  count(genero) |> 
  ggplot() +
  aes(x = genero, y = n) +
  geom_col()

### geom_line

# mais comum para séries e tempo
voos |> 
  count(mes) |> 
  ggplot() +
  aes(x = mes, y = n) +
  geom_line()

# plotando várias séries
voos |> 
  count(mes, companhia_aerea) |> 
  ggplot() +
  aes(x = mes, y = n, colour = companhia_aerea) +
  geom_line()


### geom_histogram e geom_density

dados_starwars |>
  ggplot() +
  aes(x = altura) +
  geom_histogram()

dados_starwars |>
  ggplot() +
  aes(x = altura) +
  geom_density()

# para quebrar, use fill, não colour!
dados_starwars |>
  ggplot() +
  aes(x = altura, fill = genero) +
  geom_density(alpha = .8)


# agora vamos brincar com diferentes aspectos a serem mapeados
dados_starwars |> 
  drop_na(massa, altura) |> 
  esquisse::esquisser()

### mais algum?

## Elementos extras

### Facets

dados_starwars |> 
  filter(!is.na(genero)) |> 
  ggplot() +
  aes(x = massa, y = altura) +
  geom_point() +
  facet_wrap(~genero)

dados_starwars |> 
  filter(!is.na(genero)) |> 
  ggplot() +
  aes(x = massa, y = altura) +
  geom_point() +
  facet_wrap(~genero, scales = "free_x")

dados_starwars |> 
  mutate(humano = if_else(especie == "Humano", "Humano", "Não-humano")) |>
  filter(!is.na(genero)) |> 
  ggplot() +
  aes(x = massa, y = altura) +
  geom_point() +
  facet_grid(humano~genero, scales = "free")

### Escalas

dados_starwars |> 
  ggplot() +
  aes(x = massa, y = altura) +
  geom_point() +
  scale_x_continuous(
    limits = c(0, 100), 
    breaks = seq(0, 100, 10), 
    labels = paste0(seq(0, 100, 10), "kg")
  )

# veremos mais exemplos de escalas nas aulas mais avançadas.

### Transformações

# transformações só devem ser usadas quando você sabe o que está
# fazendo. Geralmente é mais fácil fazer as transformações
# diretamente nos dados.

dados_starwars |> 
  ggplot() +
  aes(x = sexo_biologico) +
  geom_bar()

dados_starwars |> 
  count(sexo_biologico) |> 
  ggplot() +
  aes(x = sexo_biologico, y = n) +
  geom_bar(stat = "identity")

### Coordenadas

dados_starwars |> 
  filter(massa < 1000) |> 
  ggplot() +
  aes(x = massa, y = altura) +
  geom_point() +
  coord_fixed(ratio = 0.2)

# pizza!
dados_starwars |> 
  ggplot() +
  aes(x = "zzz", fill = genero) +
  geom_bar() +
  coord_polar(theta = "y")

