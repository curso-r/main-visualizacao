library(ggplot2)
library(gganimate)
library(dados)

#theme_set(ggthemes::theme_solarized())  # pre-set the bw theme.

g <- ggplot(dados_gapminder, aes(pib_per_capita, expectativa_de_vida, size = populacao, color = continente)) +
  geom_point() +
  scale_x_log10() +
  scale_size(range = c(2, 12)) +
  geom_smooth(method = "lm", se = FALSE) + 
  facet_wrap(~continente) + 
  transition_time(ano) +
  theme_bw() +
  theme(legend.position = 'none') 

animate(g, 100, 10)
