#Load libraries
library(shiny)
library(shiny.semantic)
#ships <- read.csv('Downloads/shiny_semantic_test/ships.csv')

#Get unique ship types removing "Unspecified" ship
unique_ship_type <- unique(ships$ship_type[ships$ship_type != 'Unspecified'])

ui <- semanticPage(
  title = "Dropdown example",
  
  HTML("<p><b>Selected ship type:\n\n\n</b></p>"),
  
  dropdown_input("ship_type_dropdown", unique_ship_type, value = "Cargo", type = "selection multiple"),
  textOutput("selected_ship")
  
)


server <- shinyServer(function(input, output, session) {
  output$selected_ship <- renderText(paste(input[["ship_type_dropdown"]], collapse = ", "))
  
})

shinyApp(ui = ui, server = server)