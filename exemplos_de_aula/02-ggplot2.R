# Carregar pacotes --------------------------------------------------------

library(tidyverse)
library(dados)

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

# Gráfico de dispersão da temperatura média do mês ao longo do tempo
temperatura_por_mes %>% 
  ggplot() +
  geom_line(aes(x = mes, y = temperatura_media, color = origem))

# Mesma informação, apenas trocando os mapeamentos estétiticos
temperatura_por_mes %>% 
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10)

# Salvando um gráfico em um arquivo
temperatura_por_mes %>% 
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10)

ggsave("meu_grafico.png")

# Tema e labels --------------------------------------------------------------------

# Temas prontos
temperatura_por_mes %>% 
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10) +
# theme_bw() 
  # theme_classic() 
  # theme_dark()
  theme_minimal()

# A função theme()
temperatura_por_mes %>% 
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10) +
  labs(
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento",
    x = "Mês",
    y = "Aeroporto mais próximo do ponto de medição",
    color = "Temperatura média (ºC)"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  )

grafico_base <- temperatura_por_mes %>% 
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10) +
  labs(
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento",
    x = "Mês",
    y = "Aeroporto mais próximo do ponto de medição",
    color = "Temperatura média (ºC)"
  )

# Vamos explorar os componentes mais importantes do theme

# Esses componentes tem vários subcomponentes, que podem ser consultados em help(theme)
# o padrão dos nomes é, por exemplo, theme(axis.text.x)

# praticamente todos os componentes devem ser parametrizados como um

# (a) element_text, para componentes textuais como por exemplo axis.text.x , axis.text.y e legend.title

# Exemplos:

# mudando o tamanho e a cor dos textos dos eixos

grafico_base +
  theme(
    axis.text = element_text(color = 'red', size = 20)
  )

# mudando o tamanho e a cor do texto do título da legenda

grafico_base +
  theme(
    legend.title = element_text(color = 'red', size = 20)
  )

# mudando o tamanho e a cor do texto do texto da legenda

grafico_base +
  theme(
    legend.text = element_text(color = 'red', size = 20)
  )

# (b) element_rect, para bordas e fundos, como panel.background
# Exemplos

# mudando a cor do fundo
grafico_base +
  theme(
    panel.background = element_rect(fill = 'white')
  )

# mudando a cor do fundo e as bordas
grafico_base +
  theme(
    panel.background = element_rect(fill = 'white', color = 'gray')
  )

# mudando a cor do fundo, das bordas e aumentando o tamanho das bordas
grafico_base +
  theme(
    panel.background = element_rect(fill = 'white', color = 'gray', size = 2)
  )

# por que as gradações de escala sumiram? porque a cor padrão do componente axis.ticks é branco.
# vamos ver como mexer nele:

# (c) element_line, para linhas como axis.line e axis.ticks e panel.grid

# mudando a cor do fundo, das bordas, aumentando o tamanho das bordas e trocando a cor das gradações de escala 

# mudando a cor das linhas principais dos eixos x e y

grafico_base +
  theme(
    panel.background = element_rect(fill = 'white', color = 'gray', size = 2),
    panel.grid  = element_line(color = 'gray')
  )

# mudando a cor das linhas principais do eixo x

grafico_base +
  theme(
    panel.background = element_rect(fill = 'white', color = 'gray', size = 2),
    panel.grid.major.x  = element_line(color = 'gray')
  )

# mudando a cor das linhas secundárias do eixo x

grafico_base +
  theme(
    panel.background = element_rect(fill = 'white', color = 'gray', size = 2),
    panel.grid.major.x  = element_line(color = 'darkgray'),
    panel.grid.minor.x  = element_line(color = 'lightgray')
  )

# acabando com a diferença entre linhas major e minors

grafico_base +
  theme(
    panel.background = element_rect(fill = 'white', color = 'gray', size = 2),
    panel.grid.major.x  = element_line(color = 'lightgray'),
    panel.grid.minor.x  = element_line(color = 'lightgray')
  )

# Mais temas
#install.packages("ggthemes")

# Tema do fivethirthyeight
temperatura_por_mes %>% 
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10) +
  labs(
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento",
    x = "Mês",
    y = "Aeroporto mais próximo do ponto de medição",
    color = "Temperatura média (ºC)"
  ) +
  ggthemes::theme_fivethirtyeight()

# Tema da Google Docs
temperatura_por_mes %>% 
  ggplot() +
  geom_line(aes(x = mes, y = origem, color = temperatura_media), size = 10) +
  labs(
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento",
    x = "Mês",
    y = "Aeroporto mais próximo do ponto de medição",
    color = "Temperatura média (ºC)"
  ) +
  ggthemes::theme_gdocs()

# Mais exemplos em
# https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/

# Gráfico de barras -------------------------------------------------------

# até agora exploramos bastante o geom_lines

# vamos explorar outros geoms importantes:

# para destacar uma comparação entre quantidade ou valores de diferentes grupos, por exemplo, uma alternativa interessante é a barra
# geom_col

pinguins %>% 
  count(especies) %>% 
  ggplot(aes(x = especies, y = n,fill = especies)) + 
  geom_col() +
  ggthemes::theme_fivethirtyeight()

# no dataset pinguins, tem bem mais pinguins-de-adélia do que pinguins-de-barbicha

# nesse tipo de gráfico é muito comum que a gente queira ordenar da maior barra para a menor barra, justamente
# para destacar a comparação nessa dimensão

# para esse tipo de operação usamos o pacote forcats
library(forcats)


