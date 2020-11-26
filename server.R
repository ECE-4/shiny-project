# Import libraries
library(shiny)
library(dplyr)
library(data.table)
library(stringr)
library(ggplot2)
library(R.utils)

# Function that import the data of a city
prepare_data <- function(city, date) {
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
    listing_url <- paste0("http://data.insideairbnb.com/spain/vc/valencia/",date,"/data/listings.csv.gz")
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
  columns_listings <- c(
    "city", "id", "date", "neighbourhood_cleansed",
    "latitude", "longitude",
    "property_type", "room_type", "accommodates", "bedrooms",
    "beds", "price", "minimum_nights", "maximum_nights"
  )
  
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
    mutate(available = ifelse(available == "t", 1, 0))
  
  ## clean price column and transform to numeric
  calendar <- calendar %>%
    mutate(
      price = str_replace(price, "\\$", ""),
      adjusted_price = str_replace(adjusted_price, "\\$", "")
    )
  calendar <- calendar %>%
    mutate(
      price = str_replace(price, ",", ""),
      adjusted_price = str_replace(adjusted_price, ",", "")
    )
  calendar <- calendar %>%
    mutate(
      price = as.numeric(price),
      adjusted_price = as.numeric(adjusted_price)
    )
  
  ## calculate estimated revenue for upcoming day
  calendar <- calendar %>%
    mutate(revenue = price * (1 - available))
  
  ## calculate availability, price, revenue for next 30, 60 days ... for each listing_id
  calendar <- calendar %>%
    group_by(listing_id) %>%
    summarise(
      availability_30 = sum(available[day_nb <= 30], na.rm = TRUE),
      price_30 = mean(price[day_nb <= 30 & available == 0], na.rm = TRUE),
      revenue_30 = sum(revenue[day_nb <= 30], na.rm = TRUE),
    )
  
  listings_cleansed <- listings %>% left_join(calendar, by = c("id" = "listing_id"))
  return(listings_cleansed)
}

# Function that runs the entire app
start_app <- function() {
  # France
  if (!exists("bordeaux1")) bordeaux1 <<- prepare_data("bordeaux", "2020-09-19")
  if (!exists("bordeaux2")) bordeaux2 <<- prepare_data("bordeaux", "2020-08-29")
  if (!exists("bordeaux3")) bordeaux3 <<- prepare_data("bordeaux", "2020-07-25")
  
  France <<- rbind(select(bordeaux1, longitude, latitude),
                   select(bordeaux2, longitude, latitude),
                   select(bordeaux3, longitude, latitude))
  
  # Netherlands
  if (!exists("amsterdam1")) amsterdam1 <<- prepare_data("amsterdam", "2020-09-09")
  if (!exists("amsterdam2")) amsterdam2 <<- prepare_data("amsterdam", "2020-08-18")
  if (!exists("amsterdam3")) amsterdam3 <<- prepare_data("amsterdam", "2020-07-09")
  
  Netherlands <<- rbind(select(amsterdam1, longitude, latitude),
                        select(amsterdam2, longitude, latitude),
                        select(amsterdam3, longitude, latitude))
  
  # Germany
  if (!exists("berlin1")) berlin1 <<- prepare_data("berlin", "2020-08-30")
  if (!exists("berlin2")) berlin2 <<- prepare_data("berlin", "2020-06-13")
  if (!exists("berlin3")) berlin3 <<- prepare_data("berlin", "2020-05-14")
  
  Germany <<- rbind(select(berlin1, longitude, latitude),
                    select(berlin2, longitude, latitude),
                    select(berlin3, longitude, latitude))
  
  # Belgium
  if (!exists("brussels1")) brussels1 <<- prepare_data("brussels", "2020-06-15")
  if (!exists("brussels2")) brussels2 <<- prepare_data("brussels", "2020-05-17")
  if (!exists("brussels3")) brussels3 <<- prepare_data("brussels", "2020-04-19")
  
  ## add Ghent
  #if(!exists("ghent1")) ghent1 <<- prepare_data("ghent","2020-07-28")
  #if(!exists("ghent2")) ghent2 <<- prepare_data("ghent","2020-06-18")
  #if(!exists("ghent3")) ghent3 <<- prepare_data("ghent","2020-05-24")
  
  ## add Antwerp
  if (!exists("antwerp1")) antwerp1 <<- prepare_data("antwerp", "2020-06-22")
  if (!exists("antwerp2")) antwerp2 <<- prepare_data("antwerp", "2020-05-27")
  if (!exists("antwerp3")) antwerp3 <<- prepare_data("antwerp", "2020-04-28")
  
  #Belgium <<- rbind(select(brussels1, longitude, latitude),
  #                  select(brussels2, longitude, latitude),
  #                  select(brussels3, longitude, latitude),
  #                  select(antwerp1, longitude, latitude),
  #                  select(antwerp2, longitude, latitude),
  #                  select(antwerp3, longitude, latitude),)
  
  # Spain
  # if (!exists("malaga1")) malaga1 <<- prepare_data("malaga","2020-06-30")
  # if (!exists("malaga2")) malaga2 <<- prepare_data("malaga","2020-05-31")
  # if (!exists("malaga3")) malaga3 <<- prepare_data("malaga","2020-04-30")
  
  ## add Valencia
  if (!exists("valencia1")) valencia1 <<- prepare_data("valencia", "2020-08-30")
  if (!exists("valencia2")) valencia2 <<- prepare_data("valencia", "2020-06-30")
  if (!exists("valencia3")) valencia3 <<- prepare_data("valencia", "2020-05-31")
  
  Spain <- rbind(select(valencia1, longitude, latitude),
                 select(valencia2, longitude, latitude),
                 select(valencia3, longitude, latitude))
  
  # Italy
  
  ## add Girona
  if (!exists("girona1")) girona1 <<- prepare_data("girona", "2020-06-29")
  if (!exists("girona2")) girona2 <<- prepare_data("girona", "2020-05-28")
  if (!exists("girona3")) girona3 <<- prepare_data("girona", "2020-04-30")
  
  ## add Venice
  if (!exists("venice1")) venice1 <<- prepare_data("venice", "2020-09-08")
  if (!exists("venice2")) venice2 <<- prepare_data("venice", "2020-08-21")
  #if (!exists("venice3")) venice3 <<- prepare_data("venice", "2020-07-17")
  
  ## add Florence
  if (!exists("florence1")) florence1 <<- prepare_data("florence", "2020-08-31")
  #if (!exists("florence2")) florence2 <<- prepare_data("florence", "2020-07-23")
  if (!exists("florence3")) florence3 <<- prepare_data("florence", "2020-06-19")
  
  #Italy <- rbind(select(girona1, longitude, latitude),
   #              select(girona2, longitude, latitude),
    #             select(girona3, longitude, latitude),
     #            select(venice1, longitude, latitude),
      #           select(venice2, longitude, latitude),
       #          #select(venice3, longitude, latitude),
        #         select(florence1, longitude, latitude),
          #     #select(florence2, longitude, latitude),
          #       select(florence3, longitude, latitude),)
}

