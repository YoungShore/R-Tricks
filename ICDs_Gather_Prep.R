
# ICDs Gathering & Preparation for Disease Blocks

# readin raw ICDs from any available source, then transform to a '|' separated file, with ICDs quoted

# key packages needed: (if other packages needed as pre-exist packages for below ones, please install accordingly)
# install.packages("xlsx")
# install.packages("gtools")
# install.packages("googlesheets")

library(xlsx)
library(gtools)
library(googlesheets)


# ================================================================= #
#                           READ IN ICDS                            #
# ================================================================= #

# ---------------------------------------------------------------- #
#                           ICD-9 Part                             #
# ---------------------------------------------------------------- #

ICD9s <- read.xlsx("W:/onenote/references/Codebooks/ICD9 vs ICD10/ICD9s-2015.xlsx",sheetName="ICD9_2015",header=TRUE,colIndex = c(1,2,3,4))
# ICD9s <- ICD9s[,1:4] # in case orignal data were wrong added something and need to reset to original

# Renames as needed:
names(ICD9s) <- c("CodeLevel","Code","Billable","Description")

# Add ICD CodeTypes if not exist:

ICD9s <- cbind(ICD9s,CodeType='09')

# Create New Data to Avoid Changing Raw Read-in

ICD9s_Cl <- ICD9s

ICD9s_Cl$Code_ <- gsub('"','',ICD9s_Cl$Code) #<--remove unnecessary double quotes (") if read them in from raw as a content
#^--- create a 'Code_' variable is to remove the double quotes which were stubbornly used as part of the contents, so in following steps of searching for codes but no need of double quote


# ----------------------------------------------------------------- #
#                           ICD-10 Part                             #
# ----------------------------------------------------------------- #

ICD10s <- read.xlsx("W:/onenote/references/Codebooks/ICD9 vs ICD10/ICD10s-2019.xlsx",sheetName="Sheet1",header=TRUE,colIndex = c(1,2,3))
# ICD10s <- ICD10s[,1:3]

# Define ICD CodeTypes if not exist:
ICD10s$CodeType <- '10'

# add "Billable" variable even if not exist in raw data
ICD10s$Billable <- ''


# Renames as needed:
names(ICD10s) <- c("CodeLevel","Code","Description","CodeType","Billable")

# Create New Data to Avoid Changing Raw Read-in

ICD10s_Cl <- ICD10s

ICD10s_Cl$Code_ <- gsub('"','',ICD10s_Cl$Code) #<--remove unnecessary double quotes (") if read them in from raw as a content
#^--- create a 'Code_' variable is to remove the double quotes which were stubbornly used as part of the contents, so in following steps of searching for codes but no need of double quote


# --------------------------------------------------------------------------------------- #
#                   MACRO TO DEFINE DISEASE CLASS WITH GIVEN CODE LIST                    #
# --------------------------------------------------------------------------------------- #

Input_Disease_Definition <- defmacro(dst,codeVar,codeSys,diseaClas,diseaDef,
                                     expr = {
                                       attach(dst)
                                       diseaDefPul <- dst[ which( diseaDef ), ]
                                       dst$diseaClas <- ifelse(dst$codeVar %in% diseaDefPul$codeVar,'1','0')
                                       #detach(dst)
                                     }
                                     )
Input_Disease_Definition(ICD9s_Cl,Code_,ICD9,Hospital_Infection, ICD9s_Cl$Code_ %in% c("001","0010") )


Define_Disease_Class <- defmacro(dst,codeVar,codeType,diseaClas,codeList,
                                 expr = {
                                   dst$diseaClas <- ifelse(dst$codeVar %in% (codeList),'1','0')
                                 }
                                 )

# ----------------------------------------------------------------------- #
#                   RUN EACH DISEASE CLASS DEFINITIONS                    #
# ----------------------------------------------------------------------- #

Define_Disease_Class(ICD9s_Cl,Code_,ICD9,Hospital_Infection,c("001","0010"))
Define_Disease_Class(ICD9s_Cl,Code_,ICD9,Rheumatoid_Arthritis,c("7140","7142","71489"))


# -------------------------------------------------------------------- #
#                   Export table with '|' delimiter                    #
# -------------------------------------------------------------------- #


write.table(ICD9s, file="W:/onenote/references/Codebooks/ICD9 vs ICD10/ICD9s_2015.txt", sep="|", quote=FALSE, row.names=FALSE)

write.table(ICD10s, file="W:/onenote/references/Codebooks/ICD9 vs ICD10/ICD10s_2019.txt", sep="|", quote=FALSE, row.names=FALSE)



#################### OLD EXPERIMENTAL CODES ###################

#------------------ add Infection -----------------:

Code_Type <- 'ICD9s'                 #<--- assign code type, ICD9 or 10 or others like snomed, etc
Disease_Name <- 'Hospital_Infection' #<--- assign disease category as you interested


List_Name <- paste(Disease_Name,Code_Type,sep='_') #<---combine the disease_name & code_type to create a specific variable name for further assigning values into it.
#List_Name

assign(List_Name, c("001", "0010"))  #<--- assign the diagnosis or whatever code list here , need to separate them with commas
#Hospital_Infection_ICD9s

ICD9s_Cl$Hospital_Infection <- ifelse(ICD9s_Cl$Code_ %in% (eval(parse(text=List_Name))) ,'1','0')
#^--- the eval(parse(text=List_name)) part is converting the "Hospital_Infection_ICD9s" string to a variable name as Hospital_Infection_ICD9s


#################### END OF EXPERIMENTAL CODES #####################


###########################################################################
#                   ADD SHINY APP FOR CODES MANAGEMENT                    #
###########################################################################


