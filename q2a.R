#install.packages("tidyverse")
#The next packages will be needed, if you have not installed them, please uncomment the lines
#install.package("ggplot2")
#install.packages("WDI")
#install.packages("MAP")
#install.packages("maps")

#Load the libraries. 
library("Matrix")
library("flexmix")
library("lattice")
library(MAP)
library(maps)
library(tidyverse)
library(ggplot2)
library(ggmap)

# Obtain the data. 
install.packages("WDI")
library(WDI)

# Search the variables related to CO2.
WDIsearch('co2 .* capita')

# We extract the data and save it in 
worldco2 <- WDI(country = "all", indicator = "EN.ATM.CO2E.PC", start = 2014, end = 2014, extra = TRUE)
head(worldco2,3)

# Convert the object as tibble. 
worldco2g = as_tibble(worldco2)
glimpse(worldco2g)

# We are going to eliminate the first 5 rows sionce are the wordl and the regional aggregates 
# Also, rename the variable EN.ATM.CO2E.PC as emission for easy handdle.
n <- dim(worldco2g)[1]
worldco2c <- worldco2g %>% rename(emission=EN.ATM.CO2E.PC) %>% filter(region != "Aggregates")
glimpse(worldco2c)

# First, we are going to plot the CO2 emission per country in a scatterplot 
ggplot(worldco2c,aes(x=region,y=emission)) + geom_boxplot() + theme(axis.text=element_text(size=7,angle=90,hjust = 1,vjust=1))
ggplot(worldco2c,aes(x=income,y=emission)) + geom_boxplot()

# Create the map, this is the basis and we are going to add emissions as metadata 
dataMap <- map_data("world")
head(dataMap)

# Need to add the countrycode in both datasets, so we have a common column to link them. 
install.packages("countrycode")
library(countrycode)
dataMap$countrycode <- countrycode(dataMap$region, origin="country.name",destination="wb")

# Add the country code to the worldco2c set
worldco2c$countrycode <- countrycode(worldco2c$country, origin="country.name",destination="wb")

# Join both data sets 
joinedData <- left_join(worldco2c,dataMap, by="countrycode")

# Finally, plot the map
ggplot(joinedData,aes(x=long,y=lat,group=group,fill=emission,)) + geom_polygon() + coord_quickmap() + scale_size_area() + ggtitle("Distribution of CO2 emission in the world during 2014 (tons per capita)") + labs(x=NULL,y=NULL, fill="CO2 emissions") + guides(fill=guide_colorbar(size=7,reverse=FALSE)) + theme(legend.direction="horizontal",legend.position="bottom", legend.justification=c(0.5,0.5), legend.title = element_text(size = 9),plot.title = element_text(hjust = 0.5), axis.text.x=element_blank(),axis.text.y=element_blank()) + scale_fill_gradient(low="orange", high="red")
