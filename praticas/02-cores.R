library(dados)
library(tidyverse)

# cores -------------------------------------------------------------------

p1 <- dados_starwars |>
  filter(massa < 1000) |> 
  ggplot() +
  aes(massa, altura, colour = sexo_biologico) +
  geom_point(size = 3) +
  theme_minimal()

p2 <- dados_starwars |>
  filter(massa < 1000) |> 
  ggplot() +
  aes(massa, altura, colour = log10(ano_nascimento)) +
  geom_point(size = 3) +
  theme_minimal()

p1
p2

# discretas
p1 +
  scale_colour_brewer(palette = "Set2")

p1 +
  scale_colour_brewer(palette = "Set2", na.value = "#000000")

p1 +
  scale_colour_viridis_d(
    option = "A", begin = .2, end = .8, 
    na.value = "#000000"
  )

p1 +
  scale_colour_manual(
    values = hcl.colors(3), # olhar ?hcl.colors
    na.value = "#000000"
  )

p1 +
  scale_colour_hue(
    h = c(0, 360) + 90,
    c = 200,
    l = 60,
    h.start = 0
  )

# continuas

p2 +
  scale_colour_distiller(palette = "BuGn")

p2 +
  scale_colour_fermenter(palette = "BuGn")

p2 +
  scale_colour_viridis_c(option = "A")

p2 +
  scale_colour_viridis_b(option = "A")


# pacote ggthemes ---------------------------------------------------------

p1 +
  scale_colour_brewer(palette = "Set2") +
  ggthemes::theme_excel()


p1 +
  ggthemes::scale_colour_fivethirtyeight() +
  ggthemes::theme_fivethirtyeight()

p1 +
  scale_colour_brewer(palette = "Set2") +
  ggthemes::theme_fivethirtyeight()


# pacote tvthemes ---------------------------------------------------------

p1 + 
  tvthemes::scale_colour_spongeBob() +
  tvthemes::theme_spongeBob(title.size = 40, text.font = "Some Time Later") +
  labs(title = "Duas horas depois...")


p1 + 
  tvthemes::scale_colour_brooklyn99() +
  tvthemes::theme_brooklyn99(
    title.size = 40, 
    text.font = "Roboto Condensed"
  ) +
  labs(title = "Cool, cool, cool, cool, cool...")

# FONTES

## No windows...
extrafont::font_import("exemplos_de_aula/fontes", prompt = FALSE)
extrafont::loadfonts("win")

## No Mac/Linux basta instalar as fontes e reiniciar a sessão


# pacote ghibli -----------------------------------------------------------

p1 + 
  ghibli::scale_color_ghibli_d(
    "LaputaMedium", 
    direction = -1,
    na.value = "#000000"
  )

# monte o seu e jogue aqui: 
# https://docs.google.com/document/d/12TOFqX1Ci-Yn8xPY9y5XT-GQYAju6ObzN-Fy55BbEYE/edit#



