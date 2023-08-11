# ep. 7 from 
# Intro to R for GeoSpatial
# Histograms / Distributions in ggplot

# make sure to restart R and sweep your environment!
# green / red


library("ggplot2")
# dplyr is needed for the filter function 
# and pipes %>% 
library("dplyr")

# remake your folders if you deleted them
# and setup your directory structure like so:
dir.create("doc")
dir.create("data")
dir.create("src")

# and confirm that you are operating in the proper
# location
getwd()

# just in case you don't have it.
download.file("https://datacarpentry.org/r-intro-geospatial/data/gapminder_data.csv",
              "data/gapminder_data.csv")


# we all need to run this
gapminder <- read.csv("data/gapminder_data.csv", stringsAsFactors = TRUE)

# ggplots get build one layer at a time.
# beginning with the plot field
ggplot(data = gapminder, aes(x = lifeExp))

# no data draws until
# you give it a geom_xxxX
# if you don't give it 2 variables, the default
# is to count values.
ggplot(data = gapminder, aes(x = lifeExp)) +   
  geom_histogram()

ggplot(data = gapminder, aes(x = lifeExp)) +   
  geom_dotplot()

# you need to put something on the y axis
# if you want to compare values

# what other variables are available?
# what would make sense to graph one
# vs the other?
str(gapminder)

# life expenctancy vs income
ggplot(data = gapminder, aes(x = lifeExp, y=gdpPercap)) +   
  geom_point()



# challenge #####################
# Modify the histogram so that the figure shows the distribution 
# of gdp per capita, rather than life expectancy
# what's the story?
# lots of rich countries or lots of poor countries?




# selecting out individual elements
# with filter
gapminder_2007 <- filter(gapminder, year == 2007)
str(gapminder)

# note we are re-using the variable
gapminder_2007 <- filter(gapminder, year == 2007, continent == "Americas")
str(gapminder)

# but this graph is impossible to read
ggplot(data = gapminder_2007, aes(x = country, y = gdpPercap)) + 
  geom_col()

# How might we fix it? 



# use coord_flip
ggplot(data = gapminder_2007, aes(x = country, y = gdpPercap)) + 
  geom_col() +
  coord_flip()


# there's another way to do this.........
# flip the x and y
ggplot(data = gapminder_2007, aes(x = gdpPercap, y = country)) + 
  geom_col()



# if you want multiple years, you can do 
# multiple filters
# and also use %>% ([pronouned 'pipe']) to
# push commands down a pipeline

# build a pipeline step-by-step.
gapminder_Americas <- gapminder %>% 
  filter(continent == "Americas")

gapminder_52 <- gapminder %>% 
  filter(year == 1952)

gapminder_07 <- gapminder %>% 
  filter(year == 2007)

# HOW to stack them up?
# Americas AND
# (1952 OR 2007)

gapminder_bool <- gapminder %>% filter(year == 1952 | year == 2007)
gapminder_in <- gapminder %>%  filter(year %in% c(1952, 2007))

gapminder_sample <- gapminder %>%
  filter(continent == "Americas",
         year %in% c(1952, 2007))


# see:
#         https://swcarpentry.github.io/r-novice-gapminder/13-dplyr.html
#         https://swcarpentry.github.io/r-novice-gapminder/14-tidyr.html



# Challenge 2: 
# Use help to change the color of the bars
# in our new gapminder_sample



# There's a TON of parameters:
# gdp per capita of all countries 
# in the Americas for the years 1952 and 2007, color coded by year.
# geom_col(position = )
# aes(fill =)
# 

ggplot(gapminder_sample, 
       aes(x = country, y = gdpPercap, 
           fill = as.factor(year))) +
  geom_col(position = "dodge") + 
  coord_flip()


# save your graphs as objects
output_52_07 <- ggplot(gapminder_sample, 
                       aes(x = country, y = gdpPercap, 
                           fill = as.factor(year))) +
  geom_col(position = "dodge") + 
  coord_flip()

output_52_07

# export your graphs as files
ggsave("doc/1952-to-2007-Americas.png", output_52_07)

