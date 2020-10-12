#Load libraries
library(shiny)
library(shiny.semantic)
library(leaflet)

#ships <- read.csv('Downloads/shiny_semantic_test/ships.csv')

#Get unique ship types removing "Unspecified" ship
unique_ship_type <- unique(ships$ship_type[ships$ship_type != 'Unspecified'])

ui <- semanticPage(
  title = "Dropdown example",
  
  HTML("<p><b>Selected ship type:\n\n\n</b></p>"),
  
  dropdown_input("ship_type_dropdown", unique_ship_type, value = "Cargo", type = "selection"),
  
  dropdown_input("ship_name_dropdown", "ship_name_dropdown", type = "selection"),
  
  textOutput("selected_ship"),
  
  
  leafletOutput(outputId = "map", width="100%")
  
)


server <- shinyServer(function(input, output, session) {
  #Print the selected drop down from ship_type_dropdown
  output$selected_ship <- renderText(input$ship_type_dropdown)
  
  #Filter the relevant ship names based on ship type selected.  
  lists <- reactive({
    unique(ships$SHIPNAME[ships$ship_type == input$ship_type_dropdown])
  })
  
   #Change the values in ship_name dropdown based on ship type selected
   observe({
      update_dropdown_input(session, "ship_name_dropdown", value = lists()[1], choices =   lists())
  })
   
   data <- reactive({ships %>% 
     filter(ship_type == input$ship_type_dropdown, SHIPNAME == input$ship_name_dropdown) %>%
     arrange(LAT, LON) %>%
     slice(1L, n())
     })
   
   output$map <- renderLeaflet({
     leaflet()%>%
       addTiles() %>%
       addPolylines(data = data(), lng = ~LON, lat = ~LAT)
   })
   

  
})

shinyApp(ui = ui, server = server)



