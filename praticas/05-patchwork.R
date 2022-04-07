p1 <- dados_starwars |> 
  ggplot(aes(massa, altura)) +
  geom_point()

p2 <- dados_starwars |> 
  ggplot(aes(massa)) +
  geom_histogram()

p3 <- dados_starwars |> 
  ggplot(aes(altura)) +
  geom_histogram()

p4 <- dados_starwars |> 
  count(genero) |> 
  ggplot(aes(genero, n)) +
  geom_col()

## ---------------------------------------------------------
# nao funciona
p1 + p2

library(patchwork)
# funciona!
p1 + p2
p1 + p2 + p3
p1 + p2 + p3 + p4
p1 / p2

## customizando o padrão
p1 + p2 + plot_layout(ncol = 1)

## composições interessantes
(p2 + p3) / p1
(p2 | p3) / p1

## avançado

(p1 + plot_spacer() + p3) / p1

((p2 / p3) | p1) + plot_layout(widths = c(1, 3))

layout <- "
##BBBB
AACCDD
##CCDD
"
p1 + p2 + p3 + p4 + 
  plot_layout(design = layout)
