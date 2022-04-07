library(tidyverse)
library(dados)
library(reactable)

dados_summ <- pinguins %>% 
  group_by(ano, ilha) %>% 
  summarise(
    bico_medio = mean(comprimento_bico, na.rm = TRUE),
    massa_corporal = mean(massa_corporal, na.rm = TRUE),
    .groups = "drop"
  ) %>% 
  tidyr::pivot_wider(
    names_from = ano, 
    values_from = c(bico_medio, massa_corporal)
  )

# criando a tabela 

dados_summ %>%
  reactable(
    columns = list(
      ilha = colDef("Ilha"),
      bico_medio_2007 = colDef("1991", format = colFormat(digits = 3)),
      bico_medio_2008 = colDef("2000", format = colFormat(digits = 3)),
      bico_medio_2009 = colDef("2010", format = colFormat(digits = 3)),
      massa_corporal_2007 = colDef("1991", format = colFormat(separators = TRUE, digits = 0)),
      massa_corporal_2008 = colDef("2000", format = colFormat(separators = TRUE, digits = 0)),
      massa_corporal_2009 = colDef("2010", format = colFormat(separators = TRUE, digits = 0))
    ),
    columnGroups = list(
      colGroup(
        name = "Bico",
        columns = c("bico_medio_2007", "bico_medio_2008", "bico_medio_2009")
      ),
      colGroup(
        name = "Massa Corporal",
        columns = c("massa_corporal_2007", "massa_corporal_2008", "massa_corporal_2009")
      )
    )
  )


dados_summ_especie <- pinguins %>% 
  group_by(ano, ilha, especie) %>% 
  summarise(
    bico_medio = mean(comprimento_bico, na.rm = TRUE),
    massa_corporal = mean(massa_corporal, na.rm = TRUE),
    .groups = "drop"
  ) %>% 
  tidyr::pivot_wider(
    names_from = ano, 
    values_from = c(bico_medio, massa_corporal)
  )

dados_summ_especie %>%
  reactable(
    columns = list(
      ilha = colDef("Ilha"),
      especie = colDef("Espécie"),
      bico_medio_2007 = colDef("1991", format = colFormat(digits = 3), aggregate = "mean"),
      bico_medio_2008 = colDef("2000", format = colFormat(digits = 3), aggregate = "mean"),
      bico_medio_2009 = colDef("2010", format = colFormat(digits = 3), aggregate = "mean"),
      massa_corporal_2007 = colDef("1991", format = colFormat(separators = TRUE, digits = 0), aggregate = "mean"),
      massa_corporal_2008 = colDef("2000", format = colFormat(separators = TRUE, digits = 0), aggregate = "mean"),
      massa_corporal_2009 = colDef("2010", format = colFormat(separators = TRUE, digits = 0), aggregate = "mean")
    ),
    columnGroups = list(
      colGroup(
        name = "Bico",
        columns = c("bico_medio_2007", "bico_medio_2008", "bico_medio_2009")
      ),
      colGroup(
        name = "Massa Corporal",
        columns = c("massa_corporal_2007", "massa_corporal_2008", "massa_corporal_2009")
      )
    ), 
    groupBy = "ilha"
  )
