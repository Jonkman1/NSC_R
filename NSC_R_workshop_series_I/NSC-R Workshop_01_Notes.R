# Data Skills for Reproducible Science
# https://psyteachr.github.io/msc-data-skills/intro.html

# Typing commands in the R Studio concole (bottom left window)
Note that on a line in the editor, anything after # is automagically green
# and treated as comment, not code (like '*' in Stata and SPSS)

rm(list=ls())

1 + 1

1 + 2 + 3

1 +
  2

# Strings
"Good morning"

# Single quotes can be used as well, but not prefered
'Good Morning'

#Use single quotes if the string must cntain double quotes, or
#  vice versa
"'Good morning', she said"
'"Good morning", he replied'
#the command cat prints to the screen whatever is between brackets
cat("'Good morning', she said")
cat('"Good morning", he replied')

# variables
# we start with variables that represent just one number
#   (you may think of an SPSSS or Stata variable in a dataset with N=1)


## use the assignment operator '<-'
## R stores the number in the variable 'variable1'
variable1 <- 5
variable1
# alternatively (seldom very useful)
assign("variable2", 7)  # note the variable name is between quotes hre
variable2

# we can use the variable in subsequent calculations 
variable1 * variable2
# and assign the result to another variable
variable3 <- variable1 + variable2
# just as in SPSS, you can overwrite the original value
variable1 <- variable1 * variable2

# A variable does not need to be a single number, it can be a vector
#   like our variables in Stata and SPSS

myvariable <- c(2,3,5,7,11,13)
myvariable



# just as in Stata or SPSS, assignment of values to variables is static
# example from the online course:
this_year <- 2019
my_birth_year <- 1976
my_age <- this_year - my_birth_year
this_year <- 2020
# your age is not updated automatically!

# Look at the upper right panel ('Global Environment'
#

# functions
# almost everything is R works with functions. hey are small programs that you
# feed with something and that return something else. 

# three numbers go in (the functionarguments), 
#   10 come out (the value of the function)
rnorm(n=10, mean=0, sd=1)

# you often use a function in a function. sum() is also a function

sum(rnorm(n=10, mean=0, sd=1))

# Getting help is easy for beginners, but understanding it is not
#   always easy
# 
help("rnorm")
?rnorm

# The power of R is in the packages
#   there are hundreds of them, for specific tasks
#   it can be overwhelming, esp. if multiple packages offer similar
#   possibilities (i.e. inter-rater reliability assessment)

# By commandline
install.packages("ggExtra")
# Via menu 
# Tools-Install packages

# load package (one per session, typically at the top of yur script/syntax)
library(ggExtra)


# read section 1.6.1 carefully. It is about how to organize your script
