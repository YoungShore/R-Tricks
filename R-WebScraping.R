# install.packages('rvest')
# install.packages('xlsx')

library('rvest')
library('xlsx')

url_0 <- 'http://www.icd10data.com/ICD10CM/Codes'

pag_0 <- read_html(url_0)

pag_html_0 <- html_nodes(pag_0,'.body-content li , .identifier')
pag_data_0 <- html_text(pag_html_0)
pag_data_0 <- gsub("\r\n ","",pag_data_0)
pag_data_0 <- trimws(pag_data_0)
#list(pag_data_0)

list_num_0 <- unique(substr(pag_data_0,1,7))
list_num_0 <- list_num_0[1:21]
# list_num_0 #<--contains 1-21 LVL1 list

list_num_1 <- unique(substr(pag_data_0,1,7))
list_num_1 <- list_num_1[22:length(list_num_1)]
# list_num_1 #<--contains A-Z LVL2 list

# lvl1 <- 'A00-B99'
# lvl2 <- 'A00-A09'

for (lvl1 in list_num_0)
{
  for (lvl2 in list_num_1)
  {
    url_2 <- paste(url_0,lvl1,lvl2,sep='/') 			# url_2
    pag_2 <- read_html(url_2)
    pag_html_2 <- html_nodes(pag_2,'.i51 .identifier')
    list_num_2 <- html_text(pag_html_2) 			# list_num_2

    # lvl3 <- 'A00'
    for (lvl3 in list_num_2)
    {
      url_3 <- paste(url_2,lvl3,sep='/')
      url_3_ <- paste0(url_3,'-')				# url_3_
      pag_3 <- read_html(url_3_)

      pag_html_3_num <- html_nodes(pag_3,'.codeLine .identifier')
      list_num_3 <- html_text(pag_html_3_num)		# list_num_3

      # lvl4 <- 'A00.0'
      for (lvl4 in list_num_3)
      {
        url_4 <- paste(url_3_,lvl4,sep='/')		# url_4
        pag_4 <- read_html(url_4)
        list_num_4 <- lvl4

        # ------- get billable info ---------

        pag_html_4_bil <- html_nodes(pag_4,'#badgeList')
        list_txt_4_bil <- strsplit(unique(html_text(pag_html_4_bil)),split='/')[[1]][1]
        list_txt_4_bil_ <- strsplit(list_txt_4_bil,split=' ')[[1]] # <-this [[1]] is needed to define results as 1 row
        billable <- list_txt_4_bil_[length(list_txt_4_bil_)]

        pag_html_4_desc <- html_nodes(pag_4,'.codeDescription')
        list_txt_4 <- html_text(pag_html_4_desc);

      }
    }
  }
}

# --------- output with data structure ---------

icd10.data <- data.frame(list_num_4,billable,list_txt_4)
write.xlsx(icd10.data,"W:/onenote/references/Codebooks/ICD9 vs ICD10/ICD10_List.xlsx",row.names=F)





#	url_3 <- paste0("'http://www.icd10data.com/ICD10CM/Codes/",lvl1,"/",lvl2,"'")
