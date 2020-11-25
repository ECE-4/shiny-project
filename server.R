library(shiny)
library(ggplot2)
shinyServer(function(input, output) {
  ## Tab 1

  output$plotFrance <- renderPlot(
    if ("1" %in% {
      input$city
    }) {
      ggplot(bordeaux1, aes(availability_30)) +
        geom_histogram(
          breaks = seq(min(input$sliderX[1]), max(input$sliderX[2]), by = 1),
          col = "purple",
          fill = "purple",
          alpha = .2
        ) +
        ylim(input$sliderY[1], input$sliderY[2]) +
        ggtitle("Bordeaux")
    }
  )
  
  output$plotSpain <- renderPlot(
    if ("2" %in% {
      input$city
    }) {
      
    }
  )
  
  output$plotItaly <- renderPlot(
    if ("3" %in% {
      input$city
    }) {
      
    }
  )

  output$plotGermany <- renderPlot(
    if ("4" %in% {
      input$city
    }) {
      ggplot(berlin2, aes(availability_30)) +
        geom_histogram(
          breaks = seq(min(input$sliderX[1]), max(input$sliderX[2]), by = 1),
          col = "yellow",
          fill = "yellow",
          alpha = .2
        ) +
        ylim(input$sliderY[1], input$sliderY[2]) +
        ggtitle("Berlin")
    }
  )

  output$plotNetherlands <- renderPlot(
    if ("5" %in% {
      input$city
    }) {
      ggplot(amsterdam1, aes(availability_30)) +
        geom_histogram(
          breaks = seq(min(input$sliderX[1]), max(input$sliderX[2]), by = 1),
          col = "red",
          fill = "red",
          alpha = .2
        ) +
        ylim(input$sliderY[1], input$sliderY[2]) +
        ggtitle("Amsterdam")
    }
  )

  output$plotBelgium <- renderPlot(
    if ("6" %in% {
      input$city
    }) {
      ggplot(brussels1, aes(availability_30)) +
        geom_histogram(
          breaks = seq(min(input$sliderX[1]), max(input$sliderX[2]), by = 1),
          col = "green",
          fill = "green",
          alpha = .2
        ) +
        ylim(input$sliderY[1], input$sliderY[2]) +
        ggtitle("Brussels")
    }
  )
  ## Tab 2
})
