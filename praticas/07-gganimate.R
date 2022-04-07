library(tidyverse)
library(dados)
library(gganimate)

## ---------------------------------------------------------

anim <- dados_gapminder |> 
  ggplot() +
  aes(expectativa_de_vida, log10(pib_per_capita), size = log10(populacao)) +
  geom_point() +
  facet_wrap(~continente) +
  theme_minimal(15) +
  # Aqui começa o gganimate
  labs(
    title = 'Ano: {frame_time}', 
    x = 'Expectativa de vida', 
    y = 'log10(Pib per capita)'
  ) +
  gganimate::transition_time(ano)

gganimate::animate(
  anim, 
  nframes = 40, 
  duration = 10, 
  start_pause = 2,
  end_pause = 2,
  width = 800, 
  height = 400
)

# salvar em mp4 com o pacote {av}
gganimate::animate(
  anim, 
  nframes = 40, 
  duration = 10, 
  start_pause = 2,
  end_pause = 2,
  width = 800, 
  height = 400,
  renderer = av_renderer("output/video_ggplot.mp4")
)

# uso interessante

anim <- dados_gapminder |> 
  filter(continente == "Américas") |> 
  ggplot() +
  aes(expectativa_de_vida, log10(pib_per_capita), size = log10(populacao)) +
  geom_point() +
  gghighlight::gghighlight(
    pais == "Brasil", 
    label_key = pais
  ) +
  theme_minimal(15) +
  # Aqui começa o gganimate
  labs(
    title = 'Ano: {frame_time}', 
    x = 'Expectativa de vida', 
    y = 'log10(Pib per capita)'
  ) +
  gganimate::transition_time(ano)


gganimate::animate(
  anim, 
  nframes = 40, 
  duration = 10, 
  start_pause = 2,
  end_pause = 2,
  width = 800, 
  height = 400
)
