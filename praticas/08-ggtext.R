library(tidyverse)

filme <- "Bohemian Rhapsody"
id_planilha <- "1sJDpzYH_sMYuYHqkmZeJGIq_TEXGDjboYdSoew7UjZ8"

da_raw <- googlesheets4::read_sheet(
  id_planilha, sheet = filme
)

da_tidy <- da_raw |>
  janitor::clean_names() |>
  dplyr::transmute(
    id,
    start = as.numeric(start),
    end = as.numeric(end),
    truth_level = as.character(truth_level)
  )

percentual <- da_tidy |>
  dplyr::filter(
    !truth_level %in% c("-", "UNKNOWN")
  ) |>
  dplyr::summarise(
    res = mean(truth_level %in% c("TRUE", "TRUE-ISH"))
  ) |>
  dplyr::pull(res) |>
  scales::percent(accuracy = .1)

# o grafico é a partir daqui

da_tidy |>
  dplyr::filter(truth_level != "-") |>
  dplyr::mutate(truth_level = forcats::lvls_reorder(
    truth_level, c(3, 4, 2, 1, 5)
  )) |>
  ggplot() +
  geom_rect(
    mapping = aes(
      xmin = start, xmax = end,
      ymin = 0, ymax = 1,
      fill = truth_level
    ),
    colour = "white",
    size = .05,
    show.legend = FALSE
  ) +
  scale_fill_manual(values = c(
    "#42A5F5","#8BC8F9","#F386AA", "#EC407A","#D3D3D3"
  )) +
  labs(
    title = stringr::str_glue(
      "<strong style='color:#6D8Cd6;'>{percentual}</strong>",
      " <strong style='color:black;'>{filme}</strong>",
      " <span style='color:#444444;font-size:10px'>2018</span>"
    )
  ) +
  theme_void() +
  theme(
    plot.title = ggtext::element_markdown(colour = "black", size = 11)
  )

