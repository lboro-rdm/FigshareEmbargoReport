library(shiny)
library(tidyverse)
library(janitor)

server <- function(input, output, session) {
  
  # ---- Read CSV directly ----
  data_in <- reactive({
    read_csv("batch.csv", show_col_types = FALSE) %>%
      clean_names()
  })
  
  # ---- Filter for embargoed + publication_date in the past ----
  filtered <- reactive({
    df <- data_in()
    
    df %>%
      mutate(publication_date = as_date(publication_date)) %>%
      filter(
        is_embargoed == 1,
        publication_date <= today()
      )
  })
  
  # ---- Dad joke instead of preview ----
  output$dadjoke <- renderText({
    jokes <- c(
      "I’m reading a book about anti-gravity. It’s impossible to put down.",
      "Why don’t skeletons fight each other? They don’t have the guts.",
      "I used to be addicted to the hokey pokey… but I turned myself around.",
      "Why can’t you trust stairs? They’re always up to something.",
      "What do you call fake spaghetti? An impasta."
    )
    sample(jokes, 1)
  })
  
  # ---- Download handler ----
  output$download <- downloadHandler(
    filename = function() {
      paste0("filtered_embargoed_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write_csv(filtered(), file)
    }
  )
}
