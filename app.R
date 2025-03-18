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
    p("Data can come from various sources. Here, we demonstrate two common extraction methods:"),
    
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
    p("dplyr provides a set of intuitive functions to manipulate and analyze data effectively."),
    
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
}

# Run the application 
shinyApp(ui = ui, server = server)
