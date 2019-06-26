### Shiny App ###

# install.packages("shiny")
# install.packages("rsconnect") #<--this is for deploy apps to shinyapps.io

library(shiny)

runExample("01_hello") #<--this is a quick testing of the output page

### folw the teaching video step by step ###

ui <- fluidPage(
  sliderInput(inputId = "codeTyp",
              label = "Choose the CodeType You Need",
              value = 25, min = 1, max = 100),
            plotOutput("codeList")
)

server <- function(input, output) {
  output$codeList <- renderPlot({
    title <- "100 random normal values"
    hist(rnorm(100),main=title)
  })
  #output$codList <- renderText({
  #
  #})
}

shinyApp(ui = ui, server = server)

