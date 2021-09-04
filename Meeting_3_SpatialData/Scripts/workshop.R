#########################################################################################
# Title: SPATIAL DATA. NSC-R R WORKSHOP SERIES
# Author: Alex Trinidad
# Date: 02/09/2021
# Data: Crime data were downloaded from CODE using crimedata package (Ashby, 2019), 
#       census tracts, city boundary,  and roads  from TIGER (US Census Office) 
#       using tigris package (Walker & Rudis, 2021).
#########################################################################################
rm(list = ls())
library(sf)
mydatasf <- st_read("data/boston_crime.shp")

mycity <- st_read("data/boston_city.shp")

mytracts <- st_read("data/boston_tract.shp")

library(foreign)
mydatatbl <- read.dbf("data/boston_crime_tbl.dbf")

# Read data with R base

mydatasfrds <- readRDS("data/boston_crime.rds")

mydatatblrds <- readRDS("data/boston_crime_tbl.rds")

mycityrds <- readRDS("data/boston_city.rds")

mytractsrds <- readRDS("data/boston_tracts.rds")

myroads<- readRDS("data/county_roads.rds")

# Exploring the sf objects
## My point data
str(mydatasf)
mydatasf

## My polygon data
str(mycity)
mycity

## My line data
str(myroads)
myroads

# Another way to know the CRS
st_crs(mycity)

st_crs(mydatasf) == st_crs(mycity)

# Exploring the CRS
library(sp)
proj4string(as_Spatial(mycity))

# CRS transformation
mydatasf4269 <- st_transform(mydatasf, crs = 4269)

mydatasf4269_2 <- st_transform(mydatasf, crs = st_crs(mycity))

st_crs(mydatasf4269) == st_crs(mycity)

# Data frame to sf (spatial) object
class(mydatatbl)
head(mydatatbl)
mysfdata <- st_as_sf(mydatatbl, coords = c("longitd", "latitud"), crs = 4326)
class(mysfdata)
mysfdata

# Extract the coordinates
mycoordinates <- st_coordinates(mysfdata)

# Add the coordinates as columns 
library(tidyverse)
mysfdata <- mysfdata %>%
  mutate("longitude" = st_coordinates(mysfdata)[, 1]) %>%
  mutate("latitude" = st_coordinates(mysfdata)[, 2])

# Visual exploration
## Take a sample of the points
set.seed(123)
mysamplepoints <- dplyr::sample_n(mysfdata, 1000)

# This plots all the fields (columns)
plot(mysamplepoints)

# Plot only the geometry
plot(st_geometry(mysamplepoints))

# Add the polygon
plot(st_geometry(mycity), add = TRUE)

# Plot points in census tracts
plot(st_geometry(mytracts))
plot(st_geometry(mysfdata), add = TRUE, col = mysfdata$offns_gr)
plot(st_geometry(mycity), add = TRUE, border = "red")

# Select census tracts within city boundary
mycitytracts <- st_intersection(mytracts, mycity) 
mycitytracts <- mycitytracts %>% 
  select(1:12)
plot(st_geometry(mytracts))
plot(st_geometry(mycitytracts), add = TRUE, border = "blue")
plot(st_geometry(mycity), add = TRUE, border = "red")

# Counting points in census tracts 
## Sample of 100 
mysamplepoints_2 <- sample_n(mydatasf4269, 100)

## Identify point within census tracts
mypointsincensus <- st_intersection(mysamplepoints_2, mycitytracts)

## Count points in census tracts
mycrimecensus <- mypointsincensus %>%
  group_by(GEOID) %>%
  summarise(n = n()) %>%
  as_tibble() %>%
  select(-"geometry")
  
# Join points layer with census tracts
mycitycrime <- left_join(mycitytracts, mycrimecensus, by = "GEOID")

# Convert the NA in 0 and
mycitycrime <- mycitycrime %>%
  mutate(n = ifelse(is.na(n), 0, n)) %>%
  rename(., counts = n)

# Plot census tracts crime counts
plot(mycitycrime["counts"], key.pos = 4)

