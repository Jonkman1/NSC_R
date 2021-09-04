#
# NSC-R Workshop_03_Notes.R
# WB 2020-05-10
library(tidyverse)



######################################################
# Recapitulition: working with datasets/tibbles
######################################################

# Remember to load the 'tibble library' 
library(tibble)



# Create a dataset by hand containing month of year
mymonths <- tibble(ID = 1:12,
                   MonthName = c("Jan", "Feb", "Mar", "Apr",
                                 "May", "Jun", "Jul", "Aug",
                                 "Sep", "Oct", "Nov", "Dec"),
                   Temperature = c( 5, 7,10,12,15,17,
                                   22,20,17,14, 9, 6))

# print it
mymonths 
print(mymonths)
### A tibble: 12 x 3
## ID MonthName Temperature
## <int> <chr>           <dbl>
## 1     1 Jan                 5
## 2     2 Feb                 7
## 3     3 Mar                10
## 4     4 Apr                12
## 5     5 May                15
## 6     6 Jun                17
## 7     7 Jul                22
## 8     8 Aug                20
## 9     9 Sep                17
## 10    10 Oct               14
## 11    11 Nov                9
## 12    12 Dec                6

# Intermezzo: Why is this structure (rectangular dataset) called a tibble?

View(mymonths)       # Speadsheet-type viewer

names(mymonths)      # See column names
## [1] "ID"          "MonthName"   "Temperature"

glimpse(mymonths)    # See names, types and parts of contents
## Rows: 12
## Columns: 3
## $ ID          <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
## $ MonthName   <chr> "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", ...
## $ Temperature <dbl> 5, 7, 10, 12, 15, 17, 22, 20, 17, 14, 9, 6

str(mymonths)       # old version of glimpse that you may encouter
## tibble [12 x 3] (S3: tbl_df/tbl/data.frame)
## $ ID         : int [1:12] 1 2 3 4 5 6 7 8 9 10 ...
## $ MonthName  : chr [1:12] "Jan" "Feb" "Mar" "Apr" ...
## $ Temperature: num [1:12] 5 7 10 12 15 17 22 20 17 14 ...

ncol(mymonths)       # number of columns (variables)
## [1] 3

nrow(mymonths)       # number of rows (obserations=cases)
## [1] 12

dim(mymonths)        # number of rows and number of columns
## [1] 12  3


######################################################
# Accessing elements of a tibble
######################################################

# Access elements of a tibble works like accessing
#   elements f a vector, but in two dimensions 
#   (first row number, then column number)

mymonths[1, ] # first row
## # A tibble: 1 x 3
## ID MonthName Temperature
## <int> <chr>           <dbl>
##   1     1 Jan                 5

mymonths[, 2] # second column (position)
## # A tibble: 12 x 1
## MonthName
## <chr>    
## 1 Jan      
## 2 Feb      
## 3 Mar      
## 4 Apr      
## 5 May      
## 6 Jun      
## 7 Jul      
## 8 Aug      
## 9 Sep      
## 10 Oct      
## 11 Nov      
## 12 Dec 


mymonths[1:4, ] # first 4 months (rows)
## # A tibble: 4 x 3
## ID MonthName Temperature
## <int> <chr>           <dbl>
## 1     1 Jan                 5
## 2     2 Feb                 7
## 3     3 Mar                10
## 4     4 Apr                12

# Note that "1:x" is shorthand for "c(1,2, ... x)"
#   compare:
mymonths[c(1,2,3,4), ]
## # A tibble: 4 x 3
## ID MonthName Temperature
## <int> <chr>           <dbl>
## 1     1 Jan                 5
## 2     2 Feb                 7
## 3     3 Mar                10
## 4     4 Apr                12

mymonths[, c("MonthName")] # access column by name
## # A tibble: 12 x 1
## MonthName
## <chr>    
## 1 Jan      
## 2 Feb      
## 3 Mar      
## 4 Apr      
## 5 May      
## 6 Jun      
## 7 Jul      
## 8 Aug      
## 9 Sep      
## 10 Oct      
## 11 Nov      
## 12 Dec 

mymonths[, c("MonthName", "Temperature")] # access multiple columns by name
## # A tibble: 12 x 2
## MonthName Temperature
## <chr>           <dbl>
## 1 Jan                 5
## 2 Feb                 7
## 3 Mar                10
## 4 Apr                12
## 5 May                15
## 6 Jun                17
## 7 Jul                22
## 8 Aug                20
## 9 Sep                17
## 10 Oct               14
## 11 Nov                9
## 12 Dec                6

