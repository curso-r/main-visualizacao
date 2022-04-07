library(tidyverse)
library(dados)

imagem <- "https://wallpaperaccess.com/full/11836.jpg"

vader <-  dados_starwars |>
  mutate(vader = if_else(nome == "Darth Vader", TRUE, NA)) |>
  drop_na(vader)

grafico <- dados_starwars |>
  ggplot() +
  geom_point(
    aes(x = massa, y = altura),
    fill = "yellow",
    color = "yellow",
    shape = 23,
    size = 2,
    alpha = 0.8
  ) +
  geom_point(
    data = vader,
    aes(x = massa, y = altura),
    fill = "red",
    color = "red",
    shape = 23,
    size = 2,
    alpha = 1
  ) +
  geom_label(
    data = vader,
    aes(x = massa, y = altura),
    label = "darth vader",
    nudge_y = 12,
    nudge_x = -5,
    fill = "red",
    family = "Star Jedi"
  ) +
  coord_cartesian(xlim = c(0, 200)) +
  labs(
    title = "Star Wars",
    subtitle = "May the force be with you",
    x = "Massa",
    y = "Altura"
  ) +
  theme(
    axis.text = element_text(color = "yellow", family = "Star Jedi"),
    axis.title = element_text(color = "yellow", family = "Star Jedi"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid = element_line(color = "grey6"),
    plot.title = element_text(
      color = "yellow",
      size = 30,
      hjust = 0.5,
      family = "Star Jedi"
    ),
    plot.subtitle = element_text(
      color = "yellow",
      size = 12,
      hjust = 0.5,
      family = "Star Jedi"
    )
  )

ggimage::ggbackground(
  gg = grafico,
  background = imagem
) 

# fonte Star Jedi: https://www.dafont.com/pt/star-jedi.font


# Import -----------------------------------------------------------------------

url0 <- "https://raw.githubusercontent.com/adamribaudo/storytelling-with-data-ggplot/master/data/FIG0921-26.csv"
da_raw <- read_csv(url0)

# Tidy -------------------------------------------------------------------------

# queremos chegar em uma tabela que tem as seguintes colunas
# categoria, ano, percentual

da_tidy <- da_raw %>%
  pivot_longer(
    -Category,
    names_to = "ano",
    values_to = "perc_funders") %>%
  janitor::clean_names() %>%
  mutate(
    ano = as.integer(ano),
    perc_funders = parse_number(perc_funders)/100
  )

funcao_para_iterar <- function(tipo_painel, dados = da_tidy) {
  da_tidy %>%
    mutate(
      realce = if_else(category == tipo_painel, 1, 0),
      painel = tipo_painel
    )
}


# Visualize --------------------------------------------------------------------

da_visualizar <- map_dfr(
  unique(da_tidy$category),
  funcao_para_iterar
)

tab <- da_visualizar %>%
  mutate(
    realce = factor(realce),
    numero = ifelse(
      (ano == min(ano) | ano == max(ano)) & realce == 1, 1, 0
    ),
    hjust = case_when(
      ano == min(ano) ~ 1.2,
      ano == max(ano) ~ -0.3,
      TRUE ~ NA_real_
    ),
    painel = str_wrap(painel, 5)
  )

tab %>%
  filter(realce == 0) |>
  ggplot(aes(x = ano, y = perc_funders)) +
  geom_line(size = 1.3, color = "grey", aes(group = category)) +
  geom_line(
    data = filter(tab, realce == 1),
    size = 1.3,
    color = "royal blue"
  ) +
  geom_point(
    data = filter(tab, numero == 1),
    aes(x = ano, y = perc_funders),
    color = "black"
  ) +
  geom_text(
    data = filter(tab, numero == 1),
    aes(
      x = ano,
      y = perc_funders,
      label = scales::percent(perc_funders, accuracy = 1),
      hjust = hjust
    ),
    color = "black"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text.y = element_blank()
  ) +
  # sugestão do BRUNO MIOTO
  scale_x_continuous(position = 'top') +
  #scale_x_continuous(guide = guide_axis(position = 'top')) +
  labs(x = "", y = "") +
  facet_wrap(vars(painel), nrow = 5,  strip.position = "left") +
  theme(
    # panel.background = element_rect(fill = 'black'),
    strip.text.y.left = element_text(angle = 0, hjust = 0),
    plot.margin = unit(c(0.3, 1, 1, 0.1), "cm"),
    axis.line.x = element_line()
  ) +
  scale_color_viridis_d(begin = .5) +
  coord_cartesian(clip = "off")

