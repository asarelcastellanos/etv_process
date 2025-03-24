library(shiny)
library(here)
library(readxl)
library(tidyr)
library(dplyr)
library(stringr)
library(forcats)
library(purrr)
library(ggplot2)
library(DT)
library(htmltab)

setwd(here::here())

if (file.exists("app.R")) {
  cat("🚀 Starting Shiny App... (app.R found)\n")
  shiny::runApp("app.R")
} else {
  cat("❌ Error: `app.R` not found in the project directory!\n")
}