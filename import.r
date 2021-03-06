### import a CSV file : ###
### remember if need to include folder path, then need to change '\' signs to '/' in the path line ###

csvExample <- read.csv(file="C:/Users/shuoyang/Documents/R/data/csv-example.csv",head=TRUE,sep=',')

### ^^^above file was originally in "C:\Users\shuoyang\Documents\R\data", and need to change '\' to '/' ###

### import an Excel file(xlsx or xls): ###

install.packages("readxl")
library(readxl)

icd9s <- read_excel("C:/Users/shuoyang/Documents/Personal/Codebooks/ICD9-2015.xlsx")

