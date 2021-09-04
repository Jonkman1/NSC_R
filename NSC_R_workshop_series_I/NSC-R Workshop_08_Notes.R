# NSC-R Workshop #8 Notes
# Regression modeling in R
# R version 4.0.0
# WB July 20, 2020

# These are the libaries that you need for the functions
#   in this script

library(tidyverse)
library(broom)     # tidy, augment and glance
library(car)       # vif (variance inflation factors)
library(MASS)      # negative binomial regression model

# Here is a (fictive) tiny dataset on juvenile delinquency
#   (age, gender, number of crimes)
mydata <- tibble(
  age   = c( 14, 14, 14, 14, 14, 14, 15, 15, 15, 16,   
             16, 16, 16, 17, 17, 17, 17, 18, 18, 18),
  sex   = c( "F","M","F","M","F","M","F","F","M","M",
             "F","M","F","M","M","F","F","F","M","M"),
  crime = c(  0,  1,  0,  0,  2,  4,  0,  3,  6,  5,
              3,  8,  6,  9,  7,  0,  1,  2,  1,  4)
)
# Display dataset
mydata
## # A tibble: 20 x 3
##  age   sex      crime
## <dbl> <chr>     <dbl>
##   1    14 F         0
##   2    14 M         1
##   3    14 F         0
##   4    14 M         0
##   5    14 F         2
##   6    14 M         4
##   7    15 F         0
##   8    15 F         3
##   9    15 M         6
##   10    16 M         5
##   11    16 F         3
##   12    16 M         8
##   13    16 F         6
##   14    17 M         9
##   15    17 M         7
##   16    17 F         0
##   17    17 F         1
##   18    18 F         2
##   19    18 M         1
##   20    18 M         4

# Let us first look at the age-crime relationship using a scatterplot
ggplot(data=mydata, mapping=aes(x=age, y=crime)) +
  geom_point() 


# The general setup for an OLS model estimation function is:
#
# RESULT <- lm(EQUATION, DATA, ...)
#   where
#   RESULT = the objct in which all results (estimates, standard errors, R2)
#            are stored
#   FORMULA = DEPVAR ~ INDEPVARS   (the regression equation)
#     where DEPVAR is the dependent (Y) variables and 
#           DEPVARS are the independent (X) variables (X1 + X2 + X3 ...)
#   DATA     = tibble (dataframe) where the data are stored
my_linearmodel_1 <- lm(formula = crime ~ age, 
                       data=mydata)
# If you just type the name of the results, you get very little. 
# Just an echo of the function call, the names of the X variables 
# and their estimated unstandardized coefficients :

my_linearmodel_1
## Call:
##   lm(formula = crime ~ age, data = mydata)
## 
## Coefficients:
##   (Intercept)          age  
## -5.7653       0.5629  

# Beware, the is a lot more in 'my_linearmodel_1' than this
#  Look here:
str(my_linearmodel_1)
## (output not shown, WB) 

# To get more details, we often use summary()
#   This gives us coefficients, standard errors, T values, and p values.
#   In addition, it provides descriptives of the residuals, and summary
#   statstics of the model (such as R squared)
summary(my_linearmodel_1)

## Call:
##   lm(formula = crime ~ age, data = mydata)
## 
## Residuals:
##   Min      1Q  Median      3Q     Max 
## -3.8036 -2.1778 -0.3036  2.1036  5.1964 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)
## (Intercept)  -5.7653     6.9849  -0.825    0.420
## age           0.5629     0.4416   1.275    0.219
## 
## Residual standard error: 2.854 on 18 degrees of freedom
## Multiple R-squared:  0.08278,	Adjusted R-squared:  0.03182 
## F-statistic: 1.624 on 1 and 18 DF,  p-value: 0.2187


# Looking a the scatterplot once more, and trying to graph the relationship
#   with a 'smoother', we suspect a curvilinear (inverse U-shaped) relation
ggplot(data=mydata, mapping=aes(x=age, y=crime)) +
  geom_point() +
  geom_smooth()

# Maybe we should model the age-relation in a more flexible way, creating
#   dummy indicators for age categories 15,16,17 and 18, with age 14 as the
#   reference category.
# An easy way to achive this is by telling R that it should treat 'age' as
#   a categorical (=nominal) variable. 
# (a factor is a special type of vector/variable in R that we have not
# discussed in the NSC-R workshop)

