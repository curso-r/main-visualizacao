
install.packages("ggridges")
library(ggridges)

library(tidyverse)

# dados -------------------------------------------------------------------

dados <- tibble::tibble(
  review = 1:5,
  tempo_atraso = purrr::map(5:1, ~rgamma(1000, shape = .x, 10))
) %>% 
  unnest(tempo_atraso)

media_geral <- mean(dados$tempo_atraso)
gg <- dados %>% 
  ggplot(aes(x = tempo_atraso, y = factor(review), fill = factor(review))) +
  geom_density_ridges(
    alpha = .6,
    quantile_lines = TRUE, quantiles = 2
  ) + 
  geom_vline(xintercept = media_geral, linetype = 2, colour = "gray", size = 1.5) +
  theme_classic(14)


# como faz para limitar o grafico

gg +
  scale_x_continuous(limits = c(0, 1))

gg +
  lims(x = c(0, 1))

# como mudar as cores

gg +
  scale_fill_discrete()

gg +
  scale_fill_manual()

gg +
  scale_fill_brewer()

estrela <- "★"
gg +
  scale_y_discrete(labels = purrr::map_chr(1:5, ~paste(rep(estrela, .x), collapse = "")))+
  scale_fill_viridis_d(begin = .1, end = .8, option = "E") +
  lims(x = c(0, 1)) +
  theme(legend.position = "none") +
  labs(x = "Tempo de atraso", y = "", title = "Review Score")


viridis::viridis()

# como colocar as medianas

gg +
  scale_y_discrete(labels = purrr::map_chr(1:5, ~paste(rep(estrela, .x), collapse = "")))+
  scale_fill_viridis_d(begin = .1, end = .8, option = "E") +
  lims(x = c(0, 1)) +
  theme(legend.position = "none") +
  annotate("text", x = media_geral, y = .9, hjust = 1,
           label = paste("Média:", round(media_geral, 2))) +
  labs(x = "Tempo de atraso", y = "", title = "Review Score")

