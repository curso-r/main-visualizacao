## ---------------------------------------------------------
municipios %>% 
  filter(ano == 2010, abbrev_state == estado_para_filtrar) %>% 
  hchart("scatter", hcaes(x = gini, y = idhm, color = espvida))

## ---------------------------------------------------------
# histograma
municipios %>% 
  pull(gini) %>% 
  hchart()

# densidade
municipios %>% 
  pull(gini) %>% 
  density() %>% 
  hchart()
