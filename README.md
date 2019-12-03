# GlobalHealth

Code and data for publishing web app showing location of all SPH global health projects.

* **data_prep.R**: reads in spreadsheet (not included), calls Google Geocoding API to get lat/long of city/country combo, ouputs **out_dat_pub.csv** for app
* **app.R**: uses shiny and leaflet to create an interactive webmap; used interactive menu to publish from there
* **GlobalHealth.Rproj**: R project for grouping/coordinating R workspace

App hosted at: https://umd-sph.shinyapps.io/GlobalHealth/
