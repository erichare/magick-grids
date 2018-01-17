library(shiny)
library(shinythemes)
library(magick)

# Test comment
ui <- fluidPage(theme = shinytheme("cerulean"),
   
   titlePanel("Magick Images"),
   
   sidebarLayout(
      sidebarPanel(
          h4("About"),
          
          HTML("This application provides a front-end to the <a href='https://cran.r-project.org/package=magick'>magick</a> package for manipulating images. Several pieces of functionality are supported, and the resulting image can be downloaded."),
          
          hr(),
          
          h4("Image"),
          fileInput("image", "Upload Image", accept = c("image/gif", "image/jpeg", "image/png", "image/tiff")),
          
          hr(),
          
          h4("Configuration")
      ),
      
      mainPanel(
      )
   )
)

server <- function(input, output) {

}

shinyApp(ui = ui, server = server)
