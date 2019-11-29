library(leaflet)

m<- leaflet(out_dat) %>%
    addTiles() %>%
    addMarkers(lng=~long,lat=~lat)
  