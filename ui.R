library(shiny)

ui <- fluidPage(
  titlePanel("Embargoed Items Filter"),
  
  sidebarLayout(
    sidebarPanel(
      downloadButton("download", "Download Filtered CSV")
    ),
    
    mainPanel(
      textOutput("dadjoke")
    )
  )
)
