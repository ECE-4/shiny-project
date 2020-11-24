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
                         choices = list("France" = 1,
                                        "Spain" = 2,
                                        "Italy" = 3,
                                        "Germany" = 4,
                                        "Netherlands" = 5,
                                        "Belgium" = 6),
                         selected = 1),
      selectInput("aggregation",
                  h3("Select the aggregation"),
                  choices = list("Average" = 1,
                                 "Median" = 2,
                                 "Histogram" = 3,
                                 "Density" = 4,
                                 "Boxplot" = 5),
                  selected = 1),
      checkboxGroupInput("features",
                         h3("Select the features"),
                         choices = list("Availability over last 30 days" = 1,
                                        "Revenu" = 2,
                                        "Price" = 3),
                         selected = 1),
      #submitButton("Submit")
    ),
    mainPanel(
      tabsetPanel( type = "tabs",
                   tabPanel("Tab 1",
                            h1("Compare different cities"),
                            plotOutput(outputId = "plot5"),
                            plotOutput(outputId = "plot6"),
                            plotOutput(outputId = "plot7"),
                            plotOutput(outputId = "plot8"),
                            ),
                   tabPanel("Tab 2",
                            h1("Deep dive into one city"),
                   )
      )
    )
  )
))

