library(shiny)
library(ggplot2)
shinyUI(fluidPage(
  titlePanel("Airbnb Data Explorator"),
  sidebarLayout(
    sidebarPanel(
      h3("Sidebar Text"),
      em("Emphasized Text"),
      sliderInput("sliderX", "Slide the X axis", 0, 30, value = c(0, 30)),
      sliderInput("sliderY", "Slide the Y axis", 0, 20000, value = c(0, 20000)),
      checkboxGroupInput("city",
        h3("Choose Cities you want to compare"),
        choices = list(
          "France" = 1,
          "Spain" = 2,
          "Italy" = 3,
          "Germany" = 4,
          "Netherlands" = 5,
          "Belgium" = 6
        ),
        selected = 1
      ),
      selectInput("aggregation",
        h3("Select the aggregation"),
        choices = list(
          "Average" = 1,
          "Median" = 2,
          "Histogram" = 3,
          "Density" = 4,
          "Boxplot" = 5
        ),
        selected = 1
      ),
      selectInput("features",
        h3("Select the features"),
        choices = list(
          "Availability over last 30 days" = "availability_30",
          "Revenu" = "revenue_30",
          "Price" = "price_30"
        ),
        selected = 1
      )
    ),
    mainPanel(
      textOutput("text"),
      tabsetPanel(
        type = "tabs",
        tabPanel(
          "Tab 1",
          h1("Compare different cities"),
          conditionalPanel(
            "input.city.indexOf('1') > -1",
            plotOutput(outputId = "plotFrance")
          ),
          conditionalPanel(
            "input.city.indexOf('2') > -1",
            plotOutput(outputId = "plotSpain")
          ),
          conditionalPanel(
            "input.city.indexOf('3') > -1",
            plotOutput(outputId = "plotItaly")
          ),
          conditionalPanel(
            "input.city.indexOf('4') > -1",
            plotOutput(outputId = "plotGermany")
          ),
          conditionalPanel(
            "input.city.indexOf('5') > -1",
            plotOutput(outputId = "plotNetherlands")
          ),
          conditionalPanel(
            "input.city.indexOf('6') > -1",
            plotOutput(outputId = "plotBelgium")
          )
        ),
        tabPanel(
          "Tab 2",
          h1("Deep dive into one city"),
          plotOutput(outputId = "plot10"),
          plotOutput(outputId = "plot11")
        )
      )
    )
  )
))
