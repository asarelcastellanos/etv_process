library(shiny)
library(devtools)

# Install htmltab
if (!requireNamespace("htmltab", quietly = TRUE)) {
  devtools::install_github("crubba/htmltab")
}

library(htmltab)
library(here)
library(readxl)
library(tidyr)
library(dplyr)
library(stringr)
library(forcats)
library(purrr)
library(ggplot2)
library(DT)

# Data for dplyr functions
rap_music <- data.frame(
  SongID = c(1, 2, 3, 4, 5),
  Artist = c("Kendrick Lamar", "Drake", "J. Cole", "Travis Scott", "Lil Wayne"),
  Song = c("HUMBLE.", "God's Plan", "Middle Child", "Sicko Mode", "A Milli"),
  Album = c("DAMN.", "Scorpion", "Revenge of the Dreamers", "Astroworld", "Tha Carter III"),
  Streams_Million = c(900, 1500, 800, 1200, 600),
  Release_Year = c(2017, 2018, 2019, 2018, 2008)
)

# Data for binding
lego_parts_1 <- data.frame(
  PartID = c(101, 102, 103),
  Name = c("Brick 2x2", "Brick 1x4", "Plate 2x6"),
  Color = c("Red", "Blue", "Green")
)

lego_parts_2 <- data.frame(
  PartID = c(104, 105, 106),
  Name = c("Tile 1x2", "Slope 2x2", "Brick 2x8"),
  Color = c("Yellow", "Black", "Orange")
)

lego_attributes <- data.frame(
  PartID = c(101, 102, 103),
  Material = c("Plastic", "Plastic", "Plastic"),
  Weight_g = c(2.5, 3.0, 4.5)
)

# Data for joining
movies_1 <- data.frame(
  MovieID = c(1, 2, 3, 4),
  Title = c("Inception", "Titanic", "Avatar", "Interstellar"),
  Genre = c("Sci-Fi", "Drama", "Sci-Fi", "Sci-Fi")
)

movies_2 <- data.frame(
  MovieID = c(3, 4, 5, 6),
  Director = c("James Cameron", "Christopher Nolan", "Ridley Scott", "Steven Spielberg")
)

# Data for pivoting
sales_data <- data.frame(
  Product = c("iPhone", "Macs", "Apple Watch"),
  Sales_2021 = c(1000, 800, 1200),
  Sales_2022 = c(1200, 850, 1300)
)

shift_data <- data.frame(
  Employee = c("Alice", "Bob", "Charlie", "Alice", "Bob", "Charlie"),
  Day = c("Monday", "Monday", "Monday", "Tuesday", "Tuesday", "Tuesday"),
  Shift = c("Morning", "Evening", "Night", "Morning", "Evening", "Night")
)

# Data for unite() and separate()
video_games <- data.frame(
  GameID = c(1, 2, 3, 4),
  Title = c("Zelda", "Mario Kart", "Halo", "Call of Duty"),
  Edition = c("Deluxe", "Ultimate", "Anniversary", "Modern Warfare"),
  Release_Date = c("2023-10-15", "2022-11-20", "2021-09-30", "2020-12-05")
)

# Data for stringr
text_data <- data.frame(
  ID = 1:3,
  Text = c("Hello, world!", "Shiny is great", "R programming is fun")
)

# Data for forcats
mtcars_factor <- mtcars %>%
  mutate(
    cyl = as.factor(cyl),
    gear = as.factor(gear)
  )