# Note that I store the results of this model in a new object
#   called 'my-linearmodel_2'
my_linearmodel_2 <- lm(formula= crime ~ as.factor(age), data=mydata)
summary(my_linearmodel_2)

## Call:
##   lm(formula = crime ~ as.factor(age), data = mydata)
## 
## Residuals:
##   Min     1Q Median     3Q    Max 
## -4.250 -1.208 -0.250  1.875  4.750 
## 
## Coefficients:
##                    Estimate Std. Error t value Pr(>|t|)  
## (Intercept)         1.167      1.092   1.069   0.3021  
## as.factor(age)15    1.833      1.891   0.970   0.3476  
## as.factor(age)16    4.333      1.726   2.511   0.0240 *
## as.factor(age)17    3.083      1.726   1.786   0.0943 .
## as.factor(age)18    1.167      1.891   0.617   0.5465  
## ---
##   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.674 on 15 degrees of freedom
## Multiple R-squared:  0.3288,	Adjusted R-squared:  0.1499 
## F-statistic: 1.837 on 4 and 15 DF,  p-value: 0.1742



# Include us sex as a second variable
# Let us first do the scatterplot for for boys (M) and girls (F) 
#    separately in the same graph.
# It appears girls commit less crime
ggplot(data=mydata, mapping=aes(x=age, y=crime, color=sex)) +
  geom_point()

# Here is how we specify the model (note the "+" between the X variables)
my_linearmodel_3 <- lm(formula= crime ~ age + sex, 
                       data=mydata)
summary(my_linearmodel_3)

# Note how R indicates a string variable (variable name + value)

## Call:
##   lm(formula = crime ~ age + sex, data = mydata)
## 
## Residuals:
##   Min      1Q  Median      3Q     Max 
## -4.4814 -1.4350 -0.2168  1.6654  4.1131 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)  
## (Intercept)  -5.5901     6.2715  -0.891   0.3852  
## age           0.4673     0.3987   1.172   0.2573  
## sexM          2.6598     1.1520   2.309   0.0338 *
##   ---
##   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.562 on 17 degrees of freedom
## Multiple R-squared:  0.3017,	Adjusted R-squared:  0.2196 
## F-statistic: 3.673 on 2 and 17 DF,  p-value: 0.04722


# Interactions (main effects + interaction)
my_linearmodel_4 <- lm(formula= crime ~ age + sex + age:sex , data=mydata)
summary(my_linearmodel_4)
## Call:
##   lm(formula = crime ~ age + sex + age:sex, data = mydata)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -4.8297 -1.6150  0.0553  1.5433  4.1957 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)
## (Intercept)  -2.3696     9.5789  -0.247    0.808
## age           0.2609     0.6117   0.426    0.675
## sexM         -3.1981    12.9791  -0.246    0.809
## age:sexM      0.3723     0.8215   0.453    0.656
## 
## Residual standard error: 2.624 on 16 degrees of freedom
## Multiple R-squared:  0.3106,	Adjusted R-squared:  0.1813 
## F-statistic: 2.403 on 3 and 16 DF,  p-value: 0.1056

# A shorter notation is as follows:
#  (* means: include vars on the left, vars on the right, and their
#            interactions)
my_linearmodel_5 <- lm(formula= crime ~  age*sex , data=mydata)
summary(my_linearmodel_5)
# (output omitted)

# How to access the model results?
#   (other than by printing them on screen)
summary(my_linearmodel_1)
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)
## (Intercept)  -5.7653     6.9849  -0.825    0.420
## age           0.5629     0.4416   1.275    0.219
## 
## (...)

# the coefficients() functions returns the mdel coefficients (estimates)
coefficients(my_linearmodel_1) 
## (Intercept)         age 
##  -5.7652695   0.5628743 

# the confint() function return the confidence intervals around the
#   coefficients (by default 95%, but you can change it)
confint(my_linearmodel_1, level=0.95) 
##                    2.5 %   97.5 %
##  (Intercept) -20.4400589  8.909520
##  age          -0.3649626  1.490711
confint(my_linearmodel_1, level=0.90) 
##                       5 %     95 %
##   (Intercept) -17.8775791  6.347040
##   age          -0.2029458  1.328694

