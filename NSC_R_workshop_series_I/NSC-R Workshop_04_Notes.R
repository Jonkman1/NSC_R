# clear memory
library(ggrepel)
rm(list = ls())

######################################################
# 
# NSC-R Workshop_transform.R
# Wouter Steenbeek 2020-05-25
# 
######################################################

# Wim, it's DEE-PLY-ER and not DEPLOYER

# load tidyverse -- dplyr is part of it
library(tidyverse)
setwd("C:/Users/wimbe/KINGSTON/R/R-NSCR/Meeting_03/")
# load Corona data
# Use the file provided by Wim:
# use base R to read the data into object 'corona'
corona <- read.csv("CoronaVirus.csv", stringsAsFactors = FALSE)


# which class is this object?
class(corona)

head(corona)

# In R, there are many ways to skin a cat.
# Let's subset the data: view/select one variable.
# How do we view/select the variable "cases"?
# (and use "head()" to get the first 6 elements)
# How do we calculate the mean of this variable?

head(corona$cases)       # mean(corona$cases)
head(corona[, "cases"])
head(corona[["cases"]])
head(corona["cases"]) # not quite... what is different here? # mean(corona["cases"])

head(corona$case) # does this work?
head(corona$cas) # does this work?
head(corona$ca) # does this work?
head(corona$c) # does this work? why not? # mean(corona$c)

head(corona[, "case"]) # and this? # mean(corona[, "case"])
head(corona[["case"]]) # and this? # mean(corona[["case"]])
head(corona["case"]) # and this? # mean(corona["case"])

# note with and within:
with(corona, mean(cases))
corona <- within(corona, mean_cases <- mean(cases))
head(corona)

# by column number
names(corona) # check which it is
head(corona[, 4])
head(corona[[4]])
head(corona[4]) # same "not quite" as above # mean(corona[4])

# or can even select the columns by testing whether it matches your string
head(corona[, names(corona) == "cases"])

# R is pretty old, and based on S
# All of these ways to subset are, or just to be, useful.
# Many people work only with data.frames, or its new and improved cousin:
# tibbles. For tibbles (and data.frames), you don't need so many ways to
# select a variable: you need one command that always works.

# The same applies to steps of subsetting, sorting, recoding, and summarizing 
# data. Wouldn't it be nice if they work the same way, making them
# more natural to use?

# dplyr is a package full of functions that help you subsetting, sorting, 
# recoding, and summarizing data, all using a consistent syntax.

# dplyr data wrangling functions all work similarly:
#  1. The first argument is a data frame.
#  2. The subsequent arguments describe what to do with the data 
#     frame, using the variable names (without quotes).
#  3. The result is a new data frame.

corona <- read_csv("CoronaVirus.csv")

class(corona)

# Pssttt.... tibbles don't allow you to select a variable by abbreviation,
corona$case
corona$cas
corona$ca
corona$c

# and the output is nicer to look at:
corona

####################################

# dplyr is a package full of functions that help you subsetting, sorting, 
# recoding, and summarizing data, all using a consistent syntax.

# Let's discuss a number of key "verbs"

corona

# select()
# Pick variables by their names (or inverse pick them, i.e. drop them)
select(corona, cases)
select(corona, country, cases, new_cases)
select(corona, country, cases:deaths)
select(corona, -cases)
select(corona, -c(update, last_update, new_cases:active_cases))
# note: no more double quotes!


# filter()
# Pick rows by their values
filter(corona, deaths > 20000)
filter(corona, deaths > 20000, update > 90) # are combined using "&"
filter(corona, deaths > 20000 & update > 90)
filter(corona, deaths > 20000 | update < 20) # "|" means "or"


# slice()
# Pick specific rows by row number
corona
slice(corona, c(1,10,8))


# arrange()
# Reorder rows
corona
arrange(corona, country)
arrange(corona, country, date)
arrange(corona, date, country)
arrange(corona, desc(deaths))


# mutate().
# Create new variables with functions of existing variables.
# This adds a new variable to the data frame
corona2 <- mutate(corona, total = deaths + recovered + active_cases)
# show result:
select(corona2, c(country, cases, deaths, recovered, active_cases, total))

# # base r:
# 
# temp <- corona
# temp$total <- temp$deaths + temp$recovered + temp$active_cases
# temp$total2 <- temp$deaths + temp$recovered + temp$active_cases
# head(as.data.frame(temp))
# 
# # or: 
# 
# temp <- within(corona, total <- deaths + recovered + active_cases)
# head(as.data.frame(temp))

