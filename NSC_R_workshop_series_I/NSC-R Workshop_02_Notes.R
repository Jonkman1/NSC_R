######################################################
# Note:
# On April 24, 2020 a major update of R was launched
#    (version 4.0.0). This may have caused the 
#    problems I experienced near the end of the second
#    meeting.workshop
# I now installed version 4.0.0
######################################################
install.packages("haven")    # read SPSS & Stata files
install.packages("readxl")   # read Excel files
install.packages("readr")    # read csv files
install.packages("tibble")   # improved data frames

library(haven)
library(readxl)
library(readr)
library(tibble)

######################################################
# BASIC DATA TYPES (= elementary R objects)
######################################################

# create a double-precision number
dbl_var <- 2.5  
dbl_var
## [1] 2.5

# create an integer (the L says: no decimals)
int_var <- 6L
int_var
## [1] 6

# This is also OK, but it creates a double-precision number:
num_var <- 6
num_var
## [1] 6

# create a string (alphanumerical) 
str_var <- "New York"
str_var
## [1] "New York"

# create a boolean (true versus false)
bool_var <- TRUE
bool_var


######################################################
# To identify the basic type of a variable, use the
#    typeof() function
######################################################
typeof(dbl_var)
## [1] "double"

typeof(int_var)
## [1] "integer"

typeof(num_var)
## [1] "double"

typeof(str_var)
## [1] "character"

typeof(bool_var)
## [1] "logical"

######################################################
# Convert from one type to another
######################################################

# double > string
as.character(dbl_var)
## [1] "2.5"

# integer > string
as.character(int_var)
## [1] "6"

# boolean > string
as.character(bool_var)
## [1] "TRUE"

# boolean > numeric  (FALSE become 0, TRUE becomes 1)
as.integer(bool_var)

# string > numeric  (missing value (Because "New York" is not a number), 
#    but .....)
as.numeric(str_var)
## [1] NA

# .... if the string contains a number like 17.4, it converts OK.
str_var <- "17.4"
as.numeric(str_var)
## [1] 17.4

######################################################
# Warning: you can use T and F as abbreviations for
#    TRUE and FALSE, but beware ...
######################################################

# Create variable named T with value 2
T <- 2
T
## [1] 2

# Create boolean named MyAim with value FALSE
MyAim <- F
MyAim
## [1] FALSE

# Change it to TRUE
MyAim <- T
MyAim
## [1] 2

# Oeps, this was not intended.
# Cause: R first checks whether there is a variable called "T". Only if
#   it does not exists will it read "T"as a shortcut for "TRUE#

######################################################
# BASIC CONTAINER TYPES
######################################################
# booleans, doubles, integers and strings are elementary
#   data types. They are structured into çontainer types.
# A very common one is the vector, which is an ordered
#   list of elements of the same type

# Vector of numbers (doubles/integers)
myfirstvector <- c(2,3,5)
myfirstvector
## [1] 2 3 5

# Vector of strings
myfirststringvector <- c("Jonathan", "Kimberly", "Mary", "Tom")
myfirststringvector
## [1] "Jonathan" "Kimberly" "Mary"     "Tom"

# Vector of booleans
myfirstbooleanvector <- c(TRUE, FALSE, FALSE, TRUE)
myfirstbooleanvector
## [1]  TRUE FALSE FALSE  TRUE


# mixing things up leads to forced conversion
#  (usually not what you want)
# Here R converts numbers, strings and booleans to strings:
mixedfeelings <- c(7, 14.5, "Kate", FALSE)
mixedfeelings
## [1] "7"     "14.5"  "Kate"  "FALSE"
typeof(mixedfeelings)
## [1] "character"


######################################################
# Intended type conversion
#   (Sometimes you need to)
######################################################
myquotedvector <- as.character(c(3.4, 7.1, 5.5))
myquotedvector
##[1] "3.4" "7.1" "5.5"

mytruthvector1 <- as.character(c(TRUE, FALSE, TRUE))
mytruthvector1
## [1] "TRUE"  "FALSE" "TRUE"

mytruthvector2 <- as.integer(c(TRUE, FALSE, TRUE))
mytruthvector2 
## [1] 1 0 1

# Vectors can have any length greater than 0
mytinyvector <- c(2)
mytinyvector
## [1] 2
mylargevector <- c(5,2,6,3,4,8,9,1,3,3,3,2,7,6,8,9,0,2,3,1,1,1,4,3)
mylargevector
##  [1] 5 2 6 3 4 8 9 1 3 3 3 2 7 6 8 9 0 2 3 1 1 1 4 3

# you can substitute vectors into vectors:
myset1 <- c(5,10,15)
myset1
myset2 <- c(22,44,33)
myset2

combiset <- c(myset1, myset2)
combiset
## [1]  5 10 15 22 44 33

repeatset <- c(myset1, myset1, myset1)
repeatset
## [1]  5 10 15  5 10 15  5 10 15

######################################################
# Indexing: selecting values from a vector
######################################################

