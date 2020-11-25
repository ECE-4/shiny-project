library(shiny)
library(ggplot2)
shinyServer(function(input, output){
  ## Tab 1
  output$text <- renderText(input$slider1)
  output$plot5 <- renderPlot({
    ggplot(amsterdam1, aes(availability_30)) +
      geom_histogram(breaks=seq(min(input$sliderX[1]), max(input$sliderX[2]), by=1), 
                     col="red",
                     fill="red", 
                     alpha=.2) + 
      ylim(input$sliderY[1], input$sliderY[2]) + 
      ggtitle("Amsterdam")
  })
  output$plot6 <- renderPlot({
    ggplot(brussels1, aes(availability_30)) +
      geom_histogram(breaks=seq(min(input$sliderX[1]), max(input$sliderX[2]), by=1),
                     col="green", 
                     fill="green", 
                     alpha=.2) + 
      ylim(input$sliderY[1], input$sliderY[2]) + 
      ggtitle("Brussels")
  })
  output$plot7 <- renderPlot({
    ggplot(bordeaux1, aes(availability_30)) +
      geom_histogram(breaks=seq(min(input$sliderX[1]), max(input$sliderX[2]), by=1), 
                     col="purple", 
                     fill="purple", 
                     alpha=.2) + 
      ylim(input$sliderY[1], input$sliderY[2]) + 
      ggtitle("Bordeaux")
  })
  output$plot8 <- renderPlot({
    ggplot(berlin2, aes(availability_30)) +
      geom_histogram(breaks=seq(min(input$sliderX[1]), max(input$sliderX[2]), by=1), 
                     col="yellow", 
                     fill="yellow", 
                     alpha=.2) + 
      ylim(input$sliderY[1], input$sliderY[2]) + 
      ggtitle("Berlin")
  })
  ## Tab 2
})