# Note that all these examples return a (subset of the) tibble/dateframe
#   which is also a tibble/dataframe (even if it has only a single column
#   and/or row)
#   tibble/dataframe:

class(mymonths)
## [1] "tbl_df"     "tbl"        "data.frame"

class(mymonths[, c("Temperature")])
## [1] "tbl_df"     "tbl"        "data.frame"

class(mymonths[1,1]
## [1] "tbl_df"     "tbl"        "data.frame"
 
# To extract a column from a tibble/dataframe, yu can use the "$" operator
mymonths$MonthName
## [1] "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"

mymonths$Temperature
## [1]  5  7 10 12 15 17 22 20 17 14  9  6

# What if yu have an object which IS a data table but is not a tibble?

MyFriends <- c("Molly", "Jake", "Carlton", "Eve", "Meriam")
class(MyFriends)
MyFriendsTbl <- as_tibble(MyFriends, name="FirstName")
MyFriendsTbl
## # A tibble: 5 x 1
## value  
## <chr>  
## 1 Molly  
## 2 Jake   
## 3 Carlton
## 4 Eve    
## 5 Meriam     

###########################################################
# Reading external data into R
###########################################################

###########################################################
# Excel files (XLSX and XLS)
###########################################################

# Install and load the readxl package
#install.packages("readxl")
library(readxl)

# The readxl package provide three main functions
# read_xls()     read XLS files
# read_xlsx()    raed XLSX files
# read_excel()   read either XLS or XLSX files

# Make sure you adapt to path to where the MyClub.xlsx file is
MyClubTibble <- read_xlsx(path="G:/R/R-NSCR/Meeting_03/MyClub.xlsx")
MyClubTibble
## # A tibble: 8 x 4
## Name       Age Member Date               
## <chr>    <dbl>  <dbl> <dttm>             
## 1 Collin      25      1 2019-08-19 00:00:00
## 2 Mary        27      1 2019-07-22 00:00:00
## 3 Tom         32      1 2020-01-05 00:00:00
## 4 Randy       24      0 2020-02-01 00:00:00
## 5 Olivia      30      1 2019-04-15 00:00:00
## 6 Morris      41      1 2018-09-10 00:00:00
## 7 Patricia    23      1 2019-06-07 00:00:00
## 8 Patrick     24      1 2018-02-01 00:00:00

# Note the next line will not work because it uses backslashes ("\")
#MyClubTibbleError <- read_xlsx(path="G:\R\R-NSCR\Meeting_03\MyClub.xlsx")

# Using doube backslashes will make it work
MyClubTibble <- read_xlsx(path="G:\\R\\R-NSCR\\Meeting_03\\MyClub.xlsx")
MyClubTibble
# Advice: always use forward slashes ("/")
#   Not sure how this translates to Mac systems

# View contents (note that R has correctly copied the special date format)
View(MyClubTibble)
glimpse(MyClubTibble)
## Rows: 8
## Columns: 4
## $ Name   <chr> "Collin", "Mary", "Tom", "Randy", "Olivia", "Morris", "Patric...
## $ Age    <dbl> 25, 27, 32, 24, 30, 41, 23, 24
## $ Member <dbl> 1, 1, 1, 0, 1, 1, 1, 1
## $ Date   <dttm> 2019-08-19, 2019-07-22, 2020-01-05, 2020-02-01, 2019-04-15, ...

# If your Excel file contans multiple worksheets, you can (and must) 
#   assign each worksheet to a separate tibble
Parents <- read_xlsx(path="G:/R/R-NSCR/Meeting_03/MyClubKids.xlsx",
                     sheet="Parents")
Parents
## # A tibble: 8 x 4
## Name       Age Member Date               
## <chr>    <dbl>  <dbl> <dttm>             
## 1 Collin      25      1 2019-08-19 00:00:00
## 2 Mary        27      1 2019-07-22 00:00:00
## 3 Tom         32      1 2020-01-05 00:00:00
## 4 Randy       24      0 2020-02-01 00:00:00
## 5 Olivia      30      1 2019-04-15 00:00:00
## 6 Morris      41      1 2018-09-10 00:00:00
## 7 Patricia    23      1 2019-06-07 00:00:00
## 8 Patrick     24      1 2018-02-01 00:00:00

Kids    <- read_xlsx(path="G:/R/R-NSCR/Meeting_03/MyClubKids.xlsx",
                     sheet="Kids")
Kids
## # A tibble: 7 x 2
## Name      Age
## <chr>   <dbl>
## 1 Kevin       6
## 2 Wail       12
## 3 Kural       3
## 4 Christa    12
## 5 Sheila      5
## 6 Yo-Ming     2
## 7 Candy       7

KidsNames    <- read_xlsx(path="G:/R/R-NSCR/Meeting_03/MyClubKids.xlsx",
                     range="Kids!A1:A8")
KidsNames
## # A tibble: 7 x 1
## Name   
## <chr>  
## 1 Kevin  
## 2 Wail   
## 3 Kural  
## 4 Christa
## 5 Sheila 
## 6 Yo-Ming
## 7 Candy

################################################
# Reading Stata (*.dta) and SPSS (*.sav) files
################################################

# Install and load the haven package
#install.packages("haven")
library(haven)

# Stata
LowBirth <- read_dta("G:/R/R-NSCR/Meeting_03/lowbirth2.dta")
LowBirth
## # A tibble: 112 x 9
## pairid   low   age   lwt smoke   ptd    ht    ui      race
## <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl+lbl>
## 1      1     0    14   135     0     0     0     0 1 [white]
## 2      1     1    14   101     1     1     0     0 3 [other]
## 3      2     0    15    98     0     0     0     0 2 [black]
## 4      2     1    15   115     0     0     0     1 3 [other]
## 5      3     0    16    95     0     0     0     0 3 [other]
## 6      3     1    16   130     0     0     0     0 3 [other]
## 7      4     0    17   103     0     0     0     0 3 [other]
## 8      4     1    17   130     1     1     0     1 3 [other]
## 9      5     0    17   122     1     0     0     0 1 [white]
## 10     5     1    17   110     1     0     0     0 1 [white]
## # ... with 102 more rows


#SPSS
Iris <- read_sav("G:/R/R-NSCR/Meeting_03/iris.sav")
View(Iris)

################################################
# Reading .CSV files (comma-separated values)
################################################

# with basic R: 
#   use function "read.csv" (read DOT csv)
# Data downloaded on April 28, 2020 from:
# https://raw.githubusercontent.com/eparker12/nCoV_tracker/master/input_data/coronavirus.csv
Corona_1 <- read.csv("G:/R/R-NSCR/Meeting_02/CoronaVirus.csv")

# You can actually directly read it from internet (if you have access)
Corona_1a <- read.csv("https://raw.githubusercontent.com/eparker12/nCoV_tracker/master/input_data/coronavirus.csv")

# With package readr (more options and quicker processing): 
#   use function "read_csv" (read UNDERSCORE csv)
# Install and load readr package
#install.packages("readr")
library(readr)
# Data downloaded on April 28, 2020 from:
# https://raw.githubusercontent.com/eparker12/nCoV_tracker/master/input_data/coronavirus.csv
Corona_2 <- read_csv("G:/R/R-NSCR/Meeting_03/CoronaVirus.csv")



# Since Version 4.0.0., the is no difference (apart from speed)
class(Corona_1$jhu_ID)
class(Corona_2$jhu_ID)
 
# The variable jhu_ID (John Hopkins University ID) is an quoted string
#   in the CSV file. On pre 4.0.0. version of R, read.csv automatically 
#   converts it to a 'factor',
#   while read_csv does not. To prevent read.csv to to this:
Corona_1 <- read.csv("G:/R/R-NSCR/Meeting_03/CoronaVirus.csv", as.is=TRUE)
class(Corona_1$jhu_ID)

################################################
# Writing .CSV files (comma-separated values)
################################################
write_csv(Iris, "G:/R/R-NSCR/Meeting_03/Iris.csv")
write_csv(LowBirth, "G:/R/R-NSCR/Meeting_03/lowbirth2.csv")

################################################
# Writing .SAV and .DTA files (SPSS and Stata)
################################################
write_dta(Kids, "G:/R/R-NSCR/Meeting_03/Kids.dta", version=12)
write_sav(LowBirth,"G:/R/R-NSCR/Meeting_03/lowbirth2.sav")