# sum of deaths -- is this useful?
corona2 <- mutate(corona2, deaths_sum = sum(deaths))
select(corona2, c(country, cases, deaths, recovered, active_cases, deaths_sum))


# summarise()
# Collapse many values down to a single summary
# The data frame is lost, only the new summary is shown
summarise(corona, total = sum(deaths))
# This isn't terribly informative as is, but combine it with...


# group_by()
# changes the unit of analysis from the complete dataset to individual 
# groups. Then, when you use the dplyr verbs on a grouped data frame 
# they’ll be automatically applied “by group”
corona_by_date <- group_by(corona, date)
corona_by_date # notice the "Groups" (PS. the data may not "look" ordered by date, but it is)
corona3 <- summarise(corona_by_date, deaths = sum(deaths, na.rm = TRUE),
                                     recovered = sum(recovered, na.rm = TRUE))

summarise(corona_by_date, deaths_mean = mean(deaths, na.rm = TRUE),
                          deaths_sum = sum(deaths))

corona3
# So this is the world-wide total number of deaths and recovered by date
# Hopefully more people are recovered than not

# Compare different output of mutate()
corona3b <- mutate(corona_by_date, deaths_mean = mean(deaths, na.rm = TRUE))
select(arrange(corona3b, date, country), country, date, deaths_mean)
# all of the original data is still there. We have calculated the
# the sum of deaths and sum of recovered *by date*
# and added this as two new variables. So by date, the values
# are repeated.

# This is a bit weird because these first 7 rows have no meaning -- they
# could be collapsed into one row. That is exactly what summarise() did:
corona3

# plot data
ggplot(data = corona3, mapping = aes(x = date, y = deaths)) +
  geom_line() +
  labs(title = "COVID-19 deaths over time",
       caption = "data: https://github.com/eparker12/nCoV_tracker",
       x = "Date",
       y = "Total number of deaths") +
  theme_classic()




## I would like to know the development of total deaths by country over time.
## Hey, there's the variable "deaths", running total number of deaths by 
## country and date. That's exactly what we need. 
## 
## BUT..... now suppose we *didn't* have "deaths", but we only had 
## "new_deaths": the number of new deaths for that country on that particular 
## date. We'd then need to transform the data to create that variable.

corona_by_cntry <- arrange(corona, country, date)
corona_by_cntry2 <- group_by(corona_by_cntry, country)
corona4 <- mutate(corona_by_cntry2, deaths_total = cumsum(new_deaths)) # cumsum of new_deaths
print(
  select(corona4, country, date, new_deaths, deaths_total), 
  n = 50
  )


# # FYI
# cor(corona4$deaths, corona4$deaths_total)
# # correlation should be 1, but isn't
# prop.table(table(corona4$deaths == corona4$deaths_total)) * 100
# # in 2.9% of all rows, deaths does not equal deaths_total
# # so is new_deaths correct (and by extension deaths_total),
# # or is deaths correct? I.e., we've found an inconsistency in the original data.





###################################################
#
#    %>%    pipe operator 
#
###################################################

# What did we actually do above?
print(
  select(
    mutate(
      group_by(
        arrange(corona, country, date), 
        country), 
      deaths_total = cumsum(new_deaths)),
    country, date, new_deaths, deaths_total),
  n = 50, width = Inf)

# Ugh. Unreadable.
# So in practice we often don't do this. We do what we did above:
# save temporary objects and so on.
# You can follow along, but very quickly you have to save
# many temporary objects (or overwrite them every time).
# When you later on decide that "corona_by_cntry2" is a bad name,
# you have to find & replace every instance of it.

# Piping to the rescue.

# This will change your R (data transformation) life
#  - combines multiple operations
#  - passes an object forward into the next function call / expression
#  - makes R code more readable

# When you see %>% , think "... AND THEN ..."

# What the pipe %>% does: it feeds the object before the pipe into the
# next function, and automatically enters it as the first argument of that
# function.

# Reorder corona data by country and then by date:
# 
#       arrange(corona, country, date)
#
# Now using %>% :
# 
#       corona %>% arrange(country, date)
#       
# This means:
# 
# "Start with the object corona AND THEN arrange by country and date"
# 
# Technically, dplyr does:
#       
#                    arrange(   , country, date)
#                             ^
#                             |
# puts object "corona" here ---
#
# 
# The great advantage: think naturally, in terms of steps 
# that we want to achieve. The output of a first
# step is automatically the start of the next step.
 