## Adding arguments
plot(mycitycrime["counts"], graticule = TRUE, key.pos = 4, key.pos = 1, axes = TRUE, 
     key.width = lcm(1.3), key.length = 1.0)

# Save the new data
## As shp 
st_write(mycitycrime, "Boston_crime_tracts.shp")

## Read 
boston <- st_read("Boston_crime_tracts.shp")

## As RDS
saveRDS(mycitycrime, "Boston_crime_tracts.rds")

## Read 
boston_rds <- readRDS("Boston_crime_tracts.rds")

plot(boston["crm_cnt"], graticule = TRUE, key.pos = 4, axes = TRUE, 
     key.width = lcm(1.3), key.length = 1.0)

###########################################################################################
####################################### Working with Grid Cells ###########################

# Clear objects from the environment
rm(list = ls())

# Read city boundaries
mycity <- st_read("data/boston_city.shp")

# Transform the projection NAD83, Massachusetts Mainland EPSG: 26986
mycity <- st_transform(mycity, 26986)

#Read crime data
mydatasf <- st_read("data/boston_crime.shp")

# Before we aggregate all crime counts to a unique year. Now we will consider the year. 
library(lubridate)
mydatasf <- mydatasf %>%
  mutate(date = date(mydatasf$dt_sngl),
         year = year(mydatasf$dt_sngl),
         month = month(mydatasf$dt_sngl),
         day = day(mydatasf$dt_sng))
 

# Grid cells
## Squares
mygridsq <- st_make_grid(mycity, cellsize = 300) %>%
            st_sf()

names(mygridsq) <- "geomsq"

st_geometry(mygridsq) = "geomsq"

mygridsq <- mygridsq[mycity, ]

plot(st_geometry(mycity), border = "red")
plot(st_geometry(mygridsq), add = TRUE)


## Hexagons
mygridhx <- st_make_grid(mycity, cellsize = 300, square = FALSE) %>%
            st_sf()

names(mygridhx) <- "geomhx"

st_geometry(mygridhx) = "geomhx"

mygridhx <- st_intersection(mygridhx,mycity) %>%
            select("NAME")

plot(st_geometry(mycity), border = "blue")
plot(st_geometry(mygridhx))

# Point to polygon
## Unique Id to the polygons
mygridhx <- mygridhx %>%
            mutate(hxid = seq(1:nrow(.)))

## Transform CRS of the crime
mydatasf <- st_transform(mydatasf, st_crs(mygridhx))

## Identify point within census tracts
point2hx <- st_intersection(mydatasf, mygridhx)

## How many crime counts are in each hexagon?
library(tidyr)
point2hx <- point2hx %>%
  group_by(hxid, year) %>%
  summarise(crime_count = n()) %>%
  as_tibble() %>%
  select(-"geometry") %>%
  pivot_wider(names_from = "year", names_prefix = "crimcount", values_from = "crime_count")

# Join points layer with census tracts
mycitycrimehx <- left_join(mygridhx, point2hx, by = "hxid")

# Convert the NA in 0 and
library(tidyselect)
mycitycrimehx <- mycitycrimehx %>%
  mutate(across(.cols = starts_with("crimcount"), ~ ifelse(is.na(.), 0, .))) 

# Calculate mean for 2017-2019
mycitycrimehx <- mycitycrimehx %>%
  mutate(meancrime = c((crimcount2017 + crimcount2018 + crimcount2019)/3))

# Plot results
plot(mycitycrimehx["meancrime"], graticule = TRUE, key.pos = 3, axes = TRUE, 
     key.width = lcm(1.3), key.length = 1.0)

##############################################################################
############################### Type of Crime ################################
# rm(list = ls())

# Read city boundaries
mycity <- st_read("data/boston_city.shp")

# Transform the projection NAD83, Massachusetts Mainland EPSG: 26986
mycity <- st_transform(mycity, 26986)

#Read crime data
mydatasf <- st_read("data/boston_crime.shp")

# Before we aggregate all crime counts to a unique year. Now we will consider the year. 
library(lubridate)
mydatasf <- mydatasf %>%
  mutate(date = date(mydatasf$dt_sngl),
         year = year(mydatasf$dt_sngl),
         month = month(mydatasf$dt_sngl),
         day = day(mydatasf$dt_sng))

