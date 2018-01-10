library(shiny)
library(shinythemes)
library(magick)

ui <- fluidPage(theme = shinytheme("cerulean"),
   
   titlePanel("Magick Grids"),
   
   sidebarLayout(
      sidebarPanel(
          h4("About")
      ),
      
      mainPanel(
      )
   )
)

server <- function(input, output) {

}

shinyApp(ui = ui, server = server)
