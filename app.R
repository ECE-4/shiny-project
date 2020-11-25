# Import libraries
library(shiny)
library(dplyr)
library(data.table)
library(stringr)
library(ggplot2)
library(googleVis)

setwd("~/Documents/shiny-project")

# Function that import the data of a city
prepare_data <- function(city ,date)
{
  # Load the correct dataset
  if(city == "madrid"){
    listing_url <- paste0("http://data.insideairbnb.com/spain/comunidad-de-madrid/madrid/",date,"/data/listings.csv.gz")
    calendar_url <- paste0("http://data.insideairbnb.com/spain/comunidad-de-madrid/madrid/",date,"/data/calendar.csv.gz")
  } else if(city == "amsterdam"){
    listing_url <- paste0("http://data.insideairbnb.com/the-netherlands/north-holland/amsterdam/",date,"/data/listings.csv.gz")
    calendar_url <- paste0("http://data.insideairbnb.com/the-netherlands/north-holland/amsterdam/",date,"/data/calendar.csv.gz")
  } else if(city == "bordeaux"){
    listing_url <- paste0("http://data.insideairbnb.com/france/nouvelle-aquitaine/bordeaux/",date,"/data/listings.csv.gz")
    calendar_url <- paste0("http://data.insideairbnb.com/france/nouvelle-aquitaine/bordeaux/",date,"/data/calendar.csv.gz")
  } else if (city =="brussels"){
    listing_url <- paste0("http://data.insideairbnb.com/belgium/bru/brussels/",date,"/data/listings.csv.gz")
    calendar_url <- paste0("http://data.insideairbnb.com/belgium/bru/brussels/",date,"/data/calendar.csv.gz")
  } else if (city == "berlin"){
    listing_url <- paste0("http://data.insideairbnb.com/germany/be/berlin/",date,"/data/listings.csv.gz")
    calendar_url <- paste0("http://data.insideairbnb.com/germany/be/berlin/",date,"/data/calendar.csv.gz")
  } else if (city == "malaga"){
    listing_url <- paste0("http://data.insideairbnb.com/spain/andaluc%C3%ADa/malaga/",date,"/data/listings.csv.gz")
    calendar_url <- paste0("http://data.insideairbnb.com/spain/andaluc%C3%ADa/malaga/",date,"/data/calendar.csv.gz")
  } else if (city == "ghent"){
    listing_url <- paste0("http://data.insideairbnb.com/belgium/vlg/ghent/",date,"/data/listings.csv.gz")
    calendar_url <- paste0("http://data.insideairbnb.com/belgium/vlg/ghent/",date,"/data/calendar.csv.gz")
  } else if (city == "antwerp"){
    listing_url <- paste0("http://data.insideairbnb.com/belgium/vlg/antwerp/",date,"/data/listings.csv.gz")
    calendar_url <- paste0("http://data.insideairbnb.com/belgium/vlg/antwerp/",date,"/data/calendar.csv.gz")
  } else if (city == "valencia" ){
    lisitng_url <- paste0("http://data.insideairbnb.com/spain/vc/valencia/",date,"/data/listings.csv.gz")
    calendar_url <- paste0("http://data.insideairbnb.com/spain/vc/valencia/",date,"/data/calendar.csv.gz")
  } else if (city == "girona"){
    listing_url <- paste0("http://data.insideairbnb.com/spain/catalonia/girona/",date,"/data/listings.csv.gz")
    calendar_url <- paste0("http://data.insideairbnb.com/spain/catalonia/girona/",date,"/data/calendar.csv.gz")
  } else if (city == "venice"){
    listing_url <- paste0("http://data.insideairbnb.com/italy/veneto/venice/",date,"/data/listings.csv.gz")
    calendar_url <- paste0("http://data.insideairbnb.com/italy/veneto/venice/",date,"/data/calendar.csv.gz")
  } else if (city == "florence"){
    listing_url <- paste0("http://data.insideairbnb.com/italy/toscana/florence/",date,"/data/listings.csv.gz")
    calendar_url <- paste0("http://data.insideairbnb.com/italy/toscana/florence/",date,"/data/calendar.csv.gz")
  }
  
  # Read the data 
  listings <- data.table::fread(listing_url)
  calendar <- data.table::fread(calendar_url)
  
  ## Add Keys: columns city and day date
  listings$city <- city
  listings$date <- date
  
  ## Select interesting columns
  ### Most columns don't contain interesting information
  columns_listings <- c("city", "id","date", "neighbourhood_cleansed", 
                        "latitude", "longitude", 
                        "property_type", "room_type", "accommodates", "bedrooms", 
                        "beds", "price", "minimum_nights",  "maximum_nights")
  
  listings <- listings %>% 
    select(columns_listings) %>% 
    arrange(id)
  
  # Cleaning calendar dataframe
  
  ## arrange by id and date
  calendar <- calendar %>% 
    arrange(listing_id, date)
  
  ## add day number (starting first day)
  calendar <- calendar %>%
    group_by(listing_id) %>%
    mutate(day_nb = row_number()) %>%
    ungroup()
  
  ## change available column to binary
  calendar <- calendar %>%
    mutate(available = ifelse(available=="t", 1, 0))
  
  ## clean price column and transform to numeric
  calendar <- calendar %>%
    mutate(price = str_replace(price, "\\$", ""),
           adjusted_price = str_replace(adjusted_price, "\\$", ""))
  calendar <- calendar %>%
    mutate(price = str_replace(price, ",", ""),
           adjusted_price = str_replace(adjusted_price, ",", ""))
  calendar <- calendar %>%
    mutate(price = as.numeric(price),
           adjusted_price = as.numeric(adjusted_price))
  
  ## calculate estimated revenue for upcoming day
  calendar <- calendar %>%
    mutate(revenue = price*(1-available))
  
  ## calculate availability, price, revenue for next 30, 60 days ... for each listing_id
  calendar <- calendar %>%
    group_by(listing_id) %>%
    summarise(availability_30 = sum(available[day_nb<=30], na.rm = TRUE),
              price_30 = mean(price[day_nb<=30 & available==0], na.rm = TRUE),
              revenue_30 = sum(revenue[day_nb<=30], na.rm = TRUE),
    )
  
  listings_cleansed <- listings %>% left_join(calendar, by = c("id" = "listing_id"))
  return (listings_cleansed)
}

