
# Relatórios e visualização de dados

<!-- README.md is generated from README.Rmd. Please edit that file -->

Repositório principal do curso Relatórios e visualização de dados.

Inscreva-se no curso: <https://www.curso-r.com/cursos/visualizacao>

**Acesse o material completo do curso escolhendo uma das turmas
abaixo**.

| Turma           | Material                                        | Github                                           |
|:----------------|:------------------------------------------------|:-------------------------------------------------|
| outubro de 2022 | <https://curso-r.github.io/202210-visualizacao> | <https://github.com/curso-r/202210-visualizacao> |
| julho de 2022   | <https://curso-r.github.io/202207-visualizacao> | <https://github.com/curso-r/202207-visualizacao> |
| abril de 2022   | <https://curso-r.github.io/202204-visualizacao> | <https://github.com/curso-r/202204-visualizacao> |

**Trabalho de conclusão**: fazer o #tidytuesday da semana ou um à sua
escolha.

## Plano de aulas

O curso de visualização de dados possui 4 aulas, de 3 horas cada,
totalizando 12 horas de curso. Nosso objetivo será trabalhar nas
dimensões abaixo:

1.  Análise exploratória
    -   Teoria:
        -   análise exploratória e análise explicativa
        -   tipos de visualização
        -   gráficos bons e ruins
    -   Prática:
        -   revisão de ggplot2
        -   live coding de análise exploratória
2.  Análise explicativa
    -   Teoria:
        -   coerência visual
        -   otimização visual
        -   recursos pré-atentativos
        -   temas do ggplot2
            -   ggthemes
            -   hrbrthemes
    -   Prática
        -   otimização de 1 ou 2 gráficos da aula 1
3.  Extensões do ggplot2
    -   patchwork
    -   ggrepel
    -   ggridges
    -   ggalt
    -   geom_sf
    -   gganimate
    -   ggtext
    -   Dinâmica: definição e exemplo para cada pacote
4.  Visualizações interativas
    -   leaflet
    -   plotly
    -   highcharter
    -   reactable
    -   Dinâmica: definição e exemplo para cada pacote

Conteúdos extras: - feature engineering - tradução de perguntas de
pesquisa - live de ggplot qualquer coisa - esquisse

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
  "sf",
  "geobr",
  "ggalt",
  "ggthemes",
  "patchwork",
  "plotly"
)
install.packages(principal)

# Pacotes instalados via GitHub
if (!require(remotes)) install.packages("remotes")
remotes::install_github("abjur/abjData")
remotes::install_github("cienciadedatos/dados")


# esses pacotes são apenas para a aula de miscelânea.
# se não conseguir instalar algum deles, não se preocupe!
misc <- c(
  "av", 
  "transformr", 
  "gifski",
  "gganimate",
  "leaflet",
  "highcharter",
  "ggspatial",
  "ggrepel"
)

install.packages(misc)
```
