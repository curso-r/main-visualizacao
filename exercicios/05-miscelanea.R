# 1. Faça o mapa desse exemplo mas usando leaflet e markers no lugar de pontos:

# https://github.com/curso-r/main-visualizacao/blob/ddeec38aa31d181683a72af998f0835408c2c964/exemplos_de_aula/03-mapas-com-ggplot2.R#L136



# 2. Explore o shiny do {reactable} e reproduza o código dos exemplos que achar mais legais

# https://glin.github.io/reactable/articles/shiny-demo.html

# 3. [extra] O plotly também tem seu próprio jeito de fazer gráficos,
# além do ggplotly. Por exemplo:

plotly::plot_ly(
  economics, 
  type = "scatter", 
  mode   = 'markers',
  x = ~date, 
  y = ~pop
)

# reproduza o gráfico da linha abaixo usando essa sintaxe:

# https://github.com/curso-r/main-visualizacao/blob/ddeec38aa31d181683a72af998f0835408c2c964/exemplos_de_aula/04-miscelanea.R#L168

