#######################################################
# PREVENTING REPETITIVE CODING
#######################################################

# TODAY
# - rep() and seq() 
# - introduction to functions
# - writing functions
# - Franziska demonstration
# - ??? other demonstrations / questions
# NEXT MEETINGS 
# - Tuesday July 7 about visualization (graphs) 
# - Tuesday July 21 about regression modeling (OLS, GLM, ...)
# NEXT WORKSHOP STARTS SEPTEMBER AND WILL HAVE
#   - SPECIAL TOPICS 
#   - INVITED EXPERT PRESENTERS (MIGHT BE FROM NSCR)
#

#######################################################
# PREVENTING REPETITIVE CODING
#######################################################

# libraries needed for these examples
library(tidyverse)  ## contains purrr, tidyr, dplyr
library(broom)      ## converts test output to tidy tables

# clean workspace
rm(list=ls())
#############################################################
# Functions
#############################################################
# Almost everything in R is a function, e.g.
# c(), seq(), rep(), filter(), read_xlsx() ..........

# Most functions need 'arguments' (between the brackets)
#  in left_join(Students, Grades, "StudentNo")
#  we join tibble/dataframe 'Students'  with tibble/dataframe 'Grades'
#     based on the values of the common variable "StudentNo"
#  R knows what to do because we provide the arguments in the right 
#     order
# if we typed left_join("StudentNo", Students, Grades)
#   R would return an error message
# and if we typed left_join(Grades, Students, "StudentNo")
#   it would not issue an error but return something different
#   than we intended

# If you provide the arguments by name (which you can always do) you
#   make it explicit and do not depend on the order
# left_join(x=Students, y=Grades, by="StudentNo")

# left_join is the NAME of the function
# x, y and by are its ARGUMENTS (there are actually a few more arguments)

# Some but not all function arguments have default values
#    (typically the most common, logical of safe options)
# BELOW WE WILL SEE WHAT seq() ACTUALLY DOES
seq(1,9)            # by order
seq(from=1, to=9)   # by name
# there is a third argument, 'by', that automatically gets value 1 
#   if it is not included
seq(1,9,1)
seq(from=1, to=9, by=1)
seq(1,9,2)
seq(from=1, to=9, by=2)


# Today we consider the rep() function

####################
# rep() function
####################
rep(2, 3) # repeat number '2' three times
## [1] 2 2 2

rep("Yes", 3) # repeat word "Yes" three times
## [1] "Yes" "Yes" "Yes"

# This does not save much typing, but the next line does
rep(7, 20)
# equals c(7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7)
## [1] 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7


# The first argument can itself be a vector, e.g.
Years <- c(2004, 2005, 2006)
Years
## [1] 2004 2005 2006
rep(Years, 2)
## [1] 2004 2005 2006 2004 2005 2006

# NOTE that rep(2,3) is shorthand notation for rep(x=2, times=3)
# If you make 'x' and 'times' explicit, order does not matter:
rep(x=2, times=3)
## [1] 2 2 2
rep(times=3, x=2)
## [1] 2 2 2


# Special:
# If the second argument is a vector that is the same length 
# as the first argument, each element in the first vector is 
# repeated than many times. 
# Use rep() to create a vector of 11 "A" values followed by 3 "B" values

rep(c("A", "B"), c(11, 3))
##  [1] "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "B" "B" "B"


#################
# seq()
#################

#############################################################
# rep() is about copies, seq() is about regular sequences
#   of numbers like 1,2,3,4,5,6 ... 
#############################################################
# seq(from, to, by) from=start to=end by=step

seq(1,5,1)
seq(3,5,1)
seq(1,5,2)
seq(1,6,2) # Thus: the end value might not be included!
seq(-5,5,1)
seq(0,-5,-1)
seq(0,10)  # If you exclude the last argument, it defaults to 1

#############################################################
# If you just want an index on an object, use seq_along
#############################################################
MyStudents <- c("Carlos", "Linda", "Daniel", "Niki", "Tamara", "Ben")
StudentNo <- seq_along(MyStudents)
StudentNo
# shorthand for 
seq(1, length(MyStudents), 1)

