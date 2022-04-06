## ---------------------------------------------------------
# geom_encircle é interessante para destacar pontos distantes da nuvem de pontos
library(ggalt)

pontos_diferentes <- municipios %>% 
  filter(uf_sigla == "RS", ano == 2010, pop > 1e6)

gg_alt <- municipios %>% 
  filter(uf_sigla == "RS", ano == 2010) %>% 
  ggplot(aes(idhm_e, pop)) +
  geom_point() +
  ggalt::geom_encircle(
    data = pontos_diferentes,
    color = "red", s_shape = .1, expand = .01, size = 3
  )

gg_alt
