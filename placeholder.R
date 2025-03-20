library(shiny)
library(devtools)
library(readr)
library(readxl)
if (!requireNamespace("htmltab", quietly = TRUE)) {
  devtools::install_github("crubba/htmltab")
}
library(htmltab)
library(tidyr)
library(dplyr)
library(stringr)
library(lubridate)
library(forcats)
library(purrr)
library(DT)

# Data for dplyr verbs
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
  PartID = c(104, 105),
  Name = c("Tile 1x2", "Slope 2x2"),
  Color = c("Yellow", "Black")
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
        .table { background-color: white; border-radius: 8px; border: 1px solid #154734; }
        .shiny-bound-output { font-size: 16px; }
        .well { background-color: #FFF; color: #154734; font-weight: thin }
        .btn-primary { background-color: #154734; border-color: #0D3B2E; }
        .btn-primary:hover { background-color: #0D3B2E; }
        .section-divider { border-top: 3px solid #154734; margin-top: 30px; margin-bottom: 30px;  }
      "))
  ),
  div(
    style = "padding: 20px;",
    div(
      style = "text-align: center;",
      titlePanel("Data Science Process: The ETV Framework"),
      p("The Extraction, Transformation, and Visualization (ETV) process is essential in data science to clean, analyze, and interpret data effectively.")
    ),
    
    br(), br(), br(),
    
    h2("Data Extraction"),
    p("Extracting data is the first step in the data science workflow. 
      Data can be sourced from websites, files, APIs, or databases. 
      Ensuring accurate and efficient data extraction is crucial for subsequent analysis and decision-making."),
    
    
    div(class = "section-divider"),
    h3("Web Scrapping and File Import"),
    tags$ul(
      tags$li(strong("Web Scraping (Wikipedia):"), " Extracting structured data from web pages."),
      tags$li(strong("File Import (CSV/Excel):"), " Reading datasets from locally stored files.")
    ),
    
    sidebarLayout(
      sidebarPanel(
        radioButtons("data_source", "Choose a Data Extraction Method:",
                     choices = c("Scrape Wikipedia Table", "Import CSV/Excel File"),
                     selected = "Scrape Wikipedia Table"),
        h4("R Code Used"),
        verbatimTextOutput("extraction_code")
      ),
      
      mainPanel(
        h4(strong("Extracted Data")),
        dataTableOutput("extracted_data"),
      )
    ),
    
    br(), br(), br(),
    
    h2("Data Transformation"),
    p("Once data is extracted, it often requires cleaning and structuring before analysis.
      Data transformation involves filtering, aggregating, and reshaping data to make it useful for visualization and modeling."),
    
    
    div(class = "section-divider"),
    h3("Common dplyr Functions"),
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
        verbatimTextOutput("dplyr_code")
      ),
      
      mainPanel(
        h4(strong("Example Dataset")),
        dataTableOutput("rap_music_original"),
        
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
        verbatimTextOutput("bind_code")
      ),
      
      mainPanel(
        h4(strong("Example Datasets")),
        uiOutput("dynamic_tables"),
        h4(strong("Bound Dataset")),
        dataTableOutput("bound_data"),
        br(),
        p(strong("Note:"), " If you are looking to merge datasets by columns with meaningful relationships, 
           you may want to use joins instead. Joins allow you to combine data based on common keys, 
           which is covered in the next section below."),
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
        h4("R Code Used"),
        verbatimTextOutput("join_code"),
        br(),
        h4("Explanation GIF"),
        uiOutput("join_gif")
      ),
      
      mainPanel(
        h4(strong("Example Datasets")),
        fluidRow(
          column(6, dataTableOutput("movies_1")),
          column(6, dataTableOutput("movies_2"))
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
        verbatimTextOutput("pivot_code"),
        br(),
        h4("Explanation GIF"),
        tags$img(src = "https://raw.githubusercontent.com/gadenbuie/tidyexplain/main/images/tidyr-pivoting.gif",
                 style = "max-height: 300px; width: auto; display: block; margin: auto;")
      ),
      
      mainPanel(
        h4(strong("Original Dataset")),
        conditionalPanel(
          condition = "input.pivot_choice == 'Pivot Sales Data (Wide → Long)'",
          dataTableOutput("sales_original")
        ),
        conditionalPanel(
          condition = "input.pivot_choice == 'Pivot Employee Shift Schedule (Long → Wide)'",
          dataTableOutput("shift_original")
        ),
        
        h4(strong("Transformed Dataset")),
        conditionalPanel(
          condition = "input.pivot_choice == 'Pivot Sales Data (Wide → Long)'",
          dataTableOutput("sales_transformed")
        ),
        conditionalPanel(
          condition = "input.pivot_choice == 'Pivot Employee Shift Schedule (Long → Wide)'",
          dataTableOutput("shift_transformed")
        )
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
        verbatimTextOutput("column_manip_code"),
      ),
      
      mainPanel(
        h4(strong("Example Dataset")),
        dataTableOutput("games_original"),
        
        h4(strong("Transformed Dataset")),
        dataTableOutput("games_transformed")
      )
    ),
    
    br(), br(), br(),
    
    h2("Data Visualiztion"),
    p("Data visualization is the process of representing data graphically to uncover insights and trends. Effective visualization enhances understanding and helps in decision-making by making complex information more accessible."),
    div(class = "section-divider"),
    
    br(), br(), br(),
    
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
        verbatimTextOutput("string_code")
      ),
      
      mainPanel(
        h4(strong("Original Dataset")),
        dataTableOutput("text_data_original"),
        
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
        verbatimTextOutput("factor_code")
      ),
      
      mainPanel(
        h4(strong("Original Dataset")),
        dataTableOutput("mtcars_original"),
        
        h4(strong("Transformed Dataset")),
        dataTableOutput("mtcars_transformed")
      )
    ),
    
    br(),br(),br(),
    
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
        verbatimTextOutput("iteration_code")
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
        # actionButton("run_purrr", "Run purrr Function"),
        h4("R Code Used"),
        verbatimTextOutput("purrr_code")
      ),
      
      mainPanel(
        h4(strong("Purrr Output")),
        verbatimTextOutput("purrr_output")
      )
    ),
    
    br(),br(),br(),
    
    h2("Statistics"),
    p("Statistical analysis is a crucial part of the ETV cycle, allowing for the transformation of raw data into meaningful insights. 
      Simulations and hypothesis testing provide methods for evaluating patterns and making data-driven decisions."),
    
    div(class = "section-divider"),
    h3("Simulation"),
    p("Simulation in statistics helps to model real-world scenarios by generating synthetic data. Here, we use `rbinom()` for binomial distributions and `rnorm()` for normal distributions."),
    
    sidebarLayout(
      sidebarPanel(
        # actionButton("run_simulation", "Generate Simulation Data"),
        h4("R Code Used"),
        verbatimTextOutput("simulation_code")
      ),
      
      mainPanel(
        h4(strong("Simulation Output")),
        dataTableOutput("simulation_output")
      )
    ),
    
    br(),br(),br(),
    
    h3("Statistical Analysis"),
    p("Statistical tests are essential for hypothesis testing and data analysis. Here, we apply two key tests: Linear Regression and ANOVA."),
    
    sidebarLayout(
      sidebarPanel(
        radioButtons("stat_test_choice", "Choose a Statistical Test:",
                     choices = c("Linear Regression", "ANOVA", "T-Test"),
                     selected = "Linear Regression"),
        h4("R Code Used"),
        verbatimTextOutput("stat_code")
      ),
      
      mainPanel(
        h4(strong("Statistical Test Output")),
        verbatimTextOutput("stat_output")
      )
    )
  )
)

server <- function(input, output) {
  
  extracted_wikipedia <- function() {
    url <- "https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_GDP"
    table <- htmltab::htmltab(doc = url, which = 1)
    return(table)
  }
  
  extracted_csv <- function() {
    return(read_csv("data.csv"))
  }
  
  extracted_excel <- function() {
    return(read_excel("data.xlsx"))
  }
  
  output$extracted_data <- renderDataTable({
    if (input$data_source == "Scrape Wikipedia Table") {
      extracted_wikipedia()
    } else {
      extracted_csv()
    }
  })
  
  output$extraction_code <- renderText({
    if (input$data_source == "Scrape Wikipedia Table") {
      "url <- \"https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_GDP\" \ndata <- htmltab::htmltab(doc = url, which = 1)\nprint(data)"
    } else {
      "data <- read_csv(\"data.csv\") \nprint(data)"
    }
  })
  
  output$rap_music_original <- renderDataTable({ rap_music })
  
  output$rap_music_transformed <- renderDataTable({
    switch(input$dplyr_choice,
           "Filter Songs" = rap_music %>% filter(Streams_Million > 800),
           "Select Columns" = rap_music %>% select(Artist, Song, Streams_Million),
           "Mutate Add Streams" = rap_music %>% mutate(Streams_Billion = Streams_Million / 1000),
           "Arrange by Popularity" = rap_music %>% arrange(desc(Streams_Million)),
           "Summarize Average Streams" = rap_music %>% summarize(Average_Streams = mean(Streams_Million))
    )
  })
  
  output$dplyr_code <- renderText({
    switch(input$dplyr_choice,
           "Filter Songs" = "mod_1_rap_music <- rap_music %>%\n\t filter(Streams_Million > 800)",
           "Select Columns" = "mod_1_rap_music <- rap_music %>%\n\t select(Artist, Song, Streams_Million)",
           "Mutate Add Streams" = "mod_1_rap_music <- rap_music %>%\n\t mutate(Streams_Billion = Streams_Million / 1000)",
           "Arrange by Popularity" = "mod_1_rap_music <- rap_music %>%\n\t arrange(desc(Streams_Million))",
           "Summarize Average Streams" = "mod_1_rap_music <- rap_music %>%\n\t summarize(Average_Streams = mean(Streams_Million))"
    )
  })
  
  output$lego_parts_1 <- renderDataTable({ lego_parts_1 })
  output$lego_parts_2 <- renderDataTable({ lego_parts_2 })
  output$lego_attributes <- renderDataTable({ lego_attributes })
  
  output$dynamic_tables <- renderUI({
    if (input$bind_choice == "Bind Rows") {
      fluidRow(
        column(6, div(style = "padding: 5px;", dataTableOutput("lego_parts_1"))),
        column(6, div(style = "padding: 5px;", dataTableOutput("lego_parts_2")))
      )
    } else {
      fluidRow(
        column(6, div(style = "padding: 5px;", dataTableOutput("lego_parts_1"))),
        column(6, div(style = "padding: 5px;", dataTableOutput("lego_attributes")))
      )
    }
  })
  
  output$bound_data <- renderDataTable({
    if (input$bind_choice == "Bind Rows") {
      bind_rows(lego_parts_1, lego_parts_2)
    } else {
      bind_cols(lego_parts_1, lego_attributes)
    }
  })
  
  output$bind_code <- renderText({
    if (input$bind_choice == "Bind Rows") {
      "mod_1_lego <- bind_rows(lego_parts_1, lego_parts_2)"
    } else {
      "mod_1_lego <- bind_cols(lego_parts_1, lego_attributes)"
    }
  })
  
  output$movies_1 <- renderDataTable({ movies_1 })
  output$movies_2 <- renderDataTable({ movies_2 })
  
  output$joined_data <- renderDataTable({
    switch(input$join_choice,
           "Inner Join" = inner_join(movies_1, movies_2, by = "MovieID"),
           "Left Join" = left_join(movies_1, movies_2, by = "MovieID"),
           "Right Join" = right_join(movies_1, movies_2, by = "MovieID"),
           "Full Join" = full_join(movies_1, movies_2, by = "MovieID"),
           "Semi Join" = semi_join(movies_1, movies_2, by = "MovieID"),
           "Anti Join" = anti_join(movies_1, movies_2, by = "MovieID")
    )
  })
  
  output$join_code <- renderText({
    switch(input$join_choice,
           "Inner Join" = "mod_movies <- inner_join(movies_1, movies_2, by = 'MovieID')",
           "Left Join" = "mod_movies <- left_join(movies_1, movies_2, by = 'MovieID')",
           "Right Join" = "mod_movies <- right_join(movies_1, movies_2, by = 'MovieID')",
           "Full Join" = "mod_movies <- full_join(movies_1, movies_2, by = 'MovieID')",
           "Semi Join" = "mod_movies <- semi_join(movies_1, movies_2, by = 'MovieID')",
           "Anti Join" = "mod_movies <- anti_join(movies_1, movies_2, by = 'MovieID')"
    )
  })
  
  output$join_gif <- renderUI({
    gif_links <- list(
      "Inner Join" = "https://github.com/gadenbuie/tidyexplain/raw/main/images/inner-join.gif",
      "Left Join" = "https://github.com/gadenbuie/tidyexplain/raw/main/images/left-join.gif",
      "Right Join" = "https://github.com/gadenbuie/tidyexplain/raw/main/images/right-join.gif",
      "Full Join" = "https://github.com/gadenbuie/tidyexplain/raw/main/images/full-join.gif",
      "Semi Join" = "https://github.com/gadenbuie/tidyexplain/raw/main/images/semi-join.gif",
      "Anti Join" = "https://github.com/gadenbuie/tidyexplain/raw/main/images/anti-join.gif"
    )
    tags$img(src = gif_links[[input$join_choice]], style = "max-height: 300px; width: auto; display: block; margin: auto;")
  })
  
  output$sales_original <- renderDataTable({
    sales_data
  })
  
  output$shift_original <- renderDataTable({
    shift_data
  })
  
  output$sales_transformed <- renderDataTable({
    sales_data %>%
      pivot_longer(cols = c(Sales_2021, Sales_2022),
                   names_to = "Year",
                   values_to = "Sales")
  })
  
  output$shift_transformed <- renderDataTable({
    shift_data %>%
      pivot_wider(names_from = Day, values_from = Shift)
  })
  
  output$pivot_code <- renderText({
    if (input$pivot_choice == "Pivot Sales Data (Wide → Long)") {
      "mod_1_sales_data <- sales_data %>%\n\t pivot_longer(cols = c(Sales_2021, Sales_2022), names_to = 'Year', values_to = 'Sales')"
    } else {
      "mod_1_shift_data <- shift_data %>%\n\t pivot_wider(names_from = Day, values_from = Shift)"
    }
  })
  
  output$games_original <- renderDataTable({ video_games })
  
  output$games_transformed <- renderDataTable({
    if (input$column_manip_choice == "Unite Game Title & Edition") {
      video_games %>%
        unite("Full_Title", Title, Edition, sep = " - ")
    } else {
      video_games %>%
        separate(Release_Date, into = c("Year", "Month", "Day"), sep = "-")
    }
  })
  
  output$column_manip_code <- renderText({
    if (input$column_manip_choice == "Unite Game Title & Edition") {
      "mod_1_video_games <- video_games %>%\n\t unite('Full_Title', Title, Edition, sep = ' - ')"
    } else {
      "mod_1_video_games <- video_games %>%\n\t separate(Release_Date, into = c('Year', 'Month', 'Day'), sep = '-')"
    }
  })
  
  output$text_data_original <- renderDataTable({ text_data })
  
  output$text_data_transformed <- renderDataTable({
    if (input$string_choice == "Detect Pattern") {
      text_data %>% mutate(Contains_Shiny = str_detect(Text, "Shiny"))
    } else {
      text_data %>% mutate(Modified_Text = str_replace(Text, "is", "was"))
    }
  })
  
  output$string_code <- renderText({
    if (input$string_choice == "Detect Pattern") {
      "mod_text_data <- text_data %>%\n\t mutate(Contains_Shiny = str_detect(Text, 'Shiny'))"
    } else {
      "mod_text_data <- text_data %>%\n\t mutate(Modified_Text = str_replace(Text, 'is', 'was'))"
    }
  })
  
  output$mtcars_original <- renderDataTable({ mtcars_factor })
  
  output$mtcars_transformed <- renderDataTable({
    if (input$factor_choice == "Reorder Cylinders") {
      mtcars_factor %>% mutate(cyl = fct_reorder(cyl, mpg, .fun = mean))
    } else {
      mtcars_factor %>% mutate(gear = fct_lump(gear, n = 2))
    }
  })
  
  output$factor_code <- renderText({
    if (input$factor_choice == "Reorder Cylinders") {
      "mod_mtcars <- mtcars_factor %>%\n\t mutate(cyl = fct_reorder(cyl, mpg, .fun = mean))"
    } else {
      "mod_mtcars <- mtcars_factor %>%\n\t mutate(gear = fct_lump(gear, n = 2))"
    }
  })
  
  output$iteration_code <- renderText({
    switch(input$iteration_choice,
           "For Loop" = "for(i in 1:5) { print(i^2) }",
           "While Loop" = "x <- 1\nwhile(x < 5) { print(x); x <- x + 1 }",
           "If/Else Statement" = "x <- 10\nif(x > 5) { print('Greater than 5') } else { print('Less than or equal to 5') }"
    )
  })
  
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
  
  output$purrr_code <- renderText({ "map(c(1, 2, 3, 4, 5), mean)" })
  
  output$purrr_output <- renderText({ paste(map(c(1, 2, 3, 4, 5), mean), collapse = ", ") })
  
  output$simulation_code <- renderText({ "data <- data.frame(Binomial = rbinom(10, 20, 0.5), Normal = rnorm(10, 50, 10))" })
  
  output$simulation_output <- renderDataTable({
    data.frame(Binomial = rbinom(10, 20, 0.5), Normal = rnorm(10, 50, 10))
  })
  
  output$stat_code <- renderText({
    switch(input$stat_test_choice,
           "Linear Regression" = "lm_model <- lm(mpg ~ hp, data = mtcars)\nsummary(lm_model)",
           "ANOVA" = "anova_model <- aov(mpg ~ cyl, data = mtcars)\nsummary(anova_model)",
           "T-Test" = "t.test(mpg ~ am, data = mtcars)"
    )
  })
  
  output$stat_output <- renderText({
    switch(input$stat_test_choice,
           "Linear Regression" = capture.output(summary(lm(mpg ~ hp, data = mtcars))),
           "ANOVA" = capture.output(summary(aov(mpg ~ cyl, data = mtcars))),
           "T-Test" = capture.output(t.test(mpg ~ am, data = mtcars))
    )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)