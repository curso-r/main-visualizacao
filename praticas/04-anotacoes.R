## Anotação manual

jabba <- dados_starwars |> 
  filter(massa > 1000)

dados_starwars |> 
  ggplot(aes(massa, altura)) +
  geom_point() +
  annotate(
    "label", 
    x = jabba$massa, 
    y = jabba$altura,
    label = jabba$nome,
    hjust = 1,
    vjust = -1
  )

## Setas

dados_starwars |> 
  ggplot(aes(massa, altura)) +
  geom_point() +
  geom_curve(
    aes(
      x = massa - 500, y = altura - 50,
      xend = massa - 5, yend = altura - 2
    ),
    arrow = arrow(
      type = "closed", 
      length = unit(.4, "cm")
    ),
    colour = "red",
    curvature = 0.4,
    data = jabba
  ) +
  annotate(
    "label", 
    x = jabba$massa - 500, 
    y = jabba$altura - 50,
    label = jabba$nome
  )

## Anotar imagem imagem

# vamos pegar uma imagem do jabba
u_img <- "https://www.pikpng.com/pngl/b/277-2778885_jabba-the-hut-6-star-wars-black-series.png"
img <- httr::content(httr::GET(u_img))

dados_starwars |> 
  ggplot(aes(massa, altura)) +
  geom_point() +
  annotation_raster(
    img,
    xmin = jabba$massa - 400, 
    xmax = jabba$massa - 5, 
    ymin = jabba$altura - 50,
    ymax = jabba$altura - 2
  )

# ver também o pacote {ggimg}: https://github.com/statsmaths/ggimg

## Pacote gghighlight
dados_starwars |> 
  ggplot(aes(massa, altura)) +
  geom_point() +
  gghighlight::gghighlight(
    massa > 1000,
    label_key = nome
  )

## ---------------------------------------------------------
# geom_encircle é interessante para destacar pontos 
# distantes da nuvem

library(ggalt)
dados_starwars %>% 
  ggplot(aes(massa, altura)) +
  geom_point() +
  ggalt::geom_encircle(
    data = jabba,
    color = "red", 
    s_shape = 0, 
    expand = 0, 
    spread = .02,
    size = 2
  )

dados_starwars %>% 
  ggplot(aes(massa, altura)) +
  geom_point() +
  ggalt::geom_encircle(
    data = filter(dados_starwars, altura > 220),
    color = "red", 
    s_shape = 0, 
    expand = 0.05, 
    spread = 1,
    size = 2
  ) +
  ggalt::geom_encircle(
    data = filter(dados_starwars, altura < 140),
    color = "blue", 
    s_shape = .3, 
    expand = 0.05, 
    spread = 1,
    size = 2
  )

## Pacote ggrepel
dados_starwars |>  
  filter(massa < 1000) |> 
  ggplot(aes(massa, altura)) +
  geom_point() +
  ggrepel::geom_label_repel(aes(label = nome))