ui <- fluidPage(

  theme = bslib::bs_theme(
    bootswatch = "flatly",
    primary = "#154734",
    secondary = "#E1E4D9",
    success = "#0D3B2E",
    base_font = bslib::font_google("Roboto Slab")
  ),
  
  tags$head(
    tags$style(HTML("
        body { background-color: #f4f6f9; }
        h1, h2, h3 { color: #154734; font-weight: bold; }
        .table { background-color: white; border-radius: 8px; border: 2px solid #154734; }
        .shiny-bound-output { font-size: 16px; }
        .well { background-color: #FFF; color: #154734; font-weight: thin }
        .btn-primary { background-color: #154734; border-color: #0D3B2E; }
        .btn-primary:hover { background-color: #0D3B2E; }
        .section-divider { border-top: 3px solid #154734; margin-top: 30px; margin-bottom: 30px;  }
    "))
  ),
  
  div(
    style = "padding: 20px;",
    
    # Start of Title Section
    
    div(
      style = "text-align: center;",
      titlePanel("Data Science Process: The ETV Framework"),
      p("The Extraction, Transformation, and Visualization (ETV) process is essential in data science to clean, analyze, and interpret data effectively.")
    ),
    
    # End of Title Section
    
    div(class = "section-divider"),
    
    # Start of Data Extraction
    
    h2("Data Extraction"),
    p("Extracting data is the first step in the data science workflow. 
      Data can be sourced from websites, files, APIs, or databases. 
      Ensuring accurate and efficient data extraction is crucial for subsequent analysis and decision-making."),
    div(class = "section-divider"),
    
    
    h3("Web Scrapping and File Import"),
    p("This app demonstrates how to web scrape (with htmltab) and import xlsx files:"),
    tags$ul(
      tags$li(strong("Web Scraping (Wikipedia):"), " Extracting structured data from web pages."),
      tags$li(strong("File Import (Excel):"), " Reading datasets from locally stored files.")
    ),
    
    sidebarLayout(
      sidebarPanel(
        radioButtons("data_source", "Choose a Data Extraction Method:",
                     choices = c("Scrape Wikipedia Table", "Import CSV File"),
                     selected = "Scrape Wikipedia Table"),
        h4("R Code Used"),
        conditionalPanel(
          condition = "input.data_source == 'Scrape Wikipedia Table'",
          verbatimTextOutput("scrape_code")
        ),
        
        conditionalPanel(
          condition = "input.data_source == 'Import CSV File'",
          verbatimTextOutput("csv_code")
        ),
      ),
      
      mainPanel(
        h4(strong("Extracted Data")),
        dataTableOutput("extracted_data")
      )
    ),
    
    # End of Data Extraction
    
    div(class = "section-divider"),
    
    # Start of Data Transformation
    
    h2("Data Transformation"),
    p("Once data is extracted, it often requires cleaning and structuring before analysis.
      Data transformation involves filtering, aggregating, and reshaping data to make it useful for visualization and modeling."),
    
    
    div(class = "section-divider"),
    h3("dplyr functions"),
    p("This app demonstrates five core dplyr functions:"),
    tags$ul(
      tags$li(strong("filter():"), "Selects rows that match certain criteria."),
      tags$li(strong("select():"), "Chooses specific columns from the dataset."),
      tags$li(strong("mutate():"), "Adds new columns or modifies existing ones."),
      tags$li(strong("arrange():"), "Sorts data by one or more columns."),
      tags$li(strong("summarize():"), "Aggregates data into meaningful summaries.")
    ),
    
    sidebarLayout(
      sidebarPanel(
        radioButtons("dplyr_choice", "Choose a dplyr Function:",
                     choices = c("Filter Songs", "Select Columns", "Mutate Add Streams", "Arrange by Popularity", "Summarize Average Streams"),
                     selected = "Filter Songs"),
        h4("R Code Used"),
        conditionalPanel(
          condition = "input.dplyr_choice == 'Filter Songs'",
          verbatimTextOutput("dplyr_filter")
        ),
        conditionalPanel(
          condition = "input.dplyr_choice == 'Select Columns'",
          verbatimTextOutput("dplyr_select")
        ),
        conditionalPanel(
          condition = "input.dplyr_choice == 'Mutate Add Streams'",
          verbatimTextOutput("dplyr_mutate")
        ),
        conditionalPanel(
          condition = "input.dplyr_choice == 'Arrange by Popularity'",
          verbatimTextOutput("dplyr_arrange")
        ),
        conditionalPanel(
          condition = "input.dplyr_choice == 'Summarize Average Streams'",
          verbatimTextOutput("dplyr_summarize")
        )
      ),
      
      mainPanel(
        h4(strong("Example Dataset")),
        tableOutput("rap_music_original"),
        
        h4(strong("Transformed Dataset")),
        dataTableOutput("rap_music_transformed")
      )
    ),
    
    br(), br(), br(),
    
    h3("bind_*() Functions"),
    p("Binding datasets is another useful technique for combining data, either by stacking rows or adding columns."),
    p("This app demonstrates two types of binding:"),
    tags$ul(
      tags$li(strong("bind_rows():"), "Stacks datasets together by rows, useful when appending new data."),
      tags$li(strong("bind_cols():"), "Combines datasets by columns, useful when merging complementary attributes.")
    ),
    
    sidebarLayout(
      sidebarPanel(
        radioButtons("bind_choice", "Choose a Binding Function:",
                     choices = c("Bind Rows", "Bind Columns"),
                     selected = "Bind Rows"),
        h4("R Code Used"),
        conditionalPanel(
          condition = "input.bind_choice == 'Bind Rows'",
          verbatimTextOutput("bind_row")
        ),
        conditionalPanel(
          condition = "input.bind_choice == 'Bind Columns'",
          verbatimTextOutput("bind_col")
        )
      ),
      
      mainPanel(
        h4(strong("Example Datasets")),
        uiOutput("example_datasets"),
        h4(strong("Bound Dataset")),
        dataTableOutput("bound_data")
      )
    ),
    
    br(), br(), br(),
    
    h3("join_*() Functions"),
    p("Joining datasets is a fundamental operation in data analysis, combining information from multiple sources."),
    p("This app demonstrates several types of joins:"),
    tags$ul(
      tags$li(strong("inner_join():"), "Returns only matching rows from both datasets."),
      tags$li(strong("left_join():"), "Returns all rows from the left dataset and matching rows from the right."),
      tags$li(strong("right_join():"), "Returns all rows from the right dataset and matching rows from the left."),
      tags$li(strong("full_join():"), "Returns all rows from both datasets, matching where possible."),
      tags$li(strong("semi_join():"), "Returns rows from the left dataset that have a match in the right dataset."),
      tags$li(strong("anti_join():"), "Returns rows from the left dataset that do not have a match in the right dataset.")
    ),  
    
    sidebarLayout(
      sidebarPanel(
        radioButtons("join_choice", "Choose a Join Function:",
                     choices = c("Inner Join", "Left Join", "Right Join", "Full Join", "Semi Join", "Anti Join"),
                     selected = "Inner Join"),
        h4(strong("Join Explanation")),
        conditionalPanel(
          condition = "input.join_choice == 'Inner Join'",
          tags$img(src = "https://github.com/gadenbuie/tidyexplain/raw/main/images/inner-join.gif", 
                   style = "max-height: 300px; width: auto; display: block; margin: auto;"),
          h4("R Code Used"),
          verbatimTextOutput("inner_join_code")
        ),
        conditionalPanel(
          condition = "input.join_choice == 'Left Join'",
          tags$img(src = "https://github.com/gadenbuie/tidyexplain/raw/main/images/left-join.gif", 
                   style = "max-height: 300px; width: auto; display: block; margin: auto;"),
          h4("R Code Used"),
          verbatimTextOutput("left_join_code")
        ),
        conditionalPanel(
          condition = "input.join_choice == 'Right Join'",
          tags$img(src = "https://github.com/gadenbuie/tidyexplain/raw/main/images/right-join.gif", 
                   style = "max-height: 300px; width: auto; display: block; margin: auto;"),
          h4("R Code Used"),
          verbatimTextOutput("right_join_code")
        ),
        conditionalPanel(
          condition = "input.join_choice == 'Full Join'",
          tags$img(src = "https://github.com/gadenbuie/tidyexplain/raw/main/images/full-join.gif", 
                   style = "max-height: 300px; width: auto; display: block; margin: auto;"),
          h4("R Code Used"),
          verbatimTextOutput("full_join_code")
        ),
        conditionalPanel(
          condition = "input.join_choice == 'Semi Join'",
          tags$img(src = "https://github.com/gadenbuie/tidyexplain/raw/main/images/semi-join.gif", 
                   style = "max-height: 300px; width: auto; display: block; margin: auto;"),
          h4("R Code Used"),
          verbatimTextOutput("semi_join_code")
        ),
        conditionalPanel(
          condition = "input.join_choice == 'Anti Join'",
          tags$img(src = "https://github.com/gadenbuie/tidyexplain/raw/main/images/anti-join.gif", 
                   style = "max-height: 300px; width: auto; display: block; margin: auto;"),
          h4("R Code Used"),
          verbatimTextOutput("anti_join_code")
        )
      ),
      
      mainPanel(
        h4(strong("Example Datasets")),
        fluidRow(
          column(6, tableOutput("movies_1")),
          column(6, tableOutput("movies_2"))
        ),
        
        h4(strong("Joined Dataset")),
        dataTableOutput("joined_data")
      )
    ),
    
    br(), br(), br(),
    
    h3("pivot_*() Functions"),
    p("Data is often stored in different formats, and reshaping it correctly is crucial for analysis."),
    p("This app demonstrates two types of pivoting:"),
    tags$ul(
      tags$li(strong("pivot_longer():"), "Converts wide data into long format, useful for time-series analysis."),
      tags$li(strong("pivot_wider():"), "Converts long data into wide format, useful for making data more readable.")
    ),
    
    sidebarLayout(
      sidebarPanel(
        radioButtons("pivot_choice", "Choose a Pivot Function:",
                     choices = c("Pivot Sales Data (Wide → Long)", 
                                 "Pivot Employee Shift Schedule (Long → Wide)"),
                     selected = "Pivot Sales Data (Wide → Long)"),
        h4("R Code Used"),
        conditionalPanel(
          condition = "input.pivot_choice == 'Pivot Sales Data (Wide → Long)'",
          verbatimTextOutput("pivot_long_code")
          ),
        conditionalPanel(
          condition = "input.pivot_choice == 'Pivot Employee Shift Schedule (Long → Wide)'",
          verbatimTextOutput("pivot_wide_code")
        ),
        br(),
        h4("Explanation GIF"),
        tags$img(src = "https://raw.githubusercontent.com/gadenbuie/tidyexplain/main/images/tidyr-pivoting.gif",
                 style = "max-height: 300px; width: auto; display: block; margin: auto;")
      ),
      
      mainPanel(
        h4(strong("Original Dataset")),
        tableOutput("original_dataset"),
        
        h4(strong("Transformed Dataset")),
        dataTableOutput("pivot_dataset")
      )
    ),
    
    br(), br(), br(),
    
    h3("unite() and separate() Functions"), 
    p("Columns in a dataset sometimes need to be combined or split for better analysis and presentation."),
    p("This app demonstrates two powerful functions for column manipulation:"),
    tags$ul(
      tags$li(strong("unite():"), "Combines multiple columns into one, using a specified separator."),
      tags$li(strong("separate():"), "Splits a single column into multiple columns based on a separator.")
    ),
    
    sidebarLayout(
      sidebarPanel(
        radioButtons("column_manip_choice", "Choose a Column Manipulation Function:",
                     choices = c("Unite Game Title & Edition", "Separate Release Date"),
                     selected = "Unite Game Title & Edition"),
        h4("R Code Used"),
        conditionalPanel(
          condition = "input.column_manip_choice == 'Unite Game Title & Edition'",
          verbatimTextOutput("unite_code")
        ),
        conditionalPanel(
          condition = "input.column_manip_choice == 'Separate Release Date'",
          verbatimTextOutput("seperate_code")
        )
      ),
      
      mainPanel(
        h4(strong("Example Dataset")),
        tableOutput("games_original"),
        
        h4(strong("Transformed Dataset")),
        dataTableOutput("games_transformed")
      )
    ),
    
    # End of Data Transformation
    
    div(class = "section-divider"),
    
    # Start of Data Visualization
    
    h2("Data Visualiztion"),
    p("Data visualization is the process of representing data graphically to uncover insights and trends. Effective visualization enhances understanding and helps in decision-making by making complex information more accessible."),
    div(class = "section-divider"),
    
    h3("ggplot2"),
    
    sidebarLayout(
      sidebarPanel(
        h4("Step 1: Choose Plot Type"),
        radioButtons("ggplot_geom", "Choose a Plot Type:",
                     choices = c("Bar Chart (geom_bar)" = "bar",
                                 "Scatter Plot (geom_point)" = "point",
                                 "Line Chart (geom_line)" = "line"),
                     selected = "bar"),
        
        conditionalPanel(
          condition = "input.ggplot_geom == 'bar'",
          selectInput("x_var", "Select X-Axis:",
                      choices = c("Season" = "Season", "Game Location" = "Game_Location", 
                                  "Game Outcome" = "Game_Outcome", "Opponent" = "Opp", "Games Started" = "GS"),
                      selected = "Season")
        ),
        conditionalPanel(
          condition = "input.ggplot_geom != 'bar'",
          selectInput("x_var", "Select X-Axis:",
                      choices = c("Game Score" = "GmSc", "Points" = "PTS", 
                                  "Assists" = "AST", "Field Goal %" = "FG_Percent", "Minutes Played" = "MP"),
                      selected = "GmSc")
        ),
        
        selectInput("y_var", "Select Y-Axis:",
                    choices = c("Game Score" = "GmSc", "Points" = "PTS", 
                                "Assists" = "AST", "Field Goal %" = "FG_Percent", "Minutes Played" = "MP"),
                    selected = "PTS"),
        
        h4("Step 2: Add some color."),
        checkboxInput("use_color_fill", "Use Color/Fill Mapping for Game Outcome", value = FALSE),
        
        checkboxInput("use_custom_colors", "Customize Colors for Wins/Losses", value = FALSE),
        textInput("win_color", "Color for Wins (W):", value = "blue"),
        textInput("loss_color", "Color for Losses (L):", value = "red"),
        
        h4("Step 3: Choose a Theme"),
        radioButtons("theme_choice", "Select Theme:",
                     choices = c("Minimal" = "minimal",
                                 "Classic" = "classic"),
                     selected = "minimal")
      ),
      
      mainPanel(
        plotOutput("ggplot_combined")
      )
    ),
    
    br(), br(), br(),
    
    # End of Data Visualization
    
    div(class = "section-divider"),
    
    # Start of Special Data Types
    
    h2("Special Data Types"),
    p("In data analysis, special data types like strings, dates, and categorical factors require specific handling to ensure accurate transformation and visualization. 
      The `stringr` package simplifies text processing, `lubridate` makes working with dates intuitive, and `forcats` provides powerful tools for managing categorical data."),
    div(class = "section-divider"),
    
    h3("Strings – stringr"),
    p("String manipulation is an essential part of data cleaning and transformation. Here are two common functions from stringr:"),
    tags$ul(
      tags$li(strong("str_detect():"), " Detects the presence of a pattern in a string."),
      tags$li(strong("str_replace():"), " Replaces a substring in a string with another substring.")
    ),
    
    sidebarLayout(
      sidebarPanel(
        radioButtons("string_choice", "Choose a String Function:",
                     choices = c("Detect Pattern", "Replace Text"),
                     selected = "Detect Pattern"),
        
        h4("R Code Used"),
        conditionalPanel(
          condition = "input.string_choice == 'Detect Pattern'",
          verbatimTextOutput("string_code_detect")
        ),
        conditionalPanel(
          condition = "input.string_choice == 'Replace Text'",
          verbatimTextOutput("string_code_replace")
        )
      ),
      
      mainPanel(
        h4(strong("Original Dataset")),
        tableOutput("text_data_original"),
        
        h4(strong("Transformed Dataset")),
        dataTableOutput("text_data_transformed")
      )
    ),
    
    br(), br(), br(),
    
    h3("Time – lubridate"),
    p("The lubridate package provides easy-to-use functions for handling date and time in R."),
    tags$ul(
      tags$li(strong("ymd():"), " Converts a character string to a date in year-month-day format."),
      tags$li(strong("floor_date():"), " Rounds down a date to a specified time unit.")
    ),
    
    br(), br(), br(),
    
    h3("Factors – forcats"),
    p("Factors are used to represent categorical data. The forcats package provides functions to manipulate factors effectively."),
    tags$ul(
      tags$li(strong("fct_reorder():"), " Reorders factor levels based on another variable."),
      tags$li(strong("fct_lump():"), " Groups infrequent factor levels into an 'Other' category.")
    ),
    
    sidebarLayout(
      sidebarPanel(
        radioButtons("factor_choice", "Choose a Factor Function:",
                     choices = c("Reorder Cylinders", "Lump Rare Gears"),
                     selected = "Reorder Cylinders"),
        
        h4("R Code Used"),
        conditionalPanel(
          condition = "input.factor_choice == 'Reorder Cylinders'",
          verbatimTextOutput("factor_code_reorder")
        ),
        conditionalPanel(
          condition = "input.factor_choice == 'Lump Rare Gears'",
          verbatimTextOutput("factor_code_lump")
        )
      ),
      
      mainPanel(
        h4(strong("Original Dataset")),
        dataTableOutput("mtcars_original"),
        
        h4(strong("Transformed Dataset")),
        dataTableOutput("mtcars_transformed")
      )
    ),
    
    # End of Special Data Types
    
    div(class = "section-divider"),
    
    # Start of Programming Concepts
    
    h2("Programming Concepts"),
    p("Programming concepts form the foundation of data processing and manipulation within the ETV cycle. 
      Control structures and functional programming allow for efficient iteration, decision-making, and modular code to streamline the transformation process."),
    div(class = "section-divider"),
    
    h3("Control Structures & Iteration"),
    p("Control structures and iteration allow for efficient program flow and repetitive operations. Below are key examples of using loops and conditionals in R."),
    tags$ul(
      tags$li(strong("for loop:"), " Useful for iterating over sequences or applying operations repeatedly for a fixed number of iterations."),
      tags$li(strong("while loop:"), " Suitable for cases where the number of iterations is unknown beforehand and depends on a condition."),
      tags$li(strong("if/else statements:"), " Used for making logical decisions within loops or functions.")
    ),
    
    sidebarLayout(
      sidebarPanel(
        radioButtons("iteration_choice", "Choose an Iteration Method:",
                     choices = c("For Loop", "While Loop", "If/Else Statement"),
                     selected = "For Loop"),
        
        h4("R Code Used"),
        conditionalPanel(
          condition = "input.iteration_choice == 'For Loop'",
          verbatimTextOutput("iteration_code_for")
        ),
        conditionalPanel(
          condition = "input.iteration_choice == 'While Loop'",
          verbatimTextOutput("iteration_code_while")
        ),
        conditionalPanel(
          condition = "input.iteration_choice == 'If/Else Statement'",
          verbatimTextOutput("iteration_code_ifelse")
        )
      ),
      
      mainPanel(
        h4(strong("Iteration Output")),
        verbatimTextOutput("iteration_output")
      )
    ),
    
    br(),br(),br(),
    
    h3("Functional Programming – purrr"),
    p("Functional programming in R allows for concise, efficient transformations of data. The `purrr` package provides a suite of functions that apply operations across data structures."),
    tags$ul(
      tags$li(strong("map()"), " Applies a function to each element of a list or vector efficiently.")
    ),
    
    sidebarLayout(
      sidebarPanel(
        h4("R Code Used"),
        verbatimTextOutput("purrr_code")
        
      ),
      
      mainPanel(
        h4(strong("Purrr Output")),
        verbatimTextOutput("purrr_output")
      )
    ),
    
    # End of Programming Concepts
    
    div(class = "section-divider"),
    
    # Start of Statistics
    
    h2("Statistics"),
    p("Statistical analysis is a crucial part of the ETV cycle, allowing for the transformation of raw data into meaningful insights. 
      Simulations and hypothesis testing provide methods for evaluating patterns and making data-driven decisions."),
    div(class = "section-divider"),
    
    h3("Simulation"),
    p("Simulation in statistics helps to model real-world scenarios by generating synthetic data. 
   Here, we model the spread of a disease using `rbinom()` to determine infection status 
   and `rnorm()` to simulate the number of sick days for infected individuals."),
    
    h4("Understanding the Statistical Measures"),
    p("In this simulation, we use key statistical measures to analyze the spread of disease:"),
    tags$ul(
      tags$li(strong("Mean:"), " The average number of sick days for infected individuals."),
      tags$li(strong("Standard Deviation (SD):"), " Measures how much sick days vary from the average."),
      tags$li(strong("Sample Size:"), " The total number of individuals in the simulation (500)."),
      tags$li(strong("Proportions:"), " The percentage of individuals who are infected versus those who remain healthy.")
    ),
    
    sidebarLayout(
      sidebarPanel(
        radioButtons("simulation_choice", "Choose a Simulation Method:",
                     choices = c("Infection Status (Binomial)", "Days Sick (Normal)"),
                     selected = "Infection Status (Binomial)"),
        
        h4("R Code Used"),
        conditionalPanel(
          condition = "input.simulation_choice == 'Infection Status (Binomial)'",
          verbatimTextOutput("simulation_code_binom")
        ),
        conditionalPanel(
          condition = "input.simulation_choice == 'Days Sick (Normal)'",
          verbatimTextOutput("simulation_code_norm")
        )
      ),
      
      mainPanel(
        h4(strong("Simulation Output")),
        plotOutput("simulation_output"),
        
        h4(strong("Summary Statistics")),
        verbatimTextOutput("simulation_summary")
      )
    ),
    
    br(), br(), br(),
    
    h3("Statistical Analysis"),
    p("Statistical tests are essential for hypothesis testing and data analysis. Here, we apply three key tests: Linear Regression, ANOVA, and T-Test."),
    
    sidebarLayout(
      sidebarPanel(
        radioButtons("stat_test_choice", "Choose a Statistical Test:",
                     choices = c("Linear Regression", "ANOVA", "T-Test"),
                     selected = "Linear Regression"),
        
        h4("R Code Used"),
        conditionalPanel(
          condition = "input.stat_test_choice == 'Linear Regression'",
          verbatimTextOutput("stat_code_lm")
        ),
        conditionalPanel(
          condition = "input.stat_test_choice == 'ANOVA'",
          verbatimTextOutput("stat_code_anova")
        ),
        conditionalPanel(
          condition = "input.stat_test_choice == 'T-Test'",
          verbatimTextOutput("stat_code_ttest")
        )
      ),
      
      mainPanel(
        h4(strong("Statistical Test Output")),
        verbatimTextOutput("stat_output")
      )
    )
    
    # End of Statistics
  )
)

server <- function(input, output, session) {
  
  MJ_df <- reactive({
    req(file.exists(here("www", "nba_goats.xlsx")))
    read_xlsx(here("www", "nba_goats.xlsx")) %>%
      mutate(
        Season = fct_relevel(Season, 
                             "season_1", "season_2", "season_3", "season_4", "season_5", 
                             "season_6", "season_7", "season_8", "season_9", "season_10",
                             "season_11", "season_12", "season_13", "season_14", "season_15"),
        Game_Location = as.factor(Game_Location),
        Game_Outcome = as.factor(Game_Outcome),
        Opp = as.factor(Opp),
        GS = as.factor(GS)
      )
  })
  
  # Start of Data Extraction
  
  extracted_wikipedia <- function() {
    url <- "https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_GDP"
    table <- htmltab::htmltab(doc = url, which = 1)
    return(table)
  }
  
  extracted_csv <- function() {
    return(MJ_df())
  }
  
  output$extracted_data <- renderDataTable({
    if (input$data_source == "Scrape Wikipedia Table") {
      extracted_wikipedia()
    } else {
      extracted_csv()
    }
  }, options = list(scrollX = TRUE, columnDefs = list(
    list(className = "dt-center", targets = "_all")
  )),
  class = "compact display")
  
  output$scrape_code <- renderText({"url <- \"https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_GDP\" \ndata <- htmltab::htmltab(doc = url, which = 1)\nprint(data)"})
  output$csv_code <- renderText({"data <- read_xlsx(\"nba_goats.xlsx\") \nprint(data)"})
  
  # End of Data Extraction
  
  # Start of Data Transformation
  
  output$rap_music_original <- renderTable({ rap_music })
  
  output$rap_music_transformed <- renderDataTable({
    switch(input$dplyr_choice,
           "Filter Songs" = rap_music %>% filter(Streams_Million > 800),
           "Select Columns" = rap_music %>% select(Artist, Song, Streams_Million),
           "Mutate Add Streams" = rap_music %>% mutate(Streams_Billion = Streams_Million / 1000),
           "Arrange by Popularity" = rap_music %>% arrange(desc(Streams_Million)),
           "Summarize Average Streams" = rap_music %>% summarize(Average_Streams = mean(Streams_Million))
    )
  }, options = list(scrollX = TRUE, columnDefs = list(
    list(className = "dt-center", targets = "_all")
  )),
  class = "compact display")
  
  output$dplyr_filter <- renderText({"mod_1_rap_music <- rap_music %>%\n\t filter(Streams_Million > 800)"})
  output$dplyr_select <- renderText({"mod_1_rap_music <- rap_music %>%\n\t select(Artist, Song, Streams_Million)"})
  output$dplyr_mutate <- renderText({"mod_1_rap_music <- rap_music %>%\n\t mutate(Streams_Billion = Streams_Million / 1000)"})
  output$dplyr_arrange <- renderText({"mod_1_rap_music <- rap_music %>%\n\t arrange(desc(Streams_Million))"})
  output$dplyr_summarize <- renderText({"mod_1_rap_music <- rap_music %>%\n\t summarize(Average_Streams = mean(Streams_Million))"})
  
  output$example_datasets <- renderUI({
    if (input$bind_choice == "Bind Rows") {
      fluidRow(
        column(6, renderTable({ lego_parts_1 })),
        column(6, renderTable({ lego_parts_2 }))
      )
    } else {
      fluidRow(
        column(6, renderTable({ lego_parts_1 })),
        column(6, renderTable({ lego_attributes }))
      )
    }
  })
  
  output$bound_data <- renderDataTable({
    if (input$bind_choice == "Bind Rows") {
      bind_rows(lego_parts_1, lego_parts_2)
    } else {
      bind_cols(lego_parts_1, lego_attributes)
    }
  }, options = list(scrollX = TRUE, columnDefs = list(
    list(className = "dt-center", targets = "_all")
  )),
  class = "compact display")
  
  output$bind_row <- renderText({"mod_1_lego <- bind_rows(lego_parts_1, lego_parts_2)"})
  output$bind_col <- renderText({"mod_1_lego <- bind_cols(lego_parts_1, lego_attributes)"})
  
  output$movies_1 <- renderTable({ movies_1 })
  output$movies_2 <- renderTable({ movies_2 })
  
  output$joined_data <- renderDataTable({
    switch(input$join_choice,
           "Inner Join" = inner_join(movies_1, movies_2, by = "MovieID"),
           "Left Join" = left_join(movies_1, movies_2, by = "MovieID"),
           "Right Join" = right_join(movies_1, movies_2, by = "MovieID"),
           "Full Join" = full_join(movies_1, movies_2, by = "MovieID"),
           "Semi Join" = semi_join(movies_1, movies_2, by = "MovieID"),
           "Anti Join" = anti_join(movies_1, movies_2, by = "MovieID")
    )
  }, options = list(scrollX = TRUE, columnDefs = list(
    list(className = "dt-center", targets = "_all")
  )),
  class = "compact display")
  
  output$inner_join_code <- renderText({"mod_movies <- inner_join(movies_1, movies_2, by = 'MovieID')"})
  output$left_join_code <- renderText({"mod_movies <- left_join(movies_1, movies_2, by = 'MovieID')"})
  output$right_join_code <- renderText({"mod_movies <- right_join(movies_1, movies_2, by = 'MovieID')"})
  output$full_join_code <- renderText({"mod_movies <- full_join(movies_1, movies_2, by = 'MovieID')"})
  output$semi_join_code <- renderText({"mod_movies <- semi_join(movies_1, movies_2, by = 'MovieID')"})
  output$anti_join_code <- renderText({"mod_movies <- anti_join(movies_1, movies_2, by = 'MovieID')"})
  
  output$original_dataset <- renderTable({
    if (input$pivot_choice == "Pivot Sales Data (Wide → Long)") {
      sales_data
    } else {
      shift_data
    }
  })
  
  output$pivot_dataset <- renderDataTable({
    if (input$pivot_choice == "Pivot Sales Data (Wide → Long)") {
      sales_data %>%
        pivot_longer(cols = c(Sales_2021, Sales_2022),
                     names_to = "Year",
                     values_to = "Sales")
    } else {
      shift_data %>%
        pivot_wider(names_from = Day, values_from = Shift)
    }
  })
  
  output$pivot_long_code <- renderText({ "mod_1_sales_data <- sales_data %>%\n\t pivot_longer(cols = c(Sales_2021, Sales_2022), names_to = 'Year', values_to = 'Sales')" })
  output$pivot_wide_code <- renderText({ "mod_1_shift_data <- shift_data %>%\n\t pivot_wider(names_from = Day, values_from = Shift)" })
  
  output$games_original <- renderTable({ video_games })
  
  output$games_transformed <- renderDataTable({
    if (input$column_manip_choice == "Unite Game Title & Edition") {
      video_games %>%
        unite("Full_Title", Title, Edition, sep = " - ")
    } else {
      video_games %>%
        separate(Release_Date, into = c("Year", "Month", "Day"), sep = "-")
    }
  })
  
  output$unite_code <- renderText({ "mod_1_video_games <- video_games %>%\n\t unite('Full_Title', Title, Edition, sep = ' - ')" })
  output$seperate_code <- renderText({ "mod_1_video_games <- video_games %>%\n\t separate(Release_Date, into = c('Year', 'Month', 'Day'), sep = '-')" })
  
  # End of Data Transformation
  
  # Start of Data Visualization
  
  observeEvent(input$ggplot_geom, {
    if (input$ggplot_geom == "bar") {
      updateSelectInput(session, "x_var", 
                        choices = c("Season" = "Season", "Game Location" = "Game_Location", 
                                    "Game Outcome" = "Game_Outcome", "Opponent" = "Opp", "Games Started" = "GS"),
                        selected = "Season")
    } else {
      updateSelectInput(session, "x_var", 
                        choices = c("Game Score" = "GmSc", "Points" = "PTS", 
                                    "Assists" = "AST", "Field Goal %" = "FG_Percent", "Minutes Played" = "MP"),
                        selected = "GmSc")
    }
  })
  
  output$ggplot_combined <- renderPlot({
    
    df <- MJ_df()
    
    combined_plot <- ggplot(df, aes_string(x = input$x_var, y = input$y_var))
    
    if (input$ggplot_geom == "point") {
      if (input$use_color_fill) {
        combined_plot <- combined_plot + geom_point(aes(color = Game_Outcome))
      } else {
        combined_plot <- combined_plot + geom_point()
      }
    } 
    else if (input$ggplot_geom == "bar") {
      if (input$use_color_fill) {
        combined_plot <- combined_plot + geom_bar(stat = "identity", aes(fill = Game_Outcome))
      } else {
        combined_plot <- combined_plot + geom_bar(stat = "identity")
      }
    }
    else if (input$ggplot_geom == "line") {
      if (input$use_color_fill) {
        combined_plot <- combined_plot + geom_line(aes(color = Game_Outcome))
      } else {
        combined_plot <- combined_plot + geom_line()
      }
    }
    
    if (input$use_custom_colors && input$use_color_fill) {
      if (input$ggplot_geom == "bar") {
        combined_plot <- combined_plot + scale_fill_manual(
          name = "Game Outcome",
          values = c("W" = input$win_color, "L" = input$loss_color)
        )
      } else {
        combined_plot <- combined_plot + scale_color_manual(
          name = "Game Outcome",
          values = c("W" = input$win_color, "L" = input$loss_color)
        )
      }
    }
    
    combined_plot <- combined_plot + switch(
      input$theme_choice,
      "minimal" = theme_minimal(),
      "classic" = theme_classic(),
      theme_minimal()
    )
    
    combined_plot <- combined_plot + labs(
      title = paste(input$y_var, "vs", input$x_var),
      x = input$x_var, y = input$y_var
    ) + theme(
      plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
      axis.title = element_text(face = "bold", size = 14)
    )
    
    combined_plot
  })
  
  # End of Data Visualization
  
  # Start of Special Data Types
  
  output$text_data_original <- renderTable({ text_data })
  
  output$text_data_transformed <- renderDataTable({
    if (input$string_choice == "Detect Pattern") {
      text_data %>% mutate(Contains_Shiny = str_detect(Text, "Shiny"))
    } else {
      text_data %>% mutate(Modified_Text = str_replace(Text, "is", "was"))
    }
  })
  
  output$string_code_detect <- renderText({ "mod_text_data <- text_data %>%\n\t mutate(Contains_Shiny = str_detect(Text, 'Shiny'))" })
  output$string_code_replace <- renderText({ "mod_text_data <- text_data %>%\n\t mutate(Modified_Text = str_replace(Text, 'is', 'was'))" })
  
  output$mtcars_original <- renderDataTable({ mtcars_factor })
  
  output$mtcars_transformed <- renderDataTable({
    if (input$factor_choice == "Reorder Cylinders") {
      mtcars_factor %>% mutate(cyl = fct_reorder(cyl, mpg, .fun = mean))
    } else {
      mtcars_factor %>% mutate(gear = fct_lump(gear, n = 2))
    }
  })
  
  output$factor_code_reorder <- renderText({ "mod_mtcars <- mtcars_factor %>%\n\t mutate(cyl = fct_reorder(cyl, mpg, .fun = mean))" })
  output$factor_code_lump <- renderText({ "mod_mtcars <- mtcars_factor %>%\n\t mutate(gear = fct_lump(gear, n = 2))" })
  
  # End of Special Data Types
  
  # Start of Programming Concepts
  
  output$iteration_code_for <- renderText({ "for(i in 1:5) \n{ \n\tprint(i^2) \n}" })
  output$iteration_code_while <- renderText({ "x <- 1\nwhile(x < 5) \n{ \n\tprint(x); \n\tx <- x + 1 \n}" })
  output$iteration_code_ifelse <- renderText({ "x <- 10\nif(x > 5) \n{ \n\tprint('Greater than 5') \n} else { \n\tprint('Less than or equal to 5') \n}" })
  
  output$iteration_output <- renderText({
    switch(input$iteration_choice,
           "For Loop" = paste(sapply(1:5, function(i) i^2), collapse = ", "),
           "While Loop" = {
             x <- 1; out <- c()
             while(x < 5) { out <- c(out, x); x <- x + 1 }
             paste(out, collapse = ", ")
           },
           "If/Else Statement" = ifelse(10 > 5, "Greater than 5", "Less than or equal to 5")
    )
  })
  
  output$purrr_output <- renderText({ 
    add_greeting <- function(name) {
      paste("Hello,", name)
    }
    
    names_list <- list("Michael", "LeBron", "Kobe")
    
    greetings <- map(names_list, add_greeting)
    
    paste(unlist(greetings), collapse = " | ")
  })
  
  output$purrr_code <- renderText({ 
    "add_greeting <- function(name) {\n\tpaste('Hello,', name)\n}\nnames_list <- list('Michael', 'LeBron', 'Kobe')\ngreetings <- map(names_list, add_greeting)"
  })
  
  # End of Programming Concepts
  
  # Start of Statistics
  
  output$simulation_code_binom <- renderText({ "rbinom(n = 500, size = 1, prob = 0.3)" })
  
  output$simulation_code_norm <- renderText({ "rnorm(n = 500, mean = 7, sd = 2)" })
  
  output$simulation_output <- renderPlot({
    set.seed(42)
    
    if (input$simulation_choice == "Infection Status (Binomial)") {
      infection_data <- data.frame(Infected = rbinom(n = 500, size = 1, prob = 0.3))
      
      ggplot(infection_data, aes(x = factor(Infected))) +
        geom_bar(fill = c("green", "red"), alpha = 0.7) +
        scale_x_discrete(labels = c("Healthy", "Infected")) +
        labs(title = "Disease Infection Distribution", x = "Infection Status", y = "Number of People") +
        theme_minimal()
      
    } else {
      infection_status <- rbinom(n = 500, size = 1, prob = 0.3)
      sick_days <- rnorm(n = 500, mean = 7, sd = 2)
      sick_days[infection_status == 0] <- 0
      
      sick_data <- data.frame(Sick_Days = sick_days[infection_status == 1])
      
      ggplot(sick_data, aes(x = Sick_Days)) +
        geom_histogram(binwidth = 1, fill = "red", alpha = 0.7, color = "black") +
        labs(title = "Distribution of Sick Days for Infected Individuals", x = "Days Sick", y = "Frequency") +
        theme_minimal()
    }
  })
  
  output$simulation_summary <- renderText({
    set.seed(42)
    
    infection_status <- rbinom(n = 500, size = 1, prob = 0.3)
    sick_days <- rnorm(n = 500, mean = 7, sd = 2)
    sick_days[infection_status == 0] <- 0
    
    total_population <- length(infection_status)
    infection_rate <- mean(infection_status) * 100
    healthy_rate <- (1 - mean(infection_status)) * 100
    avg_days_sick <- mean(sick_days[infection_status == 1])
    sd_days_sick <- sd(sick_days[infection_status == 1])
    
    paste(
      "Total Population:", total_population, "\n",
      "Infection Rate:", round(infection_rate, 1), "%\n",
      "Healthy Rate:", round(healthy_rate, 1), "%\n",
      "Average Sick Days (Infected Only):", round(avg_days_sick, 2), "\n",
      "Standard Deviation of Sick Days:", round(sd_days_sick, 2)
    )
  })
  
  output$stat_code_lm <- renderText({
    "lm(mpg ~ hp, data = mtcars)"
  })
  
  output$stat_code_anova <- renderText({
    "aov(mpg ~ cyl, data = mtcars)"
  })
  
  output$stat_code_ttest <- renderText({
    "t.test(mpg ~ am, data = mtcars)"
  })
  
  output$stat_output <- renderText({
    if (input$stat_test_choice == "Linear Regression") {
      capture.output(summary(lm(mpg ~ hp, data = mtcars)))  
    } else if (input$stat_test_choice == "ANOVA") {
      capture.output(summary(aov(mpg ~ cyl, data = mtcars)))  
    } else {
      capture.output(t.test(mpg ~ am, data = mtcars))
    }
  })
  
  # End of Statistics
}

shinyApp(ui = ui, server = server)