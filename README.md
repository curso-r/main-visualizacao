
# Relatórios e visualização de dados

<!-- README.md is generated from README.Rmd. Please edit that file -->

Repositório principal do curso Relatórios e visualização de dados.

Inscreva-se no curso: <https://www.curso-r.com/cursos/visualizacao>

**Acesse o material completo do curso escolhendo uma das turmas
abaixo**.

| Turma         | Material                                        | Github                                           |
|:--------------|:------------------------------------------------|:-------------------------------------------------|
| Março de 2021 | <https://curso-r.github.io/202103-visualizacao> | <https://github.com/curso-r/202103-visualizacao> |

# Esqueleto do curso

Aula 01: Introdução

-   Ciclo da ciência de dados (mostrar que estamos em visualização +
    comunicação)
-   Referências de rmarkdown (site, cheatsheet, livro yihui, vídeos)
-   Showcase
-   Instalação: executar os diferentes exemplos, para testar se todas as
    dependências estão instaladas.

Aula 02: RMarkdown básico e Visualização

-   Sintaxe Markdown
-   Chunks
-   YAML
-   Principais saídas
    -   relatório (word, html, pdf, pagedown)
    -   apresentação (ppt, ioslides, beamer)
    -   flexdashboard
-   Revisão ggplot2
    -   ggplot()
    -   aes()
    -   alguns geom\_\*()
    -   theme()
-   Customizando temas

Aula 03: Visualização e RMarkdown Avançado

-   Mapas em ggplot2
-   Edição de CSS
-   `{xaringan}` e `{xaringanExtra}`
-   Netlify

Aula 04: Miscelânea

-   Tabelas: `{gt}` e `{gtsummary}`
-   Hacks e dicas práticas para relatórios Word, PDF e HTML
-   `{htmlWidgets}`
-   Templates legais da comunidade
-   Gráficos animados com `{gganimate}`
-   Grudando gráficos com `{patchwork}`

Aula 05: Extra

-   `{bookdown}`
-   distill e blogdown

**Trabalho de conclusão**: fazer o \#tidytuesday da semana ou um à sua
escolha. Fazer não só a visualização, mas uma apresentação ou relatório

**Opções de bases de dados para exemplos e exercícios**:

-   Covid (é meio triste, mas tem tudo que precisamos)
-   Dados de vacinação (deve ter alguma já)
-   `{dados}` para exemplos mais simples
-   Remedy

**Pacotes necessários**:

``` r
# Pacotes instalados via CRAN
install.packages(c(
  "tidyverse",
  "pagedown",
  "xaringan",
  "bookdown",
  "flexdashboard",
  "xaringanthemer",
  "sf",
  "geobr",
  "gganimate",
  "ggalt",
  "officedown"
  "rticles",
  "prettydoc",
  "ggthemes",
  "flextable",
  "patchwork",
  "gt",
  "gtsummary"
))

# Pacotes instalados via GitHub
install.packages("remotes")
remotes::install_github("cienciadedatos/dados")
remotes::install_github("ThinkR-open/remedy")
```
