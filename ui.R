library(shiny)
library(shiny.semantic)
library(leaflet)
library(waiter)

#Read data from github
ships <- readRDS(url('https://github.com/shahronak47/shiny_semantic_test/raw/main/ships.rds', method="libcurl"))

#Get unique ship types removing "Unspecified" ship
unique_ship_type <- unique(ships$ship_type[ships$ship_type != 'Unspecified'])

ui <- semanticPage(
  br() ,br(), 
  titlePanel("Ship Data"),
  br() ,br(), 
  useWaiter(), 
  waiter_show_on_load(spin_whirly()),
  sidebar_layout(
    sidebar_panel(
         dropdown_input("ship_type_dropdown", unique_ship_type, value = "Cargo", type = "selection"),
         dropdown_input("ship_name_dropdown", "ship_name_dropdown", value = "KAROLI", type = "selection")
      ),
  main_panel(
    leafletOutput(outputId = "map", width="100%"),
    br(), br(), br(),
    
    uiOutput("text"),
    br(), br(), br(),
  ), mirrored = TRUE
  ),  


  
)

ui