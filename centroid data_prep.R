library(dplyr)
library(stringr)
library(jsonlite)
library(httr)
library(tidyr)

# Read project data
ghi<-read.csv('C:/Users/Mary Shelley/Documents/ghi/ghi_data_mks.csv')

# Read world centroids from CIESEN
centroids<-read.csv('C:/Users/Mary Shelley/Documents/ghi/centroids/gl_centroids.csv')

# Harmonize city/state formatting and drop uneeded vars
ghi<-mutate(ghi,ghi_ID=seq.int(nrow(ghi)))

cent<-select(centroids,c("X.ADMINID.","X.NAME1.","X.COUNTRYNM.","X.LAT_CEN.","X.LONG_CEN."))

cent2<-mutate(cent, city=str_remove(str_remove(cent$X.NAME1., "[']"),"'")) %>%     #Remove ' from city and rename
       mutate(country=str_remove(str_remove(cent$X.COUNTRYNM., "[']"),"'")) %>%    #Remove ' from country and rename
       rename("cent_ID" = "X.ADMINID.","lat"="X.LAT_CEN.") %>%                     #Rename lat
       mutate("long"=as.numeric(as.character(X.LONG_CEN.))) %>%                    #Convert long to numeric (some weird country spillover in a couple records)           
       select(-c("X.NAME1.","X.COUNTRYNM.","X.LONG_CEN."))                         #Drop unneeded vars

## Multiple points for same city (b/c grids span multiple parts of a city); find average for each
city_cent <- group_by(cent2,city,country)  %>%
             summarize(x=mean(long), y=mean(lat))

#write.csv(city_cent, "C:/Users/Mary Shelley/Documents/ghi/city_cent.csv")
#city_cent<-read.csv("C:/Users/Mary Shelley/Documents/ghi/city_cent.csv")

city_cent2 <- city_cent %>% filter(!is.null(x) & !is.null(y) & x!="NA")

# Merge
ghi_l<-mutate(ghi,city=tolower(city),country=tolower(country))
ungroup(city_cent)
city_cent_l<-mutate(city_cent,city=tolower(city), country=tolower(country))
dat <- left_join(ghi_l,city_cent_l, by=c("city","country"))


### New approach - use google api
test<-select(ghi,c('city','country'))

comp_city=as.character(test[1,1])
comp_country=as.character(test[1,2])

urlp1='https://maps.googleapis.com/maps/api/geocode/json?components=administrative_area:'

url=str_c(urlp1,comp_city,'|country:',comp_country,urlp2)
url

tmp<-content(GET(url))
tmp2<-fromJSON(toJSON(tmp$results)) 

tmp2$formatted_address
tmp2$geometry$location$lat[[1]]
tmp2$geometry$location$lng[[1]]

val<- fromJSON(toJSON(tmp$results)) %>%
      select(c('formatted_address',geometry$location$lat[[1]]))
               
               ,geometry$location$lng))


#GET('https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyCbwDDMbwSaoj_xBNueqzpnioP3M158_jo')

#https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Aarhus+Denmark&key=