start_app()

shinyServer(function(input, output) {
  ## Tab 1
  output$plotFrance <- renderPlot({
    ggplot(bordeaux1, aes_string(input$features)) +
      geom_histogram(
        breaks = seq(min(input$sliderX[1]), max(input$sliderX[2]), by = 1),
        col = "blue",
        fill = "blue",
        alpha = .2
      ) +
      ylim(input$sliderY[1], input$sliderY[2]) +
      ggtitle("France")
  })

  output$plotSpain <- renderPlot({
    ggplot(bordeaux1, aes_string(input$features)) +
      geom_histogram(
        breaks = seq(min(input$sliderX[1]), max(input$sliderX[2]), by = 1),
        col = "red",
        fill = "red",
        alpha = .2
      ) +
      ylim(input$sliderY[1], input$sliderY[2]) +
      ggtitle("Spain")
  })

  output$plotItaly <- renderPlot({
    ggplot(bordeaux1, aes_string(input$features)) +
      geom_histogram(
        breaks = seq(min(input$sliderX[1]), max(input$sliderX[2]), by = 1),
        col = "green",
        fill = "green",
        alpha = .2
      ) +
      ylim(input$sliderY[1], input$sliderY[2]) +
      ggtitle("Italy")
  })

  output$plotGermany <- renderPlot({
    ggplot(berlin2, aes_string(input$features)) +
      geom_histogram(
        breaks = seq(min(input$sliderX[1]), max(input$sliderX[2]), by = 1),
        col = "yellow",
        fill = "yellow",
        alpha = .2
      ) +
      ylim(input$sliderY[1], input$sliderY[2]) +
      ggtitle("Germany")
  })

  output$plotNetherlands <- renderPlot({
    ggplot(amsterdam1, aes_string(input$features)) +
      geom_histogram(
        breaks = seq(min(input$sliderX[1]), max(input$sliderX[2]), by = 1),
        col = "orange",
        fill = "orange",
        alpha = .2
      ) +
      ylim(input$sliderY[1], input$sliderY[2]) +
      ggtitle("Netherlands")
  })

  output$plotBelgium <- renderPlot({
    ggplot(brussels1, aes_string(input$features)) +
      geom_histogram(
        breaks = seq(min(input$sliderX[1]), max(input$sliderX[2]), by = 1),
        col = "black",
        fill = "black",
        alpha = .2
      ) +
      ylim(input$sliderY[1], input$sliderY[2]) +
      ggtitle("Belgium")
  })


  ## Tab 2
  output$plot10 <- renderPlot({
    ggplot(berlin2, aes(revenue_30)) +
      geom_histogram(breaks=seq(min(input$sliderX[1]), max(input$sliderX[2]), by=1), 
                     col="yellow",
                     fill="yellow", 
                     alpha=.2) + 
      ylim(input$sliderY[1], input$sliderY[2]) + 
      ggtitle("Berlin")
  })
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(
        clusterOptions = markerClusterOptions(),
        lng = get(input$cityMap)$longitude, 
        lat = get(input$cityMap)$latitude
      )
  })
})
