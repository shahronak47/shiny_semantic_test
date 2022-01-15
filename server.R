library(shiny)
library(shiny.semantic)
library(geosphere)
library(dplyr)
library(waiter)

#Read data from github
ships <- readRDS(url('https://github.com/shahronak47/shiny_semantic_test/raw/main/ships.rds', method="libcurl"))

server <- function(input, output, session) {
  Sys.sleep(2)
  waiter_hide()
  
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
  
  #Filter rows for selected name and type and keep the farthest row (first and last row)
  data <- reactive({
    req(input$ship_type_dropdown, input$ship_name_dropdown)
    ships %>% 
      dplyr::filter(ship_type == input$ship_type_dropdown, SHIPNAME == input$ship_name_dropdown) %>%
      arrange(LAT, LON) %>%
      slice(1L, dplyr::n())
  })
  
  #calculate distance based on latitude and longitude
  dist <- reactive({
    as.numeric(with(data(), distm(c(LON[1], LAT[1]), c(LON[2], LAT[2]), fun = distHaversine)))
  })
  
  #Plot the two points on map with a line and corresponding label showing the distance
  output$map <- renderLeaflet({
    leaflet()%>%
      addTiles() %>%
      addPolylines(data = data(), lng = ~LON, lat = ~LAT, label = paste0('Dist = ', round(dist(), 2)),
                   labelOptions = labelOptions(noHide = TRUE))
  })
  
  output$text <- reactive({sprintf('<font size = 4><i>Maximum distance for Ship Type %s and name %s is %s</i></font>', 
                                   input$ship_type_dropdown, input$ship_name_dropdown, round(dist(), 2))})
}

server
