# Getting Started ====

# Following Xie et al. (2021) R Markdown: The Definitive Guide

## Install RMarkdown from CRAN ----
install.packages('rmarkdown')

# Or if you want to test the development version, install from GitHub
if (!requireNamespace("devtools"))
  install.packages('devtools')
devtools::install_github('rstudio/rmarkdown')

## Install a LaTeX distribution from CRAN ----
install.packages('tinytex')

# Complete the installation of tinytex
tinytex::install_tinytex()