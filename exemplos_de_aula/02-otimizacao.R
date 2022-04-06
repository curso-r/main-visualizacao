library(tidyverse)
library(dados)

## ---- fig.width=5, fig.height=4, dpi = 300-------------------------------------
notas_pixar <- pixar_avalicao_publico |> 
  count(nota_cinema_score) |> 
  mutate(
    nota = fct_explicit_na(nota_cinema_score, "(vazio)"),
    nota = fct_relevel(nota, c("A-", "A", "A+", "(vazio)"))
  )

notas_pixar |> 
  ggplot() +
  aes(nota, n) +
  geom_col(width = .5) +
  scale_y_continuous(limits = c(0, 15)) +
  labs(title = "A maioria dos filmes da pixar têm nota 'A'") +
  theme_minimal(12)


## ---- fig.width=5, fig.height=4, dpi = 300-------------------------------------
notas_pixar |> 
  mutate(cor = dplyr::case_when(
    nota == "A" ~ "b",
    TRUE ~ "a"
  )) |> 
  ggplot() +
  aes(nota, n, fill = cor) +
  geom_col(width = .5, show.legend = FALSE) +
  scale_y_continuous(limits = c(0, 15)) +
  scale_fill_manual(values = c("gray30", "tomato")) +
  labs(title = "A maioria dos filmes da pixar têm nota 'A'") +
  theme_minimal(12)


## ----warning=FALSE, fig.width=9, fig.height=6, dpi=300-------------------------
p_size <- notas_pixar |> 
  mutate(tipo = if_else(nota == "A", "b", "a")) |> 
  ggplot() +
  aes(nota, n, size = tipo) +
  geom_segment(aes(xend = nota, yend = 0), size = .5) +
  geom_point() +
  scale_y_continuous(limits = c(0, 15)) +
  scale_size_discrete(range = c(3, 6)) +
  theme_minimal(12) +
  theme(legend.position = "none")

p_shape <- notas_pixar |> 
  mutate(tipo = if_else(nota == "A", "b", "a")) |> 
  ggplot() +
  aes(nota, n, shape = tipo) +
  geom_segment(aes(xend = nota, yend = 0), size = .5) +
  geom_point(size = 6) +
  scale_shape_manual(values = c(1, 16)) +
  scale_y_continuous(limits = c(0, 15)) +
  theme_minimal(12) +
  theme(legend.position = "none")

p_mark <- notas_pixar |> 
  mutate(tipo = if_else(nota == "A", "b", "a")) |> 
  ggplot() +
  aes(nota, n, shape = tipo) +
  geom_segment(aes(xend = nota, yend = 0), size = .5) +
  geom_point(size = 6) +
  scale_shape_manual(values = c(1, 13)) +
  scale_y_continuous(limits = c(0, 15)) +
  theme_minimal(12) +
  theme(legend.position = "none")

p_bar <- notas_pixar |> 
  mutate(tipo = if_else(nota == "A", "b", "a")) |> 
  ggplot() +
  aes(nota, n) +
  geom_col(width = c(.8, .5,.5,.5)) +
  scale_y_continuous(limits = c(0, 15)) +
  theme_minimal(12)

patchwork::wrap_plots(p_size, p_shape, p_mark, p_bar)

## ---- fig.height=4, fig.width=6, dpi = 300-------------------------------------
pinguins |> 
  drop_na() |> 
  ggplot() +
  aes(
    x = comprimento_bico, 
    y = profundidade_bico, 
    shape = especie
  ) +
  geom_point() +
  theme_minimal(12) +
  labs() +
  theme(legend.position = "bottom")


## ---- fig.height=4, fig.width=6, dpi = 300-------------------------------------
pinguins |> 
  drop_na() |> 
  ggplot(aes(
    x = comprimento_bico, 
    y = profundidade_bico, 
    shape = especie,
    group = especie
  )) +
  geom_point() +
  theme_minimal(12) +
  theme(legend.position = "bottom") +
  stat_ellipse(
    type = "norm", 
    geom = "polygon",
    alpha = .05,
    level = .95,
    colour = "transparent"
  )
  



