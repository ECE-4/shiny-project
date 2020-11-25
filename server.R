library(shiny)
library(ggplot2)
shinyServer(function(input, output) {
  ## Tab 1

  output$plotFrance <- renderPlot({
    ggplot(bordeaux1, aes_string(input$features)) +
      geom_histogram(
        breaks = seq(min(input$sliderX[1]), max(input$sliderX[2]), by = 1),
        col = "purple",
        fill = "purple",
        alpha = .2
      ) +
      ylim(input$sliderY[1], input$sliderY[2]) +
      ggtitle("Bordeaux")
  })

  output$plotSpain <- renderPlot({

  })

  output$plotItaly <- renderPlot({

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
      ggtitle("Berlin")
  })

  output$plotNetherlands <- renderPlot({
    ggplot(amsterdam1, aes_string(input$features)) +
      geom_histogram(
        breaks = seq(min(input$sliderX[1]), max(input$sliderX[2]), by = 1),
        col = "red",
        fill = "red",
        alpha = .2
      ) +
      ylim(input$sliderY[1], input$sliderY[2]) +
      ggtitle("Amsterdam")
  })

  output$plotBelgium <- renderPlot({
    ggplot(brussels1, aes_string(input$features)) +
      geom_histogram(
        breaks = seq(min(input$sliderX[1]), max(input$sliderX[2]), by = 1),
        col = "green",
        fill = "green",
        alpha = .2
      ) +
      ylim(input$sliderY[1], input$sliderY[2]) +
      ggtitle("Brussels")
  })


  ## Tab 2
  #output$text <- renderPrint({ input$cityMap })

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
