library(leaflet)

out_dat<-read.csv("C:/Users/Mary Shelley/Documents/ghi_data/out_dat.csv")

m<- leaflet(out_dat) %>%
    #addTiles() %>%   # Labels in local language
    #addProviderTiles(providers$Esri.NatGeoWorldMap)%>%  # Too busy
    #addProviderTiles(providers$Esri.WorldStreetMap)%>%  # Nice, colorful
    addProviderTiles(providers$CartoDB.Voyager)%>% # Stret map with English labels     
    fitBounds(0,-35,0,75) %>%
    addMarkers(
      lng=~long,lat=~lat,
      popup=~as.character(htmlEscape(proj_title)),
      clusterOptions = markerClusterOptions())
  