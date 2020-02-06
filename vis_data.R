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

vis_amount <- function(data){
  ggplot(data = data)+
    geom_bar(mapping = aes(x = Personen,
                           fill = Type))+
    theme(axis.text.x=element_text(angle = 45, hjust = 1))
}

vis_locations <- function(data){
  data <- add_coordinates(data)
  data <- subset(data,!is.na(data$lon))
  data <- subset(data,!is.na(data$TimeAppoint))
  
   thismap <- c(left = min(data$lon)-3, bottom = min(data$lat), right = max(data$lon), top = max(data$lat))
   map <- get_stamenmap(thismap, zoom = 4, maptype = "toner")
   mymap <-ggmap(map)
  print(str(data))

mymap +
    geom_line(data,mapping = aes(x = data$lon,
                              y = data$lat,
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