# ordenando do maior para o menor
pinguins %>% 
  count(especies) %>% 
  mutate(especies = fct_reorder(especies, n)) %>% 
  ggplot(aes(x = especies, y = n,fill = especies)) + 
  geom_col() +
  ggthemes::theme_fivethirtyeight()

# ordenando do menor para o maior
pinguins %>% 
  count(especies) %>% 
  mutate(especies = fct_reorder(especies, -n)) %>% 
  ggplot(aes(x = especies, y = n,fill = especies)) + 
  geom_col() +
  ggthemes::theme_fivethirtyeight()

# às vezes queremos comparar, ao mesmo tempo, grupos e subgrupos. isso é, no mesmo "x" vão existir várias barras para serem plotadas

# aqui temos duas opções:

# empilhar (padrão);

pinguins %>% 
  count(especies, sexo) %>% 
  ggplot(aes(x = sexo, y = n,fill = especies)) + 
  geom_col() +
  ggthemes::theme_fivethirtyeight()

# colocar lado a lado;

pinguins %>% 
  count(especies, sexo) %>% 
  ggplot(aes(x = sexo, y = n,fill = especies)) + 
  geom_col(position = 'dodge') +
  # "dodge" significa "desviar"
  ggthemes::theme_fivethirtyeight()

# aqui podemos ver que não parece que há uma grande diferença entre o número de pinguis machos e fêmeas e nem da distribuição
# de espécies em cada grupo

# empilhar com relação aos valores relativos dentro de cada grupo:

pinguins %>% 
  count(especies, sexo) %>% 
  ggplot(aes(x = sexo, y = n,fill = especies)) + 
  geom_col(position = 'fill') +
  # "fill" significa "preencher"
  ggthemes::theme_fivethirtyeight()


# Visualizando distribuições ----------------------------------------------

# Ás vezes queremos visualizar distribuições, no sentido estatístico mesmo

# para isso utilizaros geoms como geom_histogram ou geom_density

pinguins %>% 
  ggplot(aes(x = comprimento_bico)) +
  geom_histogram() 

# ajeitando o gráfico fica:

pinguins %>% 
  ggplot(aes(x = comprimento_bico)) +
  geom_histogram(fill = 'royalblue', color = 'white') +
  theme_bw() +
  labs(x = "Comprimento do bico (cm)",
       y = "Contagem")

# usando a densidade (que suaviza o histograma para desconsiderar os picos)

pinguins %>% 
  ggplot(aes(x = comprimento_bico)) +
  geom_density(fill = 'royalblue', color = 'white') +
  theme_bw() +
  labs(x = "Comprimento do bico (cm)",
       y = "Contagem")

# podemos também usar essas funções para comparar grupos

pinguins %>% 
  ggplot(aes(x = comprimento_bico, fill = especies)) +
  geom_histogram(color = 'white') +
  theme_bw() +
  labs(x = "Comprimento do bico (cm)",
       y = "Contagem")

# a sobreposição atrapalha um pouco a visualização por histograma

# se quisermos suavizar a sobreposição a função geom_density parece adequada,
# pois aceita um parâmetros de transparência, que se chama "alpha", pois o seu uso aqui cria um sombreado

pinguins %>% 
  ggplot(aes(x = comprimento_bico, fill = especies)) +
  geom_density(color = 'white', alpha = .7) +
  theme_bw() +
  labs(x = "Comprimento do bico (cm)",
       y = "Contagem")

# o efeito não é tão legal no geom_histogram, porque é como se uma barra estivesse à frente da outra

pinguins %>% 
  ggplot(aes(x = comprimento_bico, fill = especies)) +
  geom_histogram(color = 'white', alpha = .7) +
  theme_bw() +
  labs(x = "Comprimento do bico (cm)",
       y = "Contagem")

# pontos ------------------------------------------------------------------

# essa é a representação que dá destaque total ao valor numérico dos dados. é a representação "mais crua" dos dados.
# a quantidade de tinta gasta por linha da base de dados é a menor possível

# serve para destacar o formato da nuve de pontos formada por dados numéricos
# só a nuvem em si não comunica nenhuma mensagem explicitamente. a intepretação fica a cargo de quem vê o gráfico

clima %>% 
  filter(origem == "JFK") %>% 
  group_by(dia_do_ano = lubridate::floor_date(data_hora, "day")) %>%
  summarise(temperatura = min(temperatura)) %>% 
  ggplot(aes(x = dia_do_ano, y = temperatura)) + 
  geom_point()

# é interessante complementar um gráfico de pontos com algum elemento de destaque

# geom_smooth é interessante para destacar tendências
clima %>% 
  filter(origem == "JFK") %>% 
  group_by(dia_do_ano = lubridate::floor_date(data_hora, "day")) %>%
  summarise(temperatura = min(temperatura)) %>% 
  ggplot(aes(x = dia_do_ano, y = temperatura)) + 
  geom_point() + 
  geom_smooth() +
  ggthemes::theme_wsj()

# geom_encircle é interessante para destacar pontos distantes da nuvem de pontos

library(ggalt)

dados <- clima %>% 
  filter(origem == "JFK") %>% 
  group_by(dia_do_ano = lubridate::floor_date(data_hora, "day")) %>% 
  summarise(temperatura = min(temperatura))

dia_estranho <- dados %>% 
  filter(dia_do_ano == as.Date("2013-05-08"))
  
dados %>% 
  ggplot(aes(x = dia_do_ano, y = temperatura)) + 
  geom_point() + 
  ggalt::geom_encircle(data = dia_estranho, color = "red", s_shape = .1, expand = .01, size = 3)

                       