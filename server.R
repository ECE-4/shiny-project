library(shiny)
library(ggplot2)
shinyServer(function(input, output){
  output$text <- renderText(input$slider1)
  output$plot1 <- renderPlot({
    number_of_points <- 1000
    minX <- 0
    maxX <- 100
    minY <- 0
    maxY <- 5000
    dataX <- runif(number_of_points, minX, maxX)
    dataY <- runif(number_of_points, minY, maxY)
    xlabel <- "X Axis"
    ylabel <- "Y Axis"
    main <- "Average Availability"
    plot(dataX, dataY, xlab = xlabel, ylab = ylabel, main = main)
   })
  output$plot2 <- renderPlot({
    number_of_points <- 500
    minX <- 0
    maxX <- 100
    minY <- 0
    maxY <- 100
    dataX <- runif(number_of_points, minX, maxX)
    dataY <- runif(number_of_points, minY, maxY)
    xlabel <- "X Axis"
    ylabel <- "Y Axis"
    main <- "Average Revenue"
    plot(dataX, dataY, xlab = xlabel, ylab = ylabel, main = main)
  })
  output$plot3 <- renderPlot({
    ggplot(amsterdam1, aes(x=city, y=availability_30)) + 
      geom_boxplot() + stat_summary(fun=mean ,geom="point",color="red", aes(x=city, y=availability_30))
  })
  output$plot4 <- renderPlot({
    ggplot(berlin1, aes(x=city, y=availability_30)) + 
      geom_boxplot() + stat_summary(fun=mean ,geom="point",color="red", aes(x=city, y=availability_30))
  })
})