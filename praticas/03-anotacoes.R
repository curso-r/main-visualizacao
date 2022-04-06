## ---------------------------------------------------------
gg_highlight <- municipios %>% 
  filter(uf_sigla == "RS", ano == 2010) %>% 
  ggplot(aes(idhm_e, pop)) +
  geom_point() +
  gghighlight::gghighlight(
    pop > 1e6,
    label_key = name_muni
  )

gg_highlight

## ---------------------------------------------------------
gg_repel <- municipios %>% 
  filter(uf_sigla == "RR", ano == 2010) %>% 
  ggplot(aes(idhm_e, idhm_l)) +
  geom_point() +
  ggrepel::geom_label_repel(aes(label = name_muni))


