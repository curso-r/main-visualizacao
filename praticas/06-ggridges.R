# install.packages("ggridges")
library(ggridges)
library(tidyverse)
library(dados)

diamante |>
  ggplot() +
  aes(x = preco, y = corte, fill = corte) +
  geom_density_ridges(
    alpha = .6,
    quantile_lines = TRUE, 
    quantiles = 2
  )

media_geral <- mean(diamante$preco)

gg <- diamante  |> 
  ggplot() +
  aes(x = preco, y = corte, fill = corte) +
  geom_density_ridges(
    alpha = .6,
    quantile_lines = TRUE, 
    quantiles = 2
  ) + 
  geom_vline(
    xintercept = media_geral, 
    linetype = 2, 
    colour = "gray", 
    size = 1.5
  ) +
  theme_classic(14)

gg

# como faz para limitar o grafico

gg +
  scale_x_continuous(limits = c(0, 10000))

gg +
  lims(x = c(0, 10000))

# como mudar as cores

gg +
  scale_fill_discrete()

gg +
  scale_fill_brewer()

gg +
  scale_fill_viridis_d(option = "A")


# aplicacao interessante --------------------------------------------------

estrela <- "*"
labs_estrela <- purrr::map_chr(1:5, ~glue::glue_collapse(rep(estrela, .x)))
gg +
  scale_y_discrete(labels = labs_estrela) +
  scale_fill_viridis_d(
    begin = .1, 
    end = .8, 
    option = "E"
  ) +
  scale_x_continuous(
    labels = scales::dollar,
    limits = c(0, 1e4)
  ) +
  annotate(
    "text", 
    x = media_geral, 
    y = 6, 
    hjust = -.1,
    size = 5,
    label = paste("Média:", scales::dollar(media_geral))
  ) +
  labs(
    x = "Preço", 
    y = "", 
    title = "Qualidade"
  ) +
  theme(legend.position = "none")


