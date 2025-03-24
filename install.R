required_packages <- c("shiny", "here", "readxl", "tidyr", "dplyr", "ggplot2", "stringr", "forcats", "purrr", "DT", "devtools")

install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

invisible(lapply(required_packages, install_if_missing))

if (!requireNamespace("htmltab", quietly = TRUE)) {
  install_if_missing("devtools")
  devtools::install_github("crubba/htmltab")
  library(htmltab)
}

cat("✅ All required packages are installed and loaded!\n")