# The example from the course  mey skip to many steps:
word <- c(18, 19, 20, 21, 4, 9, 15)
LETTERS[word]

# Let's do it slowly

# Use square brackets [] to select one or more values from a vector

# Here is a vector of 5 numbers
myvector <- c(400, 200, 700, 500, 100)
myvector
## [1] 400 200 700 500 100

# Access the first element
myvector[1]
## [1] 400

# Now what is the third element?
myvector[3]
## [1] 700


# What are the first two elements?
#   !! we use another vector c(1,3) to get them
myvector[c(1,3)]
## [1] 400 700

# myvector[] is just the same as myvector
myvector[]
## [1] 400 200 700 500 100

# it also works with strings
MyABC <- c("A", "B", "C", "D")
MyABC
## [1] "A" "B" "C" "D"

MyABC[c(2,1,4)]
##[1] "B" "A" "D"

# the vector named LETTERS is built into R, so ...
LETTERS
##  [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S"
## [20] "T" "U" "V" "W" "X" "Y" "Z"

LETTERS[c(1,2,3)]
## [1] "A" "B" "C"

LETTERS[c(23,9,13)]
## [1] "W" "I" "M"

LETTERS[c(18, 19, 20, 21, 4, 9, 15)]
## [1] "R" "S" "T" "U" "D" "I" "O"

# We could also first create the indexing vector and name it "word"
word <- c(18, 19, 20, 21, 4, 9, 15)
# and subsequently used it with LETTERS
LETTERS[word]
## [1] "R" "S" "T" "U" "D" "I" "O"


# In 'named' vectors, vector elements have names
myvector <- c(first = 77.9, second = -13.2, third = 100.1)
myvector
## first second  third 
##  77.9  -13.2  100.1 

# You can access elements by name using a character vector rather than number
myvector[c("third", "second")]
## third second 
## 100.1  -13.2 
myvector[c(3,2)]
## third second 
## 100.1  -13.2 

#what are the names in a vector?
names(myvector)

# Set the names of vector elements seperately

# Instead of 
myvector <- c(first = 77.9, second = -13.2, third = 100.1)
# you can also first assign the numbers
myvector <- c(77.9, -13.2, 100.1)
myvector
## [1]  77.9 -13.2 100.1
names(myvector) <- c("first", "second", "third")
myvector
## first second  third 
## 77.9  -13.2  100.1 


# How long is my vector (you may often use this)
length(myvector)
## [1] 3


# Creating vectors without typing them: "rep()" function  (=repeat)
rep(0, 10)                       # ten zeroes
rep(c(1, 3), times = 7)          # alternating 1 and 3, 7 times
rep(c("A", "B", "C"), each = 2)  # A to C, 2 times each
rep(c("A", "B", "C"), times = 2) # A to C, 2 times eac

# Creating vectors without typing them: "seq()" function  (=sequence)

seq(from = -1, to = 1, by = 0.2)   # constrain stepsize, R calculates length
## [1] -1.0 -0.8 -0.6 -0.4 -0.2  0.0  0.2  0.4  0.6  0.8  1.0

seq(0, 100, length.out = 11)       # contrain length, R calculates stepsize
## [1]   0  10  20  30  40  50  60  70  80  90 100

seq(0, 100, length.out = 5)
## [1]   0  25  50  75 100
seq(0, 100, length.out = 6)
## [1]   0  20  40  60  80 100
seq(0, 100, length.out = 7)
## [1]   0.00000  16.66667  33.33333  50.00000  66.66667  83.33333 100.00000


## Vectorized Operations

# Remember that R is also a calculator
2 * 5
## [1] 10

# We can also use R as a calculatr on vectors
mysecondvector <- c(1,2,3,4,5)
mysecondvector
## [1] 1 2 3 4 5
2 * mysecondvector
## [1]  2  4  6  8 10

# R multiplied every element of the vector by 2
# thus:

2 + mysecondvector
##[1] 3 4 5 6 7

2 / mysecondvector
## [1] 2.0000000 1.0000000 0.6666667 0.5000000 0.4000000

mysecondvector / 2
## [1] 0.5 1.0 1.5 2.0 2.5

## Course example
## example IQ scores: mu = 100, sigma = 15 IN POPULATION
iq <- c(86, 101, 127, 99)
iq
## [1]  86 101 127  99

iq - 100
## [1] -14   1  27  -1

(iq - 100) / 15
## [1] -0.93333333  0.06666667  1.80000000 -0.06666667


# Note that this is not the same as standizing the vector values
# To do this, you would use the mean() and sd() functions on the
#  iq vector

mean(iq)
# the mean in our sample is 103.25, not 100
## [1] 103.25

sd(iq)
# the standard deviation in our sample = 17.17314, not 15
## [1] 17.17314

(iq - mean(iq)) / sd(iq)
## [1] -1.0044757 -0.1310186  1.3829738 -0.2474795


######################################################
# Data as you know it : tibbles (data frames)
######################################################

# install and load the tibble package
install.packages("tibble")
library(tibble)