# For some, you need to know a bit more of the model
#   (standard error is square root of variance, and 
#    variance is on diaginal of the variance-covariance
#    matrix, remember :-)
# standard errors:
sqrt(diag(vcov(my_linearmodel_1)))
## (Intercept)         age 
##   6.9849281   0.4416332 

# The predicted values for every point in the data
fitted(my_linearmodel_1) 
## 1        2        3        4        5        6        7        8 
## 2.114970 2.114970 2.114970 2.114970 2.114970 2.114970 2.677844 2.677844 
## 9       10       11       12       13       14       15       16 
## 2.677844 3.240719 3.240719 3.240719 3.240719 3.803593 3.803593 3.803593 
## 17       18       19       20 
## 3.803593 4.366467 4.366467 4.366467 

# or like this (vector into tibble)
tibble(predictions = fitted(my_linearmodel_1))

# The residuals for every point in the data
residuals(my_linearmodel_1) 
## 1          2          3          4          5          6          7 
## -2.1149701 -1.1149701 -2.1149701 -2.1149701 -0.1149701  1.8850299 -2.6778443 
## 8          9         10         11         12         13         14 
## 0.3221557  3.3221557  1.7592814 -0.2407186  4.7592814  2.7592814  5.1964072 
## 15         16         17         18         19         20 
## 3.1964072 -3.8035928 -2.8035928 -2.3664671 -3.3664671 -0.3664671 


# BROOM PACKAGE (tidy your regression results)
#   The broom package contain three functions 
#   (note N = nr of cases, K = number of variables including the constant)
# (1) tidy()   returns results per variable (a K-row tibble)  
# (2) augment() returns results per case (a N-row tibble)
# (3) glance() returns results per model (a 1-row tibble)

# NOTE: I am often confused between glimpse() and glance(). In the English
#     language they are more related than in the R language

# tidy() function organizes common regression output 
#         (estimate, se, T-value, p-value) in a tibble
# In other words: the regression table in your paper
tidy_mylinearmodel_3 <- tidy(x=my_linearmodel_3)
tidy_mylinearmodel_3
## # A tibble: 3 x 5
## term        estimate std.error statistic p.value
## <chr>          <dbl>     <dbl>     <dbl>   <dbl>
## 1 (Intercept)   -5.59      6.27     -0.891  0.385 
## 2 age            0.467     0.399     1.17   0.257 
## 3 sexM           2.66      1.15      2.31   0.0338

# You may want to add a 90% confidence interval:
tidy_mylinearmodel_3CI <- tidy(x=my_linearmodel_3,
                                      conf.int=TRUE, conf.level=.90)
tidy_mylinearmodel_3CI
## # A tibble: 3 x 7
## term        estimate std.error statistic p.value conf.low conf.high
## <chr>          <dbl>     <dbl>     <dbl>   <dbl>    <dbl>     <dbl>
## 1 (Intercept)   -5.59      6.27     -0.891  0.385   -16.5        5.32
## 2 age            0.467     0.399     1.17   0.257    -0.226      1.16
## 3 sexM           2.66      1.15      2.31   0.0338    0.656      4.66

# augment() adds model-baseed information about each case to the dataset
#   typically, you will be interested in predicted (fitted) values and in
#   residuals. augment() will provide these in ".fitted"  and ".resid" 
#   respectively. It will also aoutput five other variables, including 
#   sigma and Cook's distance
# 
aug_mydata_linearmodel_1 <- augment(x=my_linearmodel_1,
                                data=mydata)
