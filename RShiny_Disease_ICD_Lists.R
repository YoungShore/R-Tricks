### Shiny App ###

# install.packages("readxl")
# install.packages("data.table")
# install.packages(c("DT", "readxl", "shiny"))


########## read in ICD9-Disease list ###########


library(readxl) #<--needed for read in xlsx file
library(plyr)   #<--needed for rename function below
library(dplyr)  #<--needed for drop function
# library(data.table)

icd9s <- read_excel("C:/Users/Sean/OneDrive/OneNoteRefs/CodeBooks/ICD9s-2015.xlsx",col_types = "text")
#icd9s <- read_excel("/Users/YoungShore/Documents/OneDriveYoungShoreOutlook/OneDrive/OneNoteRefs/CodeBooks/ICD9s-2015.xlsx",col_types = "text")


icd9s <- cbind(Code_Type = 'ICD9',icd9s)
# names(icd9s)
names(icd9s)[2] <- "ICD_Level"
names(icd9s)[3] <- "ICD_List"

#not function very well: icd9s <- rename(icd9s,replace,c('ICD_Level'="ICD9_Level","ICD_List"="ICD9_List"))
icd9s <- select(icd9s,-c(Billable))

icd10s <- read_excel("C:/Users/Sean/OneDrive/OneNoteRefs/CodeBooks/ICD10s-2019.xlsx",col_types = "text")
#icd10s <- read_excel("/Users/YoungShore/Documents/OneDriveYoungShoreOutlook/OneDrive/OneNoteRefs/CodeBooks/ICD10s-2019.xlsx",col_types = "text")

icd10s <- cbind(Code_Type = 'ICD10',icd10s)
# names(icd10s)
names(icd10s)[2] <- "ICD_Level"
names(icd10s)[3] <- "ICD_List"


# pxs <-
# rxs <-

all_ICDs <- rbind(icd9s,icd10s) #,pxs,rxs)

diseaseNames <- colnames(all_ICDs)[5:ncol(all_ICDs)]
diseaseNames <- as.vector(diseaseNames)


########## build shiny app ############


# install.packages("shiny")
# install.packages("rsconnect") #<--this is for deploy apps to shinyapps.io
# install.packages("devtools")
# devtools::install_github("rstudio/shinyapps")
# install.packages("DT")

library(shiny)
library(DT)

### folw the teaching video step by step ###


ui <- fluidPage(
  
  # App title ---
  titlePanel("Disease Definitions"),
  
  # Create a new Row in the UI for selectInputs:
  fluidRow(
    column(4, selectInput("diseaseNames","Diseases",c("All",unique(as.character(diseaseNames))))),
    column(4, selectInput("Code_Type","Code Type",c("All",unique(as.character(all_ICDs$Code_Type)))))
  ),
  

  # write out selected codes:
  h4("Selected Codes List:"),
  verbatimTextOutput("subCateList"),
  hr(),
  
  # Create a new row for the table :
  DT:: dataTableOutput("table")
)


# Define Server ---

server <- function(input, output,session) {
  
  data <- all_ICDs
  
  # list selected disease codes:
  output$subCateList <- renderText({
    
    if (input$diseaseNames != "All" & input$Code_Type != "All") {
      data <- subset(data, !is.na(data[,input$diseaseNames]) ,c(input$diseaseNames,"Code_Type","ICD_List","Description"))
      data <- subset(data, Code_Type == input$Code_Type )
      paste(data$ICD_List, collapse=", ")
    }
    else if (input$diseaseNames != "All") {
      data <- subset(data,!is.na(data[,input$diseaseNames]) ,c(input$diseaseNames,"Code_Type","ICD_List","Description"))
      paste(data$ICD_List, collapse=", ")
    }
  })
  

  # Filter data based on selections
  output$table <- DT:: renderDataTable(DT::datatable({
    
    if (input$diseaseNames != "All") {
      data <- subset(data,!is.na(data[,input$diseaseNames]),c(input$diseaseNames,"Code_Type","ICD_List","Description"))
      # Rheumatoid_Arthritis
      #data <- data[data$Rheumatoid_Arthritis == "1" ,c(input$diseaseNames,"Code_Type","ICD_List","Description")]
    }
    
    if (input$Code_Type != "All" & input$diseaseNames != "All") {
      data <- data[data$Code_Type == input$Code_Type,c(input$diseaseNames,"Code_Type","ICD_List","Description")]
    }
    else if (input$Code_Type != "All" ) {
      data <- data[data$Code_Type == input$Code_Type,c("Code_Type","ICD_List","Description")]
    }
    
    data
  }))
  
}

# Create Shiny app ---

shinyApp(ui, server)
