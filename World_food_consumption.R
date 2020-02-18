
library(shiny)
library(tidyverse)
library(shiny)
library(plotly)
library(maps)

food_consumption <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-02-18/food_consumption.csv')

world <- map_data("world")

world <- world %>% 
  left_join(food_consumption, by = c('region' = 'country')) %>%
  filter(region!="Antarctica") %>%
  mutate(food_category = as.factor(food_category))

ui <- fluidPage(
   
   titlePanel("Annual food consumption (kilograms per person)"),
   
   sidebarLayout(
      sidebarPanel(
        selectInput("food_category",
                     "Choose a food category",
                     choices = levels(world$food_category)
      ),
      p("Data for this interactive visualisation was drawn from the 'Food's Carbon Footprint' dataset from nu3, and contributed by Kasia Kulma."),
      tags$a(href="https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-02-18/readme.md","Click here for more information about the data")),
      # Show a plot of the generated distribution
      mainPanel(
        plotlyOutput("worldPlot")
      )
   )
)

server <- function(input, output) {
   
   output$worldPlot <- renderPlotly({
     world %>%
       filter(food_category %in% input$food_category) %>%
     ggplot(aes(x = long, y = lat, label=region)) +
       geom_polygon(aes( group = group, fill = consumption)) +
       theme_void()
   })
}

shinyApp(ui = ui, server = server)