aug_mydata_linearmodel_1
## # A tibble: 20 x 10
## age sex   crime .fitted .se.fit .resid   .hat .sigma  .cooksd .std.resid
## <dbl> <chr> <dbl>   <dbl>   <dbl>  <dbl>  <dbl>  <dbl>    <dbl>      <dbl>
##  1    14 F         0    2.11   1.00  -2.11  0.123    2.88 0.0441   -0.792 
##  2    14 M         1    2.11   1.00  -1.11  0.123    2.92 0.0123   -0.417 
##  3    14 F         0    2.11   1.00  -2.11  0.123    2.88 0.0441   -0.792 
##  4    14 M         0    2.11   1.00  -2.11  0.123    2.88 0.0441   -0.792 
##  5    14 F         2    2.11   1.00  -0.115 0.123    2.94 0.0001   -0.0430
##  6    14 M         4    2.11   1.00   1.89  0.123    2.90 0.0350    0.706 
##  7    15 F         0    2.68   0.719 -2.68  0.0635   2.86 0.0319   -0.970 
##  8    15 F         3    2.68   0.719  0.322 0.0635   2.94 0.00046   0.117 
##  9    15 M         6    2.68   0.719  3.32  0.0635   2.82 0.0490    1.20  
## 10    16 M         5    3.24   0.648  1.76  0.0515   2.90 0.0109    0.633 
## 11    16 F         3    3.24   0.648 -0.241 0.0515   2.94 0.00020  -0.0866
## 12    16 M         8    3.24   0.648  4.76  0.0515   2.69 0.0796    1.71  
## 13    16 F         6    3.24   0.648  2.76  0.0515   2.85 0.0268    0.993 
## 14    17 M         9    3.80   0.844  5.20  0.0874   2.62 0.174     1.91  
## 15    17 M         7    3.80   0.844  3.20  0.0874   2.82 0.0659    1.17  
## 16    17 F         0    3.80   0.844 -3.80  0.0874   2.77 0.0933   -1.40  
## 17    17 F         1    3.80   0.844 -2.80  0.0874   2.85 0.0507   -1.03  
## 18    18 F         2    4.37   1.18  -2.37  0.171    2.87 0.0857   -0.911 
## 19    18 M         1    4.37   1.18  -3.37  0.171    2.80 0.174    -1.30  
## 20    18 M         4    4.37   1.18  -0.366 0.171    2.93 0.00206  -0.141

# You can now easily plot the points (as points)
#   and the predicted values (as a line)
ggplot(data=aug_mydata_linearmodel_1) +
  geom_point(mapping=aes(x=age, y=crime)) +
  geom_line(mapping=aes(x=age, y=.fitted, color="red"))

# augment data second model (age as a nominal variable)
aug_mydata_linearmodel_2 <- augment(x=my_linearmodel_2,
                                    data=mydata)
# plot points and predictions
ggplot(data=aug_mydata_linearmodel_2) +
  geom_point(mapping=aes(x=age, y=crime)) +
  geom_line(mapping=aes(x=age, y=.fitted, color="red"))
# or plot the residuals
ggplot(data=aug_mydata_linearmodel_2) +
  geom_point(mapping=aes(x=age, y=.resid))

# model statistics
modelstat_my_linearmodel_2 <- glance(x=my_linearmodel_2)
modelstat_my_linearmodel_2
## # A tibble: 1 x 11
##       r.squared adj.r.squared sigma statistic p.value    df logLik   AIC   BIC
##         <dbl>         <dbl> <dbl>     <dbl>   <dbl> <int>  <dbl> <dbl> <dbl>
##   1     0.329         0.150  2.67      1.84   0.174     5  -45.2  102.  108.
## # ... with 2 more variables: deviance <dbl>, df.residual <int>



# GENERALIZED LINEAR MODELS
#
# Large family of models that include 
#   - logistic regression (binary = dichotomous = 0/1 dependent variable)
#   - Poisson regression  (count = 0-N dependent variable)
#   - negative binomial regression (count = 0-N dependent variable)
# and many more
#
# all estimated with the glm() function


# Let us first use the general linear model to estimate the
#   ordinary linear model:
my_generallinearmodel_1 <- glm(formula= crime ~ age, data=mydata, 
                            family=gaussian(link="identity"))
summary(my_generallinearmodel_1)
##  Call:
##    glm(formula = crime ~ age, family = "gaussian", data = mydata)
##  
##  Deviance Residuals: 
##    Min       1Q   Median       3Q      Max  
##  -3.8036  -2.1778  -0.3036   2.1036   5.1964  
##  
##  Coefficients:
##    Estimate Std. Error t value Pr(>|t|)
##  (Intercept)  -5.7653     6.9849  -0.825    0.420
##  age           0.5629     0.4416   1.275    0.219
##  
##  (Dispersion parameter for gaussian family taken to be 8.142914)
##  
##  Null deviance: 159.80  on 19  degrees of freedom
## Residual deviance: 146.57  on 18  degrees of freedom
##  AIC: 102.59
## 
## Number of Fisher Scoring iterations: 2


