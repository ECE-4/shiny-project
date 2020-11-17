library(shiny)
shinyUI(fluidPage(
  titlePanel("Finale Project"),
  sidebarLayout(
    sidebarPanel(
      h3("Sidebar Text")
    ),
    mainPanel(
      h3("Main Panel Text")
    )
  )
))