# by order and by name
seq(0,10,2)
seq(from=0, to=10, by=2)

# you are not restrictded to integers (whole numbers)
seq(from=0, to=1, by=.1)
##  [1] 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0

# set number rather than size of steps 
seq(from=0, to=100, length.out = 5)
## [1]   0  25  50  75 100

# set number rather than size of steps (8 intervals + 1)
seq(from=0, to=100, length.out = 9)
## [1]   0.0  12.5  25.0  37.5  50.0  62.5  75.0  87.5 100.0




#################################################
# Functions
#################################################

# Question 5 from Formative Exercise 7.
# Write a function called my_add that adds two numbers ( x and y )                 
# together and returns the results
my_add <- function(x, y) {
  x+y
}
my_add(10,5)

# A function always returns something: its value is
#  1. what you type between brackets in 'return()', or
#  2. the result f the last command, e,g 'x + y'

# What starts in a function, stays in a function.

my_mult <- function(x, y) {
  mytext <- "Result:"
  print(mytext)
  x * y
}  
my_mult(10,5)
## [1] "Result:"
## [1] 50
mytext
## Error: object 'mytext' not found


# Let us automate something simple: calculating descriptives of a variable
# This the dataset
my_data_set <- tibble(
  id      = c( 1, 2, 3, 4, 5, 6, 7, 8, 9,10),
  female  = c( 0, 1, 1, 1, 0, 1, 0, 0,NA, 1),
  age     = c(11,12,12,13,13,15,16,16,NA,14),
  item1   = c( 2, 3, 4, 3, 6, 7, 6, 5, 7, 7),
  item2   = c( 1, 4, 4, 3, 5, 5, 4, 6, 7, 6),
)
my_data_set

# Here we define a function
# The function name = "descriptives"
# It takes one argument with no default value
# It returns a tibble with 5 descriptive stats
descriptives <- function(my_variable) {
  tbl <- tibble(mean    = mean(my_variable),
                stdev   = sd(my_variable),
                median  = median(my_variable),
                minimum = min(my_variable),
                maximum = max(my_variable)
  )
  return(tbl)
}


descriptives(my_data_set$item1)
descriptives(my_data_set$item2)
descriptives(my_data_set$age)
#oeps

# note that missing values destroys mean()
mean(my_data_set$age)
mean(my_data_set$age, na.rm=TRUE)

# here is a mechanism to pass arguments to functions that are
#   called (=used) within you functions, such as mean() and median()

descriptives2 <- function(my_variable, ...) {
  tbl <- tibble(mean    = mean(my_variable, ...),
                stdev   = sd(my_variable, ...),
                median  = median(my_variable, ...),
                minimum = min(my_variable, ...),
                maximum = max(my_variable, ...)
  )
  return(tbl)
}

# descriptives3 is like desxcriptives2, but changes the default of
#   na.rm=FALSE, to na.rm=TRUE, so that it removes missings if
#   you do nt specify the na.rm argument
descriptives3 <- function(my_variable, na.rm=TRUE) {
  descriptives2(my_variable, na.rm=na.rm)
}
descriptives3(my_data_set$age)
## # A tibble: 1 x 5
## mean stdev median minimum maximum
## <dbl> <dbl>  <dbl>   <dbl>   <dbl>
##   1  13.6  1.81     13      11      16
descriptives3(my_data_set$age, na.rm=TRUE)
## # A tibble: 1 x 5
## mean stdev median minimum maximum
## <dbl> <dbl>  <dbl>   <dbl>   <dbl>
##   1  13.6  1.81     13      11      16
descriptives3(my_data_set$age, na.rm=FALSE)
## # A tibble: 1 x 5
## mean stdev median minimum maximum
## <dbl> <dbl>  <dbl>   <dbl>   <dbl>
##   1    NA    NA     NA      NA      NA


descriptives2(my_data_set$age)
# but
descriptives2(my_data_set$age, na.rm=TRUE)

# all variables in my_data_set
# (This is advanced R)
apply(my_data_set, MARGIN=2, FUN=descriptives3)
