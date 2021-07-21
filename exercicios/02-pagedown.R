# Caso não tenha lido esses capítulos,
# leia antes de fazer os exercícios:

# https://livro.curso-r.com/9-relatorios.html
# https://livro.curso-r.com/9-1-markdown.html
# https://livro.curso-r.com/9-2-r-markdown.html

# Vamos montar um relatório usando {pagedown}!

# 0. Certifique-se de que o pacote {pagedown} está instalado

# 1. Crie um documento com o template thesis
# RMarkdown > From template > HTML Thesis Document

# 2. Salve o arquivo e compile para gerar o arquivo

# 3. Preencha o título, subtítulo, autor etc com informações de seu interesse
# (pode ser ou não as suas informações verdadeiras)

# 4. Crie um arquivo estilos.css na mesma pasta em que você salvou
# o arquivo Rmd e coloque

# h1 {
#  color: blue;
# }

# (sem os #)
# Compile o documento novamente. O que aconteceu? Por que?

# 5. Referencie o arquivo estilos.css no yaml do seu RMarkdown
## Dica: no lugar correto do output (descubra qual!), você deve colocar assim:
## css: ["thesis", "estilo.css"]

# 6. Coloque a fonte sem serifas (sans-serif) em todo o documento
## Dica: qual é a tag que contém todo o corpo do html?

# 7. Deixe os parágrafos justificados.
## Dica: qual é a tag dos parágrafos?

# 8. Mude o estilo do página da forma que achar mais legal.

# 9. rode pagedown::chrome_print("seu/arquivo.html") para gerar o pdf

# 10. submeta o arquivo pdf final gerado. 
## Obs: Se não conseguir, pode subir os arquivos .Rmd e .css

