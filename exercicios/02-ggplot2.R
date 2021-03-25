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
# b) [EXERCÍCIO CANCELADO - NÃO FAZER]
# [DESAFIO] https://www.washingtonpost.com/graphics/2018/lifestyle/sinclair-broadcasting/
# Nesse caso, siga o passo-a-passo da matéria.
# código: https://r-journalism.com/posts/2018-07-17-sf-sinclair-map/map/
# OBS: como é de 2018, pode ser que seja necessário adaptar.