# We want to:
#   start with data frame 'corona' AND THEN
#      reorder so within country, date increases AND THEN
#      group by country AND THEN
#      calculate the cumulative sum of deaths AND THEN
#      print some data

corona %>%
  arrange(country, date) %>%
  group_by(country) %>%
  mutate(deaths_total = cumsum(new_deaths)) %>%
  print(n = 50, width = Inf)

# No more in-between objects necessary! Easy to read!



# Let's plot the corona deaths over time, for the
# 10 countries with the highest total number of Corona deaths.

# As with any data transformation, we first have to THINK about what the data
# looks like now (A). And how we want the data to look (B). If we can imagine
# that, then we have to think about *how* to get the data from A to B. 
# 
# Note that the "how" is a balance of efficiency and understandability: often
# (in R) there are super-efficient ways to getting stuff done (i.e., one sentence
# of code can do a lot), but your future self won't understand your code anymore,
# let alone your research partners. On the other hand, it doesn't make sense
# to write pages of code yourself (that takes you step by step through
# all intermediate steps and is perfectly understandable) that could be 
# performed by calling a single function.

# My data looks like
corona
# I want it to look exactly like this, but with only a selection of 10 countries
# and I only need variables country, date, and deaths.
# 
# How do I get from A to B? My idea is:
# 1. create a vector of 10 countries with highest number of corona deaths
# 2. filter the 'corona' data frame on these country names
# 3. select the right variables
# 4. plot

# Step 1 consists of a few steps
which_countries <- corona %>%                 # assign the output to "which_countries". I start with corona AND THEN
  group_by(country) %>%                       # group by country AND THEN         
  summarise(deaths_max = max(deaths)) %>%     # summarize to one row per group with max deaths AND THEN
  arrange(desc(deaths_max)) %>%               # rearrange from high to low on death_max AND THEN
  slice(1:10) %>%                             # get the first 10 rows AND THEN
  pull(country)                               # pull out the vector of country names

which_countries

# Step 2 and 3
corona_for_plot <- corona %>%                          # start with corona AND THEN
  filter(country %in% which_countries) %>%             # filter on country name AND THEN
  select(country, date, deaths)                        # select variables

# Step 4
ggplot(data = corona_for_plot, 
       mapping = aes(x = date, y = deaths, col = country)) +
  geom_line(alpha = .7) +
  theme_classic() +
  labs(title = "COVID-19 deaths over time, by country",
       caption = "data: https://github.com/eparker12/nCoV_tracker",
       x = "Date",
       y = "Total number of deaths")

# log the y-axis, because epidemiologists tell me that's a good thing to do
# and use piping and dplyr to select only dates from April 1 onwards
ggplot(data = corona_for_plot %>% filter(date >= "2020-04-01"), 
       mapping = aes(x = date, y = deaths, col = country)) +
  geom_line(alpha = .7) +
  theme_classic() +
  scale_y_log10() +
  labs(title = "COVID-19 deaths over time, by country",
       caption = "data: https://github.com/eparker12/nCoV_tracker",
       x = "Date",
       y = "Log number of deaths")


# Exercise:

# After the first few Covid deaths, estimates are pretty noisy, so
# instead of plotting by date on the x-axis, we want to plot 
# the number of days since the outbreak for that particular country.
# To eb more precise, we want to emulate those graphs in the news paper:
# we want the plot (on the x-axis) the number of days after the *100th death* by 
# Covid for that particular country, for the top 10 countries.
# The y-axis should be the number of Covid deaths since those first 100 deaths.

# Our data looks like:
corona
# You want it to look almost like "corona_for_plot",
# but with "date" as
# a running number of days after the country passes the 100th death by Covid.

# probably there's an even easier way to do this, but I though of these steps:
corona_for_plot <- corona %>%                          # start with corona AND THEN
  filter(country %in% which_countries) %>%             # filter on country name AND THEN
  select(country, date, deaths) %>%                    # select variables AND THEN
  arrange(country, date) %>%                           # I want to make 100% sure that within country, the date if ordered sequentially  AND THEN
  group_by(country) %>%                                # I group by country AND THEN
  filter(deaths > 100) %>%                             # within each country, keep only observations with Covid deaths > 100   AND THEN
  mutate(deaths_total_after_100th = deaths - 100) %>%  # calculate the number of total deaths minus 100   AND THEN
  mutate(day = date - first(date))                     # count the number of days since the first date of that particular country


