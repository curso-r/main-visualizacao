## ---------------------------------------------------------
anim <- municipios %>% 
  filter(abbrev_state == estado_para_filtrar) %>% 
  mutate(ano = as.numeric(ano)) %>% 
  ggplot(aes(rdpc, espvida, size = sqrt(pop))) +
  geom_point() +
  facet_wrap(~abbrev_state) +
  scale_x_log10() +
  # Aqui começa o gganimate
  labs(title = 'Ano: {frame_time}', x = 'Renda', y = 'Expectativa de vida') +
  gganimate::transition_time(ano)


## ---------------------------------------------------------
gganimate::animate(anim, nframes = 20, width = 800, height = 400)


## ----eval=FALSE, include=TRUE-----------------------------
## # criar a pasta para salvar o gif
## fs::dir_create("../output")
## 
## # melhor se tiver o pacote {gifski} instalado
## gganimate::animate(
##   anim,
##   width = 800, height = 400,
##   nframes = 20,
##   duration = 10,
##   fps = 2,
##   detail = 1,
##   gifski_renderer("../output/gif_ggplot.gif")
## )


## ----eval=FALSE, include=TRUE-----------------------------
## # melhor se tiver o pacote {av} instalado
## gganimate::animate(
##   anim,
##   width = 800, height = 400,
##   nframes = 20,
##   duration = 10,
##   fps = 2,
##   detail = 1,
##   av_renderer("../output/video_ggplot.mp4")
## )


## ----eval=FALSE, include=TRUE-----------------------------
## ### install.packages("transformr")
## anim <- municipios %>%
##   filter(abbrev_state == estado_para_filtrar) %>%
##   mutate(ano = as.numeric(ano)) %>%
##   ggplot(aes(fill = idhm)) +
##   geom_sf(colour = "black", size = .1) +
##   theme_void(12) +
##   labs(title = 'Ano: {frame_time}') +
##   transition_time(ano) +
##   enter_fade()
## 


## ----eval=FALSE, include=TRUE-----------------------------
## animate(
##   anim, nframes = 20, fps = 8,
##   width = 800, height = 400
## )


## ----eval=FALSE, include=TRUE-----------------------------
## animate(
##   anim,
##   width = 800, height = 400,
##   nframes = 20,
##   duration = 5,
##   fps = 4,
##   detail = 1,
##   gifski_renderer("../output/gif_mapa.gif")
## )

