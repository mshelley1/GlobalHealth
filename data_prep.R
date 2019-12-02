# File ingests, geocodes, and outputs data on location of SPH GHI projects
# Note: an API key must be provided for Google's geocoding service (around line 22)

library(dplyr)
library(stringr)
library(jsonlite)
library(httr)
library(tidyr)
library(xml2)

# Read project data
ghi<- read.csv('C:/Users/Mary Shelley/Documents/ghi_data/ghi_data_mks.csv')

# Create unique ID
ghi<-mutate(ghi,ghi_ID=seq.int(nrow(ghi)))

# Keep only necessary columns for geocoding and remerging
sub_dat<-select(ghi,c('ghi_ID','city','country'))

# Create URL for looping
urlp1='https://maps.googleapis.com/maps/api/geocode/json?components=administrative_area:'
urlp2=',&key='  # Need to put in API key

# Create df to hold cummulative results
sub_loc<-data.frame(ghi_ID=numeric(),loc_name=character(),lat=numeric(),long=numeric())

# Loop through rows to geocode
for (i in 1:nrow(sub_dat)) {
  comp_city=str_trim(as.character(sub_dat[i,2]))
  comp_country=str_trim(as.character(sub_dat[i,3]))
  url=str_c(urlp1,comp_city,'|country:',comp_country,urlp2) #create url to call
  
  tmp<-content(GET(url)) #call url and get content
  tmp2<-fromJSON(toJSON(tmp$results)) #parse results

 tmp_ID=sub_dat[i,1]
 #print(tmp_ID)
 
  # Create a row containing current results to bind to cummulative df
   if (length(tmp2) > 0) {  #doesn't apply if no match; prevent error
      x<-data.frame(ghi_ID=tmp_ID,
                loc_name=as.character(tmp2$formatted_address),
                lat=as.numeric(tmp2$geometry$location$lat[[1]]),
                long=as.numeric(tmp2$geometry$location$lng[[1]]))
      sub_loc<-rbind(sub_loc,x) 
      remove(x)
  }
}

# Recombine with orginal data by gh_ID
out_dat <- merge(ghi,sub_loc,by='ghi_ID')

#--# Write data #---#
# full data
#write.csv(out_dat,'C:/Users/Mary Shelley/Documents/ghi_data/out_dat.csv')

# Smaller data set for publishing
# select(out_dat,c('ghi_ID','Department','proj_title','loc_name','lat','long')) %>%
#  write.csv('C:/Users/Mary Shelley/Documents/vc_projs/GlobalHealth/out_dat_pub.csv')

