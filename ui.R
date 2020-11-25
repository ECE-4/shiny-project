library(shiny)
library(leaflet)
library(ggplot2)
shinyUI(fluidPage(
  titlePanel("Airbnb Data Explorator"),
  mainPanel(
    tabsetPanel(
      type = "tabs",
      tabPanel(
        "Tab 1",
        sidebarLayout(
          sidebarPanel(
            h3("Settings"),
            sliderInput("sliderX", "Slide the X axis", 0, 30, value = c(0, 30)),
            sliderInput("sliderY", "Slide the Y axis", 0, 20000, value = c(0, 20000)),
            checkboxGroupInput("city",
              h3("Choose Countries you want to compare"),
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
                "Histogram" = 1,
                "Boxplot" = 2,
                "Average" = 3,
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
          )
        )
      ),
      tabPanel(
        "Tab 2",
        sidebarLayout(
          sidebarPanel(
            h3("Settings"),
            selectInput("cityMap",
              h3("Choose Country you want to show"),
              choices = list(
                "France" = "France",
                "Spain" = "Spain",
                "Italy" = "Italy",
                "Germany" = "Germany",
                "Netherlands" = "Netherlands",
                "Belgium" = "Belgium"
              ),
              selected = 1
            )
          ),
          mainPanel(
            h1("Deep dive into one city"),
            leafletOutput("mymap"),
          )
        )
      ),
      tabPanel(
        "Tab 3",
        sidebarLayout(
          sidebarPanel(
            h4("Summary:"),
            br(),
            p("1. Installation"),
            #br(),
            p("2. Use of the App"),
            #br(),
            p("3. Functions", em("(UI)")),
            
            p("4. Functions", em("(Server)")),
            
            p("5. Functions", em("(App)")),
          ),
          mainPanel(
            #width = 30,
            h1("Documentation of our shiny App"),
            br(),
            br(),
            h3("1. Launch the App", em("(Installation)")),
            br(),
            p("a) Set the ",strong("working directory")," in order to be in the folder containing ui.R and server.R."),
            p("b) Make sure that you have",strong(" shiny installed")," on your computer, if not install it by running :", code("install::packages('shiny')")),
            p("c) In the console, run the following line :", code("runApp()")),
            p("d) Your app should be running locally ! :)"),
            br(),
            h3("2. Use the App"),
            em("Welcome to our lengendary App"),
            br(),
            br(),
            h4(em("Tab 1")),
            p("Here, you can appreciate some graphics that analyse Airbnb’s housing in differents cities in Europe (France, Germany, Netherlands,...)."),
            p("You can:"),
            p("- Slide the X axis and the Y axis by moving the slide bar : it will change the scale"),
            p("- Choose Countries you want to compare : it will load data from the country between France, Germany, Netherlands … and display it !"),
            #p("- Select the aggregation : here you can select the aggregation that you want between Average, Median, Histogram, Density, Boxplot and... display it !"),
            p("- Select the feature : here you can select the feature that you want between the availability of the hostings over the last 30 days, the revenu of the hostings and the price of the hostings… and display it !"),
            br(),
            h4(em("Tab 2")),
            p("Here, you can play with an integrated map (with leaflet)."),
            p("Select the country that you want, and zoom to see where AirBnb hid some beautiful hostings."),
            br(),
            h4(em("Tab 3")),
            p("Here we are : this is the documentation !"),
            br(), 
            h3("3. Mains Functions of the App"),
            em("The libraries used are correlated to ggplot and shiny. "),
            br(),
            h4(em("UI:")),
            p("- shinyUI : creates the UI of the apps"),
            p("- tabsetPanel : separes the screen in different tabs"),
            p("- tabPanel : creates one tab and allows us to configure it "),
            p("- sidebar Layout : allows us to organise the space in the tab"),
            p("- selectInput : this is the input slot that will be used to access the value"),
            p("- ConditionalPanel : allows us to display the graph only if the country is selected (and so that there is something to display)"),
            br(),
            h4(em("Server:")),
            p("- output$plotCountry <- renderPlot : output variable to read the plot/image from"),
            p("- ggplot and its libraries"),
            br(),
            h4(em("App:")),
            p("- prepare data : it allows to load the data (cities from countries) "),
            p("- columns_listings : it allows us to select only the columns that we want in order to process the data"),
            p("- listings : it has the dataset with most of the information "),
            p("- calendar : it completes listings with others informations : the revenu, the price and the availability over the last 3 days"),
            
          )
        )
      )
    )
  )
))
