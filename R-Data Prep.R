### different ways of data preparation

#1. create a small sample data for testing something:
### this method will create data in 'column' way, means you list content of each column then combine & convert them into a structured data

tst1 <- data.frame(id=c(1,2,3),dob=c("1/23/1981","12/3/1981","1/2/1981"))
### ^--this data have 2 columns, named 'id' & 'dob'; and have 3 rows like ID=1, 2, 3 separatedly while dob=1/23/1981, 12/3/1981, 1/2/1981 accordingly
### note that the date-like contents are actually recorded as characters, like a text string, you may need do convertion before starting using them for calculation like counting days between dates

tst2 <- data.frame(id=c(1,2,3),dob=c(as.Date("1981-1-23"),as.Date("1981-12-3"),as.Date("1981-1-2")))
### ^--this data are about the same as above one, except the dates are created into 'date format'
### note that the as.Date() convert a date-like record into date format so you can do calculation like count days difference


#2. use rbind() to create data by rows:
### this method will create data by 'rows', like write one row of records with all infor, then write another and append it after

tst3 <- do.call("rbind",list(row1=c(names("ID"),names("DOB")),row2=c(1,as.Date("1981-1-23")),row3=c(2,as.Date("1981-12-3"))))
tst3 <- do.call("rbind",list(c(1,as.Date("1981-1-23")),c(2,as.Date("1981-12-3"))))
names(tst3.data) <- c("ID","DOB")
