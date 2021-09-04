
library(tidyverse)

MyData <- tibble(
  age    = c(18, 30, 33, 21, 54, 48, 66, 39),
  speed  = c(70, 55, 45, 62, 45, 47, 38, 50),
  weight = c(66, 70, 75, 69, 78, 65, 56, 86),
  gender = c("male", "female", "male", "female", "male", "female", "male", "female")
)
MyData

##########################################################
# plotting is projecting data on a two-dimensional surface
##########################################################


# 1. specify where the data are: always a tibble/dataframe
ggplot(data=MyData)
## ggplot just shows an empty space because we haven't yet specified which
##    data in 'MyData' we want to plot

ggplot(data=MyData,
       mapping=aes(x=age, y=speed))
# ggplot shows the axes and 'knows'  about the scale of 'age' and 'speed'
#   but does not show anything else. Why not?
# We have not told about how we want the data to be projected (geom)
#    i.e. what geometric object to use

# Let's go for the obvious: points
ggplot(data=MyData,
       mapping=aes(x=age, y=speed)) +
  geom_point()
## OK, this is what we implicitly expected, maybe
ggplot(data=MyData,
       mapping=aes(age, speed)) +
  geom_point()
## it means this (first aes argument is x, second is y)
ggplot(data=MyData,
       mapping=aes(x=age, y=speed)) +
  geom_point()

# NOTE: if you see this (e.g. on other examples):


# Connect the points
ggplot(data=MyData, mapping=aes(x=age, y=speed)) +
  geom_line() 

ggplot(data=MyData, mapping=aes(x=age, y=speed)) +
  geom_path() 
# what happened?
ggplot(data=MyData, mapping=aes(x=age, y=speed)) +
  geom_path() + 
  geom_point()
# geom_path will connect using the order in the data

# So, we just learned we can add 'geoms' (layers) on top of each other
ggplot(data=MyData, mapping=aes(x=age, y=speed)) +
  geom_point() + 
  geom_line()
# geom_line will connect using the order on the x variable

# If you do not like the interpoloation suggested by sloped lines:
ggplot(data=MyData, mapping=aes(x=age, y=speed)) +
  geom_point() + 
  geom_step()

# More dimensions (add color)
ggplot(data=MyData, mapping=aes(x=age, y=speed, color=gender)) +
  geom_point() 

# Add shape
ggplot(data=MyData, mapping=aes(x=age, y=speed, color=gender, shape=gender)) +
  geom_point()

# Add size (note: Just to show how it works. You should not use
#           three attributes to label just one variable!
ggplot(data=MyData, mapping=aes(x=age, y=speed, color=gender, 
                                shape=gender, size=weight)) +
  geom_point()

# Where do we put the mappings?
ggplot(data=MyData) +
  geom_point(mapping=aes(x=age, y=speed))

# To change the look of all objects:
# Note: color and shape are indicate by quoted words, size by a number
ggplot(data=MyData) +
  geom_point(mapping=aes(x=age, y=speed), 
             color="purple", shape="triangle", size="2")

# Color can be used to visualize a relation by gender
ggplot(data=MyData) +
  geom_point(mapping=aes(x=age, y=speed, color=gender)) +
  geom_line(mapping=aes(x=age, y=speed))

# But sometimes faceting (plotting by levels of a variable) works better
ggplot(data=MyData) +
  geom_point(mapping=aes(x=age, y=speed)) +
  geom_line(mapping=aes(x=age, y=speed)) +
  facet_wrap(facets=vars(gender))


ggplot(data=MyData) +
  geom_line(mapping=aes(x=age, y=speed))
# group is useful for lines
ggplot(data=MyData) +
  geom_line(mapping=aes(x=age, y=speed, group=gender))

# You can add color
ggplot(data=MyData) +
  geom_line(mapping=aes(x=age, y=speed, group=gender, color=gender))

# However, when you use 'color' or 'linetype' to distinguish groups, 
#   'group' = implied
ggplot(data=MyData) +
  geom_line(mapping=aes(x=age, y=speed, color=gender))

ggplot(data=MyData) +
  geom_line(mapping=aes(x=age, y=speed, linetype=gender))

ggplot(data=MyData) +
  geom_line(mapping=aes(x=age, y=speed, color=gender, linetype=gender)) +
  geom_point(mapping=aes(x=age, y=speed))

ggplot(data=MyData) +
  geom_line(mapping=aes(x=age, y=speed, color=gender, linetype=gender)) +
  geom_point(mapping=aes(x=age, y=speed, color=gender))

ggplot(data=MyData) +
  geom_line(mapping=aes(x=age, y=speed, color=gender, linetype=gender)) +
  geom_point(mapping=aes(x=age, y=speed, color=gender, shape=gender))



# Scale (axis) limits
ggplot(data=MyData,
       mapping=aes(x=age, y=speed)) +
  geom_line() +
  ylim(c(0,70))

ggplot(data=MyData,
       mapping=aes(x=age, y=speed)) +
  geom_line() +
  ylim(c(0,70)) +
  xlim(c(0,70))


# Create frequency count by gender
MyData %>%
  group_by(gender) %>%
  summarize(Frequency=n()) %>%
# plot bar chart  
  ggplot() +
  geom_col(mapping=aes(x=gender, y=Frequency), 
           color="black", fill="lightblue")

# unlike geom_col(), geom_bar will take care of the 
#   statistical transformation
ggplot(data=MyData) +
  geom_bar(aes(x=gender), color="black", fill="lightgreen")
# geom_bar aptly labels the result of the statistical transformation
#   'count'. You can change the label though:
ggplot(data=MyData) +
  geom_bar(aes(x=gender), color="black", fill="lightgreen") +
  ylab("Freq")

