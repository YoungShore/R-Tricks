### Shiny App ###

########## read in ICD9-Disease list ###########

# install.packages("readxl")

library(readxl) #<--needed for read in xlsx file
library(plyr)   #<--needed for rename function below
library(dplyr)  #<--needed for drop function

icd9s <- read_excel("C:/Users/shuoyang/Documents/Personal/Codebooks/ICD9s-2015.xlsx")
<<<<<<< HEAD
icd9s <- cbind(Code_Type = 'ICD9',icd9s)
names(icd9s)
names(icd9s)[2] <- "ICD_Level"
names(icd9s)[3] <- "ICD_List"

#not function very well: icd9s <- rename(icd9s,replace,c('ICD_Level'="ICD9_Level","ICD_List"="ICD9_List"))
icd9s <- select(icd9s,-c(billable))

icd10s <- read_excel("C:/Users/shuoyang/Documents/Personal/Codebooks/ICD10s-2019.xlsx")
icd10s <- cbind(Code_Type = 'ICD10',icd10s)
names(icd10s)
names(icd10s)[2] <- "ICD_Level"
names(icd10s)[3] <- "ICD_List"

# not function very well: icd10s <- rename(icd10s,replace=c("ICD10_Level"="ICD_Level","ICD10_List"="ICD_List"))

=======
icd9s <- read_excel("/Users/YoungShore/Documents/OneDriveYoungShoreOutlook/OneDrive/OneNoteRefs/CodeBooks/ICD9s-2015.xlsx")

icd10s <- read_excel("C:/Users/shuoyang/Documents/Personal/Codebooks/ICD10s-2019.xlsx")
icd10s <- read_excel("/Users/YoungShore/Documents/OneDriveYoungShoreOutlook/OneDrive/OneNoteRefs/CodeBooks/ICD10s-2019.xlsx")
>>>>>>> b46519ddb8a953e4b36f8944c282a0ca27a26bfd

# pxs <-
# rxs <-
all_ICDs <- rbind(icd9s,icd10s) #,pxs,rxs)

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
      selectInput("all_ICDs", "Choose Code Types:",
                  choices = c("ALL","ICD9","ICD10")),
      selectInput("Description", "Description of Selected Codes:", ),
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
