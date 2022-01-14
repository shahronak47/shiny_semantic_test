library(shiny)
library(shiny.semantic)
library(leaflet)

#Read data from github
ships <- readRDS(url('https://github.com/shahronak47/shiny_semantic_test/raw/main/ships.rds', method="libcurl"))

#Get unique ship types removing "Unspecified" ship
unique_ship_type <- unique(ships$ship_type[ships$ship_type != 'Unspecified'])

ui <- semanticPage(
  title = "Ship Data",
  
  HTML("<p><b>Select ship type: &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
       Select ship name:\n\n\n </b></p>"),
  
  
  dropdown_input("ship_type_dropdown", unique_ship_type, value = "Cargo", type = "selection"),
  
  HTML('&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;'),
  dropdown_input("ship_name_dropdown", "ship_name_dropdown", value = "KAROLI", type = "selection"),
  
  br(), br(), br(),
  
  
  leafletOutput(outputId = "map", width="100%"), 
  br(), br(), br(),
  uiOutput("text")
  
)

polished::secure_ui(ui)