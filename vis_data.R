library(ggmap)
library(jsonlite)
library(gganimate)

vis_times <- function(data){
  plot_df <- subset(data,!is.na(data$TimeLastSeen))
  plot_df$TimeFirst <- format(round_date(plot_df$TimeFirstSeen,"10 min"),"%H:%M")
  plot_df$TimeLast <- format(round_date(plot_df$TimeLastSeen,"10 min"),"%H:%M")
  print(plot_df)
  
  ggplot(plot_df)+
    geom_bar(mapping = aes(x = TimeFirst),fill = "red")+
    geom_bar(mapping = aes(x = TimeLast),fill = "blue")
  
  
}

vis_locations <- function(data){
  #Koordinaten der verschiedenen Orte könnte über googlemapsapi herausgefunden werden
  #Orte auflisten
  locations <- unique(data.frame(data$Ort,data$Land))
  data$lon <- 
  print(locations)
  
}

vis_amount <- function(data){
  ggplot(data = data)+
    geom_bar(mapping = aes(x = Personen))
}

vis_locations <- function(data){
  #data <- add_coordinates(data)
  data <- subset(data,!is.na(data$lon))
  data <- subset(data,!is.na(data$TimeAppoint))
  #cottbus <- c(left = 14.30, bottom = 51.74, right = 14.36, top = 51.78)
  # lausitz <- c(left = 14.20, bottom = 51.60, right = 14.40, top = 51.80)
   deutschland <- c(left = 7, bottom = 47, right = 15, top = 55)
   europa <- c(left = -10, bottom = 30, right = 40, top = 60)
  # berlin <- c(left = 13.1, bottom = 52.4, right = 13.75, top = 52.65)
  # zeuthen <- c(left = 13.6, bottom = 52.3, right = 13.7, top = 52.4)
   thismap <- europa
   map <- get_stamenmap(thismap, zoom = 4, maptype = "toner")
   mymap <-ggmap(map)
  print(str(data))

mymap +
    geom_line(data,mapping = aes(x = jitter(data$lon,factor = 10),
                              y = jitter(data$lat,factor = 10),
                              color = data$Personen,
                              group = data$Personen),
              size = 2)
#     transition_time(as.numeric(as.Date(TimeAppoint))) +
#     ease_aes('linear')
# animate(p, nframes = 100, fps=3)
}
get_lonlat <- function(Ort, Land){
  
  Ort = gsub(" ","+",Ort)
  Country = gsub(" ","+",Land)
  print(paste(Ort,Country))
  url <- paste("https://nominatim.openstreetmap.org/search.php?q=",
               Ort,
               "%2C",
               Country,
               "&limit=9&format=json",
               sep = "")
  longlat <- read_json(url,simplifyVector = T)
  longlat <- subset(longlat,longlat$importance == max(longlat$importance))[1,]
  longlat <- data.frame(lon = longlat$lon, lat = longlat$lat)
  longlat
 
}

add_coordinates <- function(data){
  locations <- unique(data.frame(data$Ort,data$Land))
  locations <- subset(locations,!is.na(locations$data.Ort))
  locations$lon <- as.numeric("NA")
  locations$lat <- as.numeric("NA")
  #mit ggmaps
  
  #mit openstreetmap
  for (l in 1:length(locations$data.Ort)) {
  
  longlat <- get_lonlat(locations$data.Ort[l],locations$data.Land[l])
  print(longlat)
  locations$lon[l] <- as.numeric(as.character(longlat$lon))
  locations$lat[l] <- as.numeric(as.character(longlat$lat))
  
  }
  print(locations)
  for(pos in 1:length(data$Land)){
    data$lon[pos] <- locations$lon[locations$data.Ort == data$Ort[pos]]
    data$lat[pos] <- locations$lat[locations$data.Ort == data$Ort[pos]]
  }
  data
}