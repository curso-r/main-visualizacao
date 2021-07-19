# Exercício 1:
# 1. Ler o capítulo 9 do livro:
# https://livro.curso-r.com/9-relatorios.html

# Exercício 2: 
# Crie um arquivo .Rmd e adicione o conteúdo abaixo. 
# O que for texto explicativo deverá ser adicionado como texto,
# e os códigos deverão ser adicionados dentro de chunks de código.
# Configure as opções de chunk para que apareçam o código e resultado,
# porém não apareça as mensagens e warnings.
# Tente centralizar as imagens geradas.

# Entregue o arquivo .html gerado. 


# Carregar pacotes --------------------------------------------------------

library(tidyverse)

# Se for necessário instalar o pacote dados, 
# execute o código comentado abaixo!
# install.packages("remotes")
# remotes::install_github("cienciadedatos/dados")
library(dados)

glimpse(clima)

temperatura_por_mes <- clima %>% 
  group_by(origem, mes = lubridate::floor_date(data_hora, "month")) %>% 
  summarise(
    temperatura_media = (mean(temperatura, na.rm = TRUE)-30)/2
  ) %>% 
  ungroup() 

# Filosofia ---------------------------------------------------------------

# Um gráfico estatístico é uma representação visual dos dados 
# por meio de atributos estéticos (posição, cor, forma, 
# tamanho, ...) de formas geométricas (pontos, linhas,
# barras, ...). Leland Wilkinson, The Grammar of Graphics

# Layered grammar of graphics: cada elemento do 
# gráfico pode ser representado por uma camada e 
# um gráfico seria a sobreposição dessas camadas.
# Hadley Wickham, A layered grammar of graphics 

# Gráfico de linhas -------------------------------------------

# Apenas o canvas
temperatura_por_mes %>% 
  ggplot()

# Salvando em um objeto
p <- temperatura_por_mes %>% 
  ggplot()

# Adicionando eixo X
temperatura_por_mes %>% 
  ggplot() +
  aes(x = mes)

# Adicionando eixo Y
temperatura_por_mes %>% 
  ggplot() +
  aes(x = mes, y = temperatura_media)

# Gráfico de dispersão da temperatura média do mês ao longo do tempo
temperatura_por_mes %>% 
  ggplot() +
  aes(x = mes, y = temperatura_media, color = origem) +
  geom_line()

# Mesma informação, apenas trocando os mapeamentos estétiticos
temperatura_por_mes %>% 
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10)
