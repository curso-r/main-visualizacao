# 1. Faça os exercícios da seção 9.2 do livro
# https://livro.curso-r.com/9-2-r-markdown.html

# 2. Teste os temas abaixo com os exemplos de aula:
# Dica: veja na documentação como instalar estes pacotes.

# a) https://ewenme.github.io/ghibli/
# b) https://ryo-n7.github.io/tvthemes/

# 3. Escreva a label apropriada no eixo Y. Note que no eixo y
# está representada o log de alpha ao quadrado (linha 17).

library(ggplot2)
library(magrittr) # Carregar o pipe %>% 
tibble::tibble(
  alpha = 1:10,
  alpha2 = log10(alpha^2)
  ) %>% 
  ggplot(aes(alpha, alpha2)) +
  geom_line() +
  labs(
    x = expression(alpha),
    y = "exercicio"
  ) +
  theme_minimal(25)

# 4. Crie um tema que você goste e nos mostre em sala


# 5. Reproduza os gráficos das matérias abaixo:

# a) https://nucleo.jor.br/redes/2021-03-11-ciencia-dispara-twitter-divulgadores
# Reproduzir apenas o primeiro gráfico.
# Os dados e código foram disponibilizados no final da matéria.
# Primeiro, tente reproduzir sem olhar o código do ggplot, 
# rodando apenas até a linha 128:
# código: https://gist.github.com/lgelape/d854f7f23a900531e3fd4977d574e492#file-materia_engajamento_divulgadores-r-L128
# 
# O código abaixo serve para facilitar a importação dos dados.
# Caso não tenha algum destes pacotes instalado, lembre-se de instalar.

# Carregar pacotes
library(ggplot2)
library(magrittr) # Carregar o pipe %>%
library(lubridate)
library(googlesheets4)
library(dplyr)

# URL da base no google sheets - está no final da matéria
url <- "https://docs.google.com/spreadsheets/d/1SRT77C0SnPEZucaeMSWQKngE9F7Vwb4irGwDgB7CxtM/edit?usp=sharing"

# Importar a base usando a função read_sheet() do pacote googleshees4
# Será necessário realizar a autenticação com a API do google
# Ao executar essa função, acompanhe as mensagens do console.
total_dia_brasileiros <- googlesheets4::read_sheet(url)

# Veja a base importada
dplyr::glimpse(total_dia_brasileiros)


total_dia_brasileiros %>%
  # transformar a coluna created_at em classe data
  dplyr::mutate(created_at = lubridate::as_date(created_at)) %>% 
  ggplot() +
#  _____ # Comece por aqui :)
