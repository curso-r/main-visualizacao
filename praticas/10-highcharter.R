library(highcharter)

dados_starwars |> 
  filter(massa < 1000) |> 
  hchart("scatter", hcaes(x = massa, y = altura, group = genero))
  