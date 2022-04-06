## ---------------------------------------------------------
# tabela base

dados_summ <- municipios %>% 
  as_tibble() %>% 
  group_by(ano, abbrev_state) %>% 
  summarise(
    pop = sum(pop),
    gini = mean(gini),
    .groups = "drop"
  ) %>% 
  tidyr::pivot_wider(
    names_from = ano, 
    values_from = c(pop, gini)
  )
# criando a tabela 
dados_summ %>%
  reactable(
    columns = list(
      abbrev_state = colDef("Estado"),
      pop_1991 = colDef("1991", format = colFormat(separators = TRUE)),
      pop_2000 = colDef("2000", format = colFormat(separators = TRUE)),
      pop_2010 = colDef("2010", format = colFormat(separators = TRUE)),
      gini_1991 = colDef("1991", format = colFormat(digits = 3)),
      gini_2000 = colDef("2000", format = colFormat(digits = 3)),
      gini_2010 = colDef("2010", format = colFormat(digits = 3))
    ),
    columnGroups = list(
      colGroup(
        name = "População",
        columns = c("pop_1991", "pop_2000", "pop_2010")
      ),
      colGroup(
        name = "Índice de Gini",
        columns = c("gini_1991", "gini_2000", "gini_2010")
      )
    )
  )