# Grid cells
## Squares
mygridsq <- st_make_grid(mycity, cellsize = 300) %>%
  st_sf()

names(mygridsq) <- "geomsq"

st_geometry(mygridsq) = "geomsq"

mygridsq <- mygridsq[mycity, ]

# Point to polygon
## Unique Id to the polygons
mygridsq <- mygridsq %>%
  mutate(sqid = seq(1:nrow(.)))

## Transform CRS of the crime and take a sample of crimes
set.seed(321)
mydatasfq <- st_transform(mydatasf, st_crs(mygridsq)) %>%
  sample_n(5000)

## Identify point within census tracts
point2sq <- st_intersection(mydatasfq, mygridsq)

point2sq <- point2sq %>%
  group_by(sqid, offns_gn) %>%
  summarise(crime_count = n()) %>%
  as_tibble() %>%
  select(-"geometry") %>%
  pivot_wider(names_from = "offns_gn", names_prefix = "type_", values_from = "crime_count")

# Join points layer with census tracts
mytypeofcrime <- left_join(mygridsq, point2sq, by = "sqid")

# Convert the NA in 0 and

mytypeofcrime <- mytypeofcrime %>%
  mutate(across(.cols = starts_with("type_"), ~ ifelse(is.na(.), 0, .))) 

plot(mytypeofcrime["type_property"], key.pos = 4) 
plot(mytypeofcrime["type_persons"], key.pos = 4) 
plot(mytypeofcrime["type_society"], key.pos = 4) 
plot(mytypeofcrime["type_other"], key.pos = 4) 



#########################################################################################
################################### Maps ################################################
library(tmap)
library(tmaptools)

# Setting the mode
tmap_mode("plot")

# Static map
# Simple
tm_shape(mycitycrimehx) +
  tm_fill(col = "meancrime")

tm_shape(mycitycrimehx) +
  tm_polygons(col = "meancrime")

# Adding arguments
## For choosing the colours palette check tmaptools::palette_explorer()
mypalette <- viridisLite::plasma(20)

tm_shape(mycitycrimehx) +
  tm_polygons(col = "meancrime", palette = mypalette , style = "cont",
              n = 5, title = "Mean Offenses", lwd = 0.2, lty = 4, alpha = 1)

# Modify legend format
tm_shape(mycitycrimehx) +
  tm_polygons(col = "meancrime", palette = mypalette , style = "cont",
              n = 5, title = "Mean Offenses", lwd = 0.2, lty = 4, alpha = 1) +
  tm_layout(legend.width = -0.2, 
            legend.title.size= 0.9,
            legend.text.size = 0.7,
            legend.position = c("right","bottom"),
            legend.frame = TRUE)

# Add title
tm_shape(mycitycrimehx) +
  tm_polygons(col = "meancrime", palette = mypalette , style = "cont",
              n = 5, title = "Mean Offenses", lwd = 0.2, lty = 4, alpha = 1) +
  tm_layout(title ="Boston Offenses 2017-2019",
            title.size = 1,
            title.position = c("centre","bottom"),
            legend.width = -0.2, 
            legend.title.size= 0.9,
            legend.text.size = 0.7,
            legend.position = c("right","bottom"),
            legend.frame = TRUE)

# Add main title
tm_shape(mycitycrimehx) +
  tm_polygons(col = "meancrime", palette = mypalette , style = "cont",
              n = 5, title = "Mean Offenses", lwd = 0.2, lty = 4, alpha = 1) +
  tm_layout(main.title = "Boston Offenses 2017-2019",
            main.title.position = "centre",
            main.title.size = 1.5,
            legend.width = -0.2, 
            legend.title.size= 0.9,
            legend.text.size = 0.7,
            legend.position = c("right","bottom"),
            legend.frame = TRUE)

# Arranging maps together
mytypeprop <- tm_shape(mytypeofcrime) +
  tm_polygons(col = "type_property", palette = "PuRd" , style = "cont",
              n = 4, title = "Counts", lwd = 0.2, lty = 4, alpha = 1) +
  tm_layout(title ="Property Offenses 2017-2019",
            title.size = 0.7,
            title.position = c("centre","bottom"),
            legend.width = -0.1, 
            legend.title.size= 0.7,
            legend.text.size = 0.5,
            legend.position = c("right","bottom"),
            legend.frame = TRUE)

