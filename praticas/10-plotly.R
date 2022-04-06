
## ---------------------------------------------------------
gg_idhm <- municipios %>% 
  ggplot(aes(x = gini, y = idhm, colour = espvida)) +
  geom_point() +
  facet_wrap(~ano)

plotly::ggplotly(gg_idhm)

