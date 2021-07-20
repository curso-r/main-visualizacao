
# Relatórios e visualização de dados

<!-- README.md is generated from README.Rmd. Please edit that file -->

Repositório principal do curso Relatórios e visualização de dados.

Inscreva-se no curso: <https://www.curso-r.com/cursos/visualizacao>

**Acesse o material completo do curso escolhendo uma das turmas
abaixo**.

| Turma         | Material                                        | Github                                           |
|:--------------|:------------------------------------------------|:-------------------------------------------------|
| Julho de 2021 | <https://curso-r.github.io/202107-visualizacao> | <https://github.com/curso-r/202107-visualizacao> |
| Março de 2021 | <https://curso-r.github.io/202103-visualizacao> | <https://github.com/curso-r/202103-visualizacao> |

**Trabalho de conclusão**: fazer o \#tidytuesday da semana ou um à sua
escolha. Fazer não só a visualização, mas uma apresentação ou relatório

## Pacotes necessários

Esse curso tem várias dependências. Separamos em três grupos de
dependências:

-   Principal: necessário para rodar o conteúdo das aulas
-   Showcase: necessário para rodar o showcase da aula 1
-   Misc: necessário para rodar as aulas 4 e 5 (miscelânea + extra)

``` r
# Principal
principal <- c(
  "tidyverse",
  "xaringan",
  "flexdashboard",
  "xaringanthemer",
  "sf",
  "geobr",
  "ggalt",
  "prettydoc",
  "ggthemes",
  "patchwork",
  "fs",
  "janitor"
)
install.packages(principal)

# Pacotes instalados via GitHub
if (!require(remotes)) install.packages("remotes")
remotes::install_github("abjur/abjData")
remotes::install_github("cienciadedatos/dados")

# esses pacotes são para os showcases funcionarem
showcase <- c(
  "pagedown",
  "officedown",
  "rticles",
  "flextable",
  ## não instale o webshot ainda; vamos instalar em aula
  # "webshot",
  "plotly",
  "officedown"
)
install.packages(showcase)

# esses pacotes são apenas para a aula de miscelânea.
# se não conseguir instalar algum deles, não se preocupe!
misc <- c(
  "av", 
  "transformr", 
  "gifski",
  "gganimate",
  "leaflet",
  "bookdown",
  "plotly",
  "highcharter",
  "ggspatial",
  "ggrepel"
)

install.packages(misc)
```
