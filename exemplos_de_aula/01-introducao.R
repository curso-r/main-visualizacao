library(tidyverse)
library(dados)

## ---- fig.width=6, fig.height=4---------------------------------------
ggplot(cars) +
  aes(speed, dist) +
  geom_point()

## ---- fig.width=6, fig.height=4---------------------------------------
ggplot(cars) +
  aes(speed, dist) +
  geom_point(colour = "darkblue") +
  stat_smooth(
    se = FALSE, colour = "lightgray", method="loess",
    formula = "y~x"
  ) +
  theme_minimal(14) +
  labs(
    title = "A velocidade influencia na distância de parada?",
    subtitle = "Distância necessária para parar o carro",
    caption = "Fonte: Ezekiel, M. (1930) Methods of Correlation Analysis. Wiley",
    x = "Velocidade",
    y = "Distância para parar"
  )


## ----dpi=300, out.width="50%"-----------------------------------------
cars |> 
  ggplot()


## ----aes-mapping, dpi=300, out.width="40%"----------------------------
cars |> 
  ggplot() +
  aes(x = speed, y = dist)

## ----dispersao, dpi=300, out.width="40%"------------------------------
cars |> 
  ggplot() +
  aes(x = speed, y = dist) +
  geom_point()

## ---- cars-completo, fig.width=9, fig.height=6, echo=TRUE-------------
ggplot(cars) +
  aes(speed, dist) +
  geom_point(colour = "darkblue") +
  stat_smooth(
    se = FALSE, colour = "lightgray", 
    method = "loess", formula = "y ~ x"
  ) +
  theme_minimal(14) +
  labs(
    title = "A velocidade influencia na distância de parada?",
    subtitle = "Distância necessária para parar o carro",
    caption = paste(
      "Fonte: Ezekiel, M. (1930) Methods of",
      "Correlation Analysis. Wiley"),
    x = "Velocidade", y = "Distância para parar"
  )