# compare glm and lm: same estimates
summary(my_linearmodel_1)
## Call:
##   lm(formula = crime ~ age, data = mydata)
## 
## Residuals:
##   Min      1Q  Median      3Q     Max 
## -3.8036 -2.1778 -0.3036  2.1036  5.1964 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)
## (Intercept)  -5.7653     6.9849  -0.825    0.420
## age           0.5629     0.4416   1.275    0.219
## 
## Residual standard error: 2.854 on 18 degrees of freedom
## Multiple R-squared:  0.08278,	Adjusted R-squared:  0.03182 
## F-statistic: 1.624 on 1 and 18 DF,  p-value: 0.2187

summary(my_generallinearmodel_1)
## Call:
##   glm(formula = crime ~ age, family = "gaussian", data = mydata)
## 
## Deviance Residuals: 
##   Min       1Q   Median       3Q      Max  
## -3.8036  -2.1778  -0.3036   2.1036   5.1964  
## 
## Coefficients:
##            Estimate Std. Error t value Pr(>|t|)
## (Intercept)  -5.7653     6.9849  -0.825    0.420
## age           0.5629     0.4416   1.275    0.219
## 
## (Dispersion parameter for gaussian family taken to be 8.142914)
## 
## Null deviance: 159.80  on 19  degrees of freedom
## Residual deviance: 146.57  on 18  degrees of freedom
## AIC: 102.59
## 
## Number of Fisher Scoring iterations: 2



## LOGIT REGRESSION = LOGISTIC REGRESSION

# We create a binary dependent variable: crime versus no crime
mydata$anycrime <- mydata$crime > 0

my_logit_1 <- glm(formula= anycrime ~ age, 
                  data=mydata, 
                  family=binomial(link="logit"))
summary(my_logit_1)

my_logit_2 <- glm(formula= anycrime ~ age + sex, 
                  data=mydata, 
                  family=binomial(link="logit"))
summary(my_logit_2)

# Direct acces to model outcomes
coefficients(my_logit_2)
fitted(my_logit_2)
residuals(my_logit_2)

# But the broom package also works here
# Table of estimates
estimates_my_logit_2 <- tidy(x=my_logit_2, conf.int=TRUE, conf.level=.90) 
estimates_my_logit_2

# You can request also exp(coefficient)
#   (note confidence interval is also exponentiated)
exp_estimates_my_logit_2 <- tidy(x=my_logit_2, exponentiate=TRUE, 
                                 conf.int=TRUE, conf.level=.90)                                 
exp_estimates_my_logit_2

# You can plot coefficients with ggplot()
exp_estimates_my_logit_2 %>%
  filter(term != "(Intercept)") %>%  # we do not want to plot the constant
ggplot() +
  geom_point(mapping=aes(x=estimate, y=term))

# Add predictions
augmented_my_logit_2 <- augment(x=my_logit_2, data=mydata)
# Plot predicted p
#  (p = exp(B) / (exp(B) + 1)
augmented_my_logit_2$predprob <- exp(augmented_my_logit_2$.fitted) / 
                              (exp(augmented_my_logit_2$.fitted) + 1)
ggplot(data=augmented_my_logit_2) +
  geom_line(mapping=aes(x=age, y=predprob, color=sex))

# Model statistics (note they are different from those reported by 
#   glance of a lm() model)
modelstat_my_logit_2 <- glance(x=my_logit_2)
modelstat_my_logit_2


# Poisson model for count data 
my_Poisson_1 <- glm(formula= crime ~ age + sex, 
                  data=mydata, 
                  family=poisson(link="log"))
summary(my_Poisson_1)

estimates_myPoisson_1 <- tidy(x=my_Poisson_1, exponentiate=TRUE, 
                              conf.int=TRUE, conf.level=.90)
augmented_myPoisson_1 <- augment(x=my_Poisson_1, data=mydata)
modelstat_myPoisson_1 <- glance(x=my_Poisson_1)

# negative binomial model for count data 
library(MASS)
my_negbin_1 <- glm.nb(formula= crime ~ age + sex, 
                    data=mydata, 
                    link=log)
summary(my_negbin_1)

estimates_my_negbin_1 <- tidy(x=my_negbin_1, exponentiate=TRUE, 
                              conf.int=TRUE, conf.level=.90)
augmented_my_negbin_1 <- augment(x=my_negbin_1, data=mydata)
modelstat_my_negbin_1 <- glance(x=my_negbin_1)



# Collineary check: function vif() from the 'car' package
vif(my_linearmodel_3)
##      age      sex 
## 1.010896 1.010896 


