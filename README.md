# 📊 Data Science Process: The ETV Framework Shiny Application

This R Shiny application demonstrates the Extraction, Transformation, and Visualization (ETV) process—a core workflow in data science. It is designed as an **educational tool** for people seeking to learn and grasp each part of the cycle. Through its interactive interface, users can not only see the outcomes of various data science techniques but also view the R code needed to run each aspect, making it a great resource for hands-on learning. 💻🎓

## ✨ Features

- **Data Extraction**
  - **Web Scraping:** Extract structured data from Wikipedia using the `htmltab` package. 🌐
  - **File Import:** Read Excel files (e.g., `nba_goats.xlsx`) using the `readxl` package. 📁

- **Data Transformation**
  - **dplyr Functions:** Demonstrates `filter()`, `select()`, `mutate()`, `arrange()`, and `summarize()` on a sample rap music dataset. 🎵
  - **Binding Datasets:** Combines data with `bind_rows()` and `bind_cols()`. 🔗
  - **Joining Data:** Illustrates inner, left, right, full, semi, and anti joins with two movie datasets. 🎬
  - **Pivoting:** Uses `pivot_longer()` and `pivot_wider()` to reshape datasets. 🔄
  - **Column Manipulation:** Applies `unite()` and `separate()` to modify dataset columns. ✂️

- **Data Visualization**
  - **ggplot2 Integration:** Create bar charts, scatter plots, and line charts with customizable aesthetics and themes. 📈
  - **Interactive Options:** Dynamically select plot types, axes, color mapping, and themes. 🎨

- **Special Data Types**
  - **String Manipulation:** Uses `stringr` functions like `str_detect()` and `str_replace()`. 🔤
  - **Factor Handling:** Demonstrates categorical data manipulation with the `forcats` package. 🗂️
  - **Date Handling:** Integrates date operations with `lubridate` if needed. 📆

- **Programming Concepts**
  - **Control Structures & Iteration:** Examples of `for` loops, `while` loops, and `if/else` statements. 🔁
  - **Functional Programming:** Uses the `purrr` package for mapping functions over lists. 🧩

- **Statistics**
  - **Simulation:** Models disease spread using binomial and normal distributions. 🦠
  - **Statistical Testing:** Implements linear regression, ANOVA, and T-tests on sample datasets. 🔍

## 🎯 Educational Value

This application is intended to serve as a comprehensive **learning tool**:
- **Interactive Learning:** Users can experiment with different aspects of data extraction, transformation, and visualization in real time. ⏱️
- **Code Transparency:** The app displays the R code behind every operation, enabling users to understand how each function works and how to implement it in their own projects. 💡
- **Step-by-Step Approach:** Each section of the ETV cycle is broken down into digestible parts, making it easier for beginners to follow along and for experienced users to refresh their knowledge. 📚

## 🚀 Installation

### Prerequisites

- **R:** Version 3.6 or higher.
- **RStudio:** Recommended for an enhanced development experience.

### Install Required R Packages

Make sure to install the following packages:
- `shiny`
- `devtools`
- `htmltab`
- `here`
- `readxl`
- `tidyr`
- `dplyr`
- `stringr`
- `forcats`
- `purrr`
- `ggplot2`
- `DT`
- `bslib`

You can install them by running:
```R
install.packages(c("shiny", "here", "readxl", "tidyr", "dplyr", "stringr", "forcats", "purrr", "ggplot2", "DT", "bslib"))