# Function that runs the entire app
start_app <- function(){
  # France
  bordeaux1 <<- prepare_data("bordeaux","2020-09-19")
  bordeaux2 <<- prepare_data("bordeaux","2020-08-29")
  bordeaux3 <<- prepare_data("bordeaux","2020-07-25")
  
  # Netherlands
  amsterdam1 <<- prepare_data("amsterdam", "2020-09-09")
  amsterdam2 <<- prepare_data("amsterdam", "2020-08-18")
  amsterdam3 <<- prepare_data("amsterdam", "2020-07-09")
  
  # Germany
  berlin1 <<- prepare_data("berlin", "2020-08-30")
  berlin2 <<- prepare_data("berlin", "2020-06-13")
  berlin3 <<- prepare_data("berlin", "2020-05-14")
  
  # Belgium
  brussels1 <<- prepare_data("brussels","2020-06-15")
  brussels2 <<- prepare_data("brussels","2020-05-17")
  brussels3 <<- prepare_data("brussels","2020-04-19")
## add Ghent
  #ghent1 <<- prepare_data("ghent","2020-07-28")
  
## add Antwerp
  antwerp1 <<- prepare_data("antwerp", "2020-06-22")
  
  # Spain 
  malaga1 <<- prepare_data("malaga","2020-06-30")
  malaga2 <<- prepare_data("malaga","2020-05-31")
  malaga3 <<- prepare_data("malaga","2020-04-30")
## add Valencia
  valencia1 <<- prepare_data("valencia", "2020-08-30")
## add Girona
  girona1 <<- prepare_data("girona", "2020-05-28")
  
  # Italy
## add Venice
  venice1 <<- prepare_data("venice", "2020-09-08")
## add Florence
  florence1 <<- prepare_data("florence", "2020-08-31")
  
}
