
p <- dados_starwars |>
  filter(massa < 1000) |> 
  ggplot() +
  aes(x = massa, y = altura, colour = genero) +
  geom_point(size = 3)

plotly::ggplotly(p)


p <- dados_starwars |>
  ggplot() +
  aes(x = massa, y = altura, colour = genero, name = nome) +
  geom_point(size = 3)

plotly::ggplotly(p)
