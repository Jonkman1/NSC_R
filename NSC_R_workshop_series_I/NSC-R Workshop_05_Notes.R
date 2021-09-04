# copied from Data Skills for reproducible Science

# subject has id, sex and age for subjects 1-5. 
# Age and sex are missing for subject 3
subject <- tibble(
  id = seq(1,5),                      # seq(1,5) is short for c(1,2,3,4,5)
  sex = c("m", "m", NA, "f", "f"),
  age = c(19 , 22 , NA, 19 , 18)      # NA means "missing value"
)   
glimpse(subject)
subject
# 
# has subject id and the score from an experiment. Some subjects are missing, some completed twice, 
#   and some are not in the subject table
exp <- tibble(
  id =    c( 2,  3,  4,  4, 5,  5,  6,  6, 7),
  score = c(10, 18, 21, 23, 9, 11, 11, 12, 3)
)
exp
#
#****_join(x, y, by = NULL, suffix = c(".x", ".y")
#     
#   YOU ALWAYS JOIN TWO TABLES (BUT MAY JOIN THE RESULT WITH A THIRD)
#   
#   x = the first (left) table
#   y = the second (right) table
#   {#join-by} by = what columns to match on. If you leave this blank, 
#      it will match on all columns with the same names in the two tables.
#   {#join-suffix} suffix = if columns have the same name in the two tables, 
#      but you aren't joining by them, they get a suffix to make them unambiguous. This defaults to ".x" and ".y", but you can change it to something more meaningful.
#              

# You can leave out the by argument if you're matching on all of
#    the columns with the same name, but you better be explicit
#    and ALWAYS SPECIFY "BY"
left_join(subject, exp, by = "id")
## # A tibble: 7 x 4
##      id sex     age score
##   <dbl> <chr> <dbl> <dbl>
## 1     1 m        19    NA
## 2     2 m        22    10
## 3     3 <NA>     NA    18
## 4     4 f        19    21
## 5     4 f        19    23
## 6     5 f        18     9
## 7     5 f        18    11

# NOTE: You include all row of the 5 persons who are in 'subjects', 
#       but exclude the experimental scores of persons 6 and 7
#       who are not in 'subjects' 

# REVERSE exp AND subject
left_join(exp, subject, by = c("fid"="sid")

left_join(exp, subject, by = c("fid"="id")

## # A tibble: 9 x 4
##      id score sex     age
##   <dbl> <dbl> <chr> <dbl>
## 1     2    10 m        22
## 2     3    18 <NA>     NA
## 3     4    21 f        19
## 4     4    23 f        19
## 5     5     9 f        18
## 6     5    11 f        18
## 7     6    11 <NA>     NA
## 8     6    12 <NA>     NA
## 9     7     3 <NA>     NA

# NOTE: You include all scores of the persons in 'exp', 
#       but excluding person 1 in 'subjects' who has no experimental scores

right_join(subject, exp, by = "id")
## # A tibble: 9 x 4
##      id sex     age score
##   <dbl> <chr> <dbl> <dbl>
## 1     2 m        22    10
## 2     3 <NA>     NA    18
## 3     4 f        19    21
## 4     4 f        19    23
## 5     5 f        18     9
## 6     5 f        18    11
## 7     6 <NA>     NA    11
## 8     6 <NA>     NA    12
## 9     7 <NA>     NA     3

#  right_join(subject, exp, by="id")      IS THE SAME AS
#  left_join(exp, subject, exp, by="id")  (EXCEPT FOR VARIABLE ORDER)

inner_join(subject, exp, by = "id")
## # A tibble: 6 x 4
##      id sex     age score
##   <dbl> <chr> <dbl> <dbl>
## 1     2 m        22    10
## 2     3 <NA>     NA    18
## 3     4 f        19    21
## 4     4 f        19    23
## 5     5 f        18     9
## 6     5 f        18    11

# NOTE: Only include experiments for persons in the 'subject' data and
#         only incude persons who have test scores in the 'exp' data
# I.E.  Only include if 'id' is in both 'subject' and 'exp'

full_join(subject, exp, by = "id")
# OUTPUT NOT SHOWN

# Note: Keep everything, and assign 'NA' (not applicable = missing value) to
#       variables for the records that have no match 

semi_join(subject, exp, by = "id")
## # A tibble: 4 x 3
##      id sex     age
##   <int> <chr> <dbl>
## 1     2 m        22
## 2     3 <NA>     NA
## 3     4 f        19
## 4     5 f        18

# NOTE: A semi_join returns rows from the left table where there is
#       at least one matching values in the right table, 
#       keeping just columns from the left table

anti_join(subject, exp, by = "id")
## # A tibble: 1 x 3
##      id sex     age
##   <int> <chr> <dbl>
## 1     1 m        19

# A anti_join does the oppositie, it returns all rows from the left table 
#    where there are no matching values in the right table, 
#    (keeping just columns from the left table).

# WHY WOULD YOU NEED THIS?
#
# Example: Give me the gender distribution of the subjects that 
#   participated in the experiments
subject$sex
# [1] "m" "m" NA  "f" "f"

# includes person 1 who did not participate, but this is correct
semi_join(subject, exp)$sex

# bind_rows is to stack identically-structured data on top of each other
#   (Stata: append)
bind_rows(subject, exp)
