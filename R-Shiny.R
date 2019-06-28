### Shiny App ###

########## read in ICD9-Disease list ###########

# install.packages("readxl")

library(readxl)

icd9s <- read_excel("C:/Users/shuoyang/Documents/Personal/Codebooks/ICD9s-2015.xlsx")
icd9s <- read_excel("/Users/YoungShore/Documents/OneDriveYoungShoreOutlook/OneDrive/OneNoteRefs/CodeBooks/ICD9s-2015.xlsx")

icd10s <- read_excel("C:/Users/shuoyang/Documents/Personal/Codebooks/ICD10s-2019.xlsx")
icd10s <- read_excel("/Users/YoungShore/Documents/OneDriveYoungShoreOutlook/OneDrive/OneNoteRefs/CodeBooks/ICD10s-2019.xlsx")

# pxs <-
# rxs <-
all <- rbind(icd9s,icd10s,pxs,rxs)

########## build shiny app ############


# install.packages("shiny")
# install.packages("rsconnect") #<--this is for deploy apps to shinyapps.io
# install.packages("devtools")
# devtools::install_github("rstudio/shinyapps")

library(shiny)

# runExample("01_hello") #<--this is a quick testing of the output page

### folw the teaching video step by step ###

ui <- fluidPage(

  # App title ---

  titlePanel("Disease Definitions"),

  # Sidebar Layouts ---

  sidebarLayout(

    # Sidebar Panel for inputs ---

    SidebarPanel(

      # Input: Select Code Types:
      selectInput("codeType", "Choose Code Types:",
                  choices = c("ALL","DXs","PXs","RXs")),
      selectInput("codeDesc", "Description of Selected Codes:", ),
      helpText("Select interested Codes, separated by comma, then put in above box and submit."),
      actionButton("submit","Submit")

      ),

  # Main Panel for displaying outputs ---
  mainPanel(

    # Output codes list ---
    h4("Codes List:"),
    #???what function to put selected list of codes???
    verbatimTextOutput("codeList"),

    # Output: Header + table of distribution ---
    h4("Description of Selected Codes:"),
    tableOutput("view")
    )
  )
)


# Define Server ---

server <- function(input, output) {

  datasetInput <- eventReactive(input$submit,{
    switch(input$codeType,
           "ALL" = c(DXs,PXs,RXs),
           "DXs" = DXs,
           "PXs" = PXs,
           "RXs" = RXs )
  }, ignoreNULL = FALSE )

  # Generate a List of the descriptions ---
  output$codeList <- renderPrint({
    dataset <- datasetInput()
    head(datasetInput(), code = codeList)
  } )
}

# Create Shiny app ---

shinyApp(ui, server)
