#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
library(dplyr)
library(shiny)
library(leaflet)
library(htmltools)

# Create leaflet map (pasted from ghi_leaflet.R)

out_dat<-read.csv('C:/Users/Mary Shelley/Documents/ghi_data/out_dat.csv') %>%
         select(c('ghi_ID','Department','proj_title','loc_name','lat','long'))

# Shiny/leaflet

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()


ui <- fluidPage(
    titlePanel("Global Health Projects"),
    leafletOutput("mymap"),
)

server <- function(input, output, session) {
    output$mymap <- renderLeaflet({leaflet(out_dat) %>%
            addProviderTiles(providers$CartoDB.Voyager)%>% # Stret map with English labels     
            fitBounds(0,-35,0,75) %>%
            addMarkers(
                lng=~long,lat=~lat,
                popup=~as.character(htmlEscape(proj_title)),
                clusterOptions = markerClusterOptions())})
}

shinyApp(ui, server)