# note: I find it hard to match lines to country labels, so
# I label the lines in the plot itself
# library "ggrepel" is used to create non-ovelapping labels, i.e. to let
# them repel each other a little bit.
# 
# You need package ggrepel for this. Use
# install.packages("ggrepel")
# (once) to install it.
ggplot(data = corona_for_plot, mapping = aes(x = day, y = deaths_total_after_100th, col = country)) +
  geom_line(alpha = .7) +
  theme_classic() +
  labs(title = "COVID-19 deaths since 100th Corona death, by country",
       caption = "data: https://github.com/eparker12/nCoV_tracker",
       x = "Days since 100th death",
       y = "Total number of deaths since 100th death") +
  theme(legend.position = "none") +
  ggrepel::geom_label_repel(data=. %>% 
              arrange(desc(deaths_total_after_100th)) %>% 
              group_by(country) %>% 
              slice(1), 
            aes(label = country), 
            show.legend=FALSE)




####################################################
#
# Make data wider or longer
# 
####################################################

corona

corona_long <- pivot_longer(corona, 
                            cols = cases:active_cases, 
                            names_to = "condition",
                            values_to = "ncases") 

arrange(corona_long, jhu_ID, condition, date)

# all variables "cases" through and including "active_cases" is pasted below each other
# This is very helpful in combination with dplyr's verbs, for example,
# it is easy to calculate the mean for cases:active_cases all at once:
#   corona_long %>% group_by(country, name) %>% summarise(mean = mean(ncases))

# Or to plot all of these automatically:
ggplot(data = corona_long %>% filter(country %in% c("Italy", "Spain", "France")), 
       mapping = aes(x = date, y = ncases, col = country)) +
  geom_line(alpha = .7) +
  theme_bw() +
  labs(title = "COVID-19",
       caption = "data: https://github.com/eparker12/nCoV_tracker",
       x = "Date",
       y = "Count") +
  facet_wrap(. ~ condition, scales = "free_y")


# pivot wider (i.e., back to original)
corona_wide <- corona_long %>%
  pivot_wider(names_from = condition, 
              values_from = ncases)

# filter only a few countries and dates
corona_long2 <- corona_long %>%
  arrange(country, date) %>%
  filter(country %in% c("Italy", "Spain")) %>%
  filter(as.character(date) %in% c("2020-04-01", "2020-04-02")) %>%
  select(country, date, condition, ncases)
corona_long2 %>% print(n = Inf)

# pivot wider -- using condition AND date
corona_wide2 <- corona_long2  %>%
  pivot_wider(names_from = c(condition, date),
              names_sep = "##",
              values_from = ncases)

corona_wide2

# Ugh. This format is used in some statistical programs: variables X1 and X2 at 
# different times points T1, T2, and T3. These are repeated in separate columns:
# X1_T1, X1_T2, X1_T3, X2_T1, X2_T2, X3_T3

# If this is necessary for your analysis, so be it. But for data prep,
# descriptive statistics etc, this is not recommended. So if data looks like
# this, the recommendation is to pivot it to a longer format.

# back to corona_long2
corona_wide2 %>% pivot_longer(cols = -country, 
                              names_to = c("condition", "date"),
                              names_sep = "##",
                              values_to = "ncases") %>%
  print(n = Inf)



####################################################
#
# Notes
# 
####################################################

# Take a look at R for Data Science (https://r4ds.had.co.nz/) to get a really
# thorough overview. Especially section 5.6 could be useful because Hadley
# lists a number of often-used functions in conjunction with summarise()

# Also note that when your data is grouped, each successive summarise call removes
# one layer of grouping:
temp <- corona %>%
  filter(country %in% which_countries[1:5]) %>%
  mutate(month = lubridate::month(date))

temp1 <- temp %>%
  group_by(country, month, date) %>%
  summarise(deaths = sum(deaths))

temp1   # sum of deaths per country-month-date combo

temp2 <- temp1 %>%
  summarise(deaths = sum(deaths)) 

temp2   # the sum of deaths per country-month combo

temp3 <- temp2 %>% 
  summarise(deaths = sum(deaths)) 

temp3  # the sum of deaths per country

temp4 <- temp3 %>% 
  summarise(deaths = sum(deaths)) 

temp4   # the sum of deaths


