#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
library(dplyr)
library(shiny)
library(leaflet)
library(htmltools)

out_dat_pub<-read.csv('out_dat_pub.csv') 

# Shiny/leaflet

ui <- fluidPage(
    titlePanel("Global Health Projects"),
    leafletOutput("mymap"),
)

server <- function(input, output, session) {
    output$mymap <- renderLeaflet({leaflet(out_dat_pub) %>%
            addProviderTiles(providers$CartoDB.Voyager)%>% # Stret map with English labels     
           # fitBounds(0,-35,0,75) %>%
            addMarkers(
                lng=~long,lat=~lat,
                popup=~as.character(htmlEscape(proj_title)),
                clusterOptions = markerClusterOptions())})
}

shinyApp(ui, server)

