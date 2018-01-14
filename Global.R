# WorldCloud - educational app for Coursera - Developing Data Products Course
# Week4 - Peer-graded Assignment: Course Project: Shiny Application and Reproducible Pitch
# global.r file
# pduchesne 14-JAN-2018
set.seed=(29092015)


library(rvest);
library(dplyr);
library(tidyr);
library(httr);
library(wordcloud);
library(memoise);
library(leaflet);
library(DT);
library(shiny);

#load txt file available at MaxMind.com web site
#https://www.maxmind.com/en/free-world-cities-database?pkit_lang=en
#specifically: http://download.maxmind.com/download/worldcities/worldcitiespop.txt.gz
#"This product includes data created by MaxMind, available from http://www.maxmind.com/"

#if (!file.exists("./worldcitiespop.txt.gz")){
#        fileURL <- "http://download.maxmind.com/download/worldcities/worldcitiespop.txt.gz"
#        download.file(fileURL,destfile = "./worldcitiespop.txt.gz")
#}

# change df_file <- read.csv("./worldcitiespop.txt.gz", to df_file <- read.csv("worldcitiespop.txt.gz",
df_file <- read.csv("worldcitiespop.txt.gz", header = TRUE, sep = ",", quote = "",na.strings="",  stringsAsFactors=FALSE)
df_file <- df_file %>% drop_na(Population)
df_file$City <- gsub('"', '', df_file$City)


#scrape isocodes and country names from World Atlas web page copywrite 2017 worldatlas.com
#to obtain full country names to display in dropdown list box.
url <- "http://www.worldatlas.com/aatlas/ctycodes.htm"

my_html <- read_html(url)
my_tables <- html_nodes(my_html,"table")[[1]]
countrycodes_table <- html_table(my_tables)
names(countrycodes_table) <- countrycodes_table[1,]
countrycodes_table<-countrycodes_table[-1,]
countrycodes_table<-countrycodes_table[-c(3:5)]
names(countrycodes_table) <- c("Country_name", "Country")
countrycodes_table$Country <- tolower(countrycodes_table$Country)

#merge both sources together
df_mrg<-merge(df_file, countrycodes_table, "Country")
df_mrg<-rename(df_mrg, lat=Latitude, lng=Longitude) # rename for use with Leaflet
rm(df_file)

#reduce number of countries to those having a city with a listed population 
countrycodes_table<-subset(df_mrg, Country %in% countrycodes_table$Country, 
                           select = c(Country,Country_name))

# The list of countries available for selection input

ll<-as.numeric(length(countrycodes_table$Country))
countries<-list()
for(i in 1:ll) {
        countries[i]<-list(countrycodes_table$Country[i])
        names(countries)[i]<-countrycodes_table$Country_name[i]
}


