### create shiny page ### 

library(shiny)

ui <- fluidPage(
  sliderInput(inputId = "codeList",
              label = "Code List",
              value = 25, min = 1, max = 100),
  #textOutput("")
  plotOutput("hist")
)

server <- function (input, output) {}

shinyApp(ui = ui , server = server)