mytypepers <- tm_shape(mytypeofcrime) +
  tm_polygons(col = "type_persons", palette = "PuRd" , style = "cont",
              n = 4, title = "Counts", lwd = 0.2, lty = 4, alpha = 1) +
  tm_layout(title ="Person Offenses 2017-2019",
            title.size = 0.7,
            title.position = c("centre","bottom"),
            legend.width = -0.1, 
            legend.title.size= 0.7,
            legend.text.size = 0.5,
            legend.position = c("right","bottom"),
            legend.frame = TRUE)

mytypesociety <- tm_shape(mytypeofcrime) +
  tm_polygons(col = "type_society", palette = "PuRd" , style = "cont",
              n = 4, title = "Counts", lwd = 0.2, lty = 4, alpha = 1) +
  tm_layout(title ="Society Offenses 2017-2019",
            title.size = 0.7,
            title.position = c("centre","bottom"),
            legend.width = -0.1, 
            legend.title.size = 0.7,
            legend.text.size = 0.5,
            legend.position = c("right","bottom"),
            legend.frame = TRUE)

mytypeother <- tm_shape(mytypeofcrime) +
  tm_polygons(col = "type_other", palette = "PuRd" , style = "cont",
              n = 4, title = "Counts", lwd = 0.2, lty = 4, alpha = 1) +
  tm_layout(title ="Other Offenses 2017-2019",
            title.size = 0.7,
            title.position = c("centre","bottom"),
            legend.width = -0.1, 
            legend.title.size= 0.5,
            legend.text.size = 0.5,
            legend.position = c("right","bottom"),
            legend.frame = TRUE)

tmap_arrange(mytypeprop, mytypepers, mytypesociety, mytypeother)

# Adding more layouts 
tm_shape(mycitycrimehx) +
  tm_polygons(col = "meancrime", palette = mypalette , style = "cont",
              n = 5, title = "Mean Offenses", lwd = 0.2, lty = 4, alpha = 1) +
  tm_layout(main.title = "Boston Offenses 2017-2019",
            main.title.position = "centre",
            main.title.size = 1.5,
            legend.width = -0.2, 
            legend.title.size= 0.9,
            legend.text.size = 0.7,
            legend.position = c("right","bottom"),
            legend.frame = TRUE) +
  tm_scale_bar(breaks = c(0, 5, 10), text.size = 0.6, position = c("centre", "bottom")) +
  tm_compass(type = "4star", position = c("left", "top"))

# Changing the style 

tm_shape(mycitycrimehx) +
  tm_polygons(col = "meancrime", palette = mypalette , style = "cont",
              n = 5, title = "Mean Offenses", lwd = 0.2, lty = 4, alpha = 1) +
  tm_style("classic") +
  tm_layout(main.title = "Boston Offenses 2017-2019",
            main.title.position = "centre",
            main.title.size = 1.5,
            legend.width = -0.2, 
            legend.title.size= 0.9,
            legend.text.size = 0.7,
            legend.position = c("right","bottom"),
            legend.frame = TRUE) +
  tm_scale_bar(breaks = c(0, 5, 10), text.size = 0.6, position = c("centre", "bottom")) +
  tm_compass(type = "4star", position = c("left", "top")) 

# Interactive maps
library(leaflet)
## Set the mode
tmap_mode("view")

## Create the map
myinteractivemap <- tm_shape(mycitycrimehx) +
  tm_polygons(col = "meancrime", palette = mypalette , style = "cont",
              n = 5, title = "Mean Offenses", lwd = 0.2, lty = 4, alpha = 1) 

myinteractivemap + tm_basemap("OpenStreetMap")



tm_shape(mytypeofcrime) +
  tm_polygons(col = c("type_property", "type_persons"), 
              title =  c("Property Offenses", "Person Offenses"),
              alpha = 0.5, palette = "Blues") +
  tm_facets(sync = TRUE, ncol = 2)