# Create a dataset cotaining month of year
mymonths <- tibble(ID = 1:12,
                 name = c("Jan", "Feb", "Mar", "Apr",
                          "May", "Jun", "Jul", "Aug",
                          "Sep", "Oct", "Nov", "Dec"))

# print it
mymonths
print(mymonths)
### A tibble: 12 x 2
##ID name 
##<int> <chr>
## 1     1 Jan  
## 2     2 Feb  
## 3     3 Mar  
## 4     4 Apr  
## 5     5 May  
## 6     6 Jun  
## 7     7 Jul  
## 8     8 Aug  
## 9     9 Sep  
##10    10 Oct  
##11    11 Nov  
##12    12 Dec

View(mymonths)       # Speadsheet-type viewer
glimpse(mymonths)    # See names, types and parts of contents
ncol(mymonths)       # number of columns (variables)
nrow(mymonths)       # number of rows (obserations=cases)

######################################################
# Accessing elements of a tibble
######################################################

# Access elements of a tibble works like accessing
#   elements f a vector, but in two dimensions 
#   (first row number, then column number)

mymonths[1, ] # first row

mymonths[, 2] # second column (position)

mymonths[1:4, ] # first 4 months
# Note that 1:x is shorthand for c(1,2, ... x), see
mymonths[c(1,2,3,4), ]

mymonths[, c("name")] # access column by name
mymonths[, c("ID", "name")] # access multiple columns by name


###########################################################
# Reading external data into R
###########################################################

###########################################################
# Excel files (XLSX and XLS)
###########################################################

# Install and load the readxl package
install.packages("readxl")
library(readxl)

# The readxl package provide three main functions
# read_xls()     read XLS files
# read_xlsx()    raed XLSX files
# read_excel()   read either XLS or XLSX files

# Make sure you adapt to path to where the MyClub.xlsx file is
MyClubTibble <- read_xlsx(path="G:/R/R-NSCR/Meeting_02/MyClub.xlsx")

# Note the next line will not work because it uses backslashes ("\")
MyClubTibbleError <- read_xlsx(path="G:\R\R-NSCR\Meeting_02\MyClub.xlsx")

# Using doube backslashes will make it work
MyClubTibble <- read_xlsx(path="G:\\R\\R-NSCR\\Meeting_02\\MyClub.xlsx")

# Advice: always use forward slashes ("/")
#   Not sure how this translates to Mac systems

# View contents (note that R has correctly copied the special date format)
View(MyClubTibble)
glimpse(MyClubTibble)
Rows: 8
Columns: 4
## $ Name   <chr> "Collin", "Mary", "Tom", "Randy", "Olivia", "Morris", "Patric...
## $ Age    <dbl> 25, 27, 32, 24, 30, 41, 23, 24
## $ Member <dbl> 1, 1, 1, 0, 1, 1, 1, 1
## $ Date   <dttm> 2019-08-19, 2019-07-22, 2020-01-05, 2020-02-01, 2019-04-15, ...

# If your Excel file contans multiple worksheets, you can (and must) 
#   assign each worksheet to a separate tibble
Parents <- read_xlsx(path="G:/R/R-NSCR/Meeting_02/MyClubKids.xlsx",
                     sheet="Parents")
Kids    <- read_xlsx(path="G:/R/R-NSCR/Meeting_02/MyClubKids.xlsx",
                     sheet="Kids")

################################################
# Reading Stata (*.dta) and SPSS (*.sav) files
################################################

# Install and load the haven package
install.packages("haven")
library(haven)

# Stata
LowBirth <- read_dta("G:/R/R-NSCR/Meeting_02/lowbirth2.dta")

#SPSS
Iris <- read_sav("G:/R/R-NSCR/Meeting_02/iris.sav")
 
View(Iris)

################################################
# Reading .CSV files (comma-separated values)
################################################

# with basic R: 
#   use function "read.csv" (read DOT csv)
# Data downloaded on April 28, 2020 from:
# https://raw.githubusercontent.com/eparker12/nCoV_tracker/master/input_data/coronavirus.csv
Corona_1 <- read.csv("G:/R/R-NSCR/Meeting_02/CoronaVirus.csv")

# With package readr (more options and quicker processing): 
#   use function "read_csv" (read UNDERSCORE csv)
# Install and load readr package
install.packages("readr")
library(readr)
# Data downloaded on April 28, 2020 from:
# https://raw.githubusercontent.com/eparker12/nCoV_tracker/master/input_data/coronavirus.csv
Corona_2 <- read_csv("G:/R/R-NSCR/Meeting_02/CoronaVirus.csv")





# The most important difference (apart from speed on large datasets)
class(Corona_1$jhu_ID)
class(Corona_2$jhu_ID)

# The variable jhu_ID (John Hopkins University ID) is an quoted string
#   in the CSV file. read.csv automatically converts it to a 'factor',
#   while read_csv does not. To prevet read.csv to to this:
Corona_1 <- read.csv("G:/R/R-NSCR/Meeting_02/CoronaVirus.csv", as.is=TRUE)
class(Corona_1$jhu_ID)

