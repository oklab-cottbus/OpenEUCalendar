library(ggmap)


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
  print(locations)
  
}

vis_amount <- function(data){
  ggplot(data = data)+
    geom_bar(mapping = aes(x = Personen))
}

get_lonlat <- function(locations){
  locations <- subset(locations,!is.na(locations$data.Ort))
  locations$lon <- as.numeric("NA")
  locations$lat <- as.numeric("NA")
  #mit ggmaps
  
  #mit openstreetmap
  for (l in 1:length(locations$data.Ort)) {
  
    Ort = gsub(" ","+",locations$data.Ort[l])
    Country = gsub(" ","+",locations$data.Land[l])
    print(paste(Ort,Country))
  url <- paste("https://nominatim.openstreetmap.org/search.php?q=",
        Ort,
        "%2C",
        Country,
        "&limit=9&format=json",
        sep = "")
  longlat <- read_json(url,simplifyVector = T)
  longlat <- subset(longlat,longlat$importance == max(longlat$importance))
  
  locations$lon[l] <- as.character(longlat$lon)
  locations$lat[l] <- as.character(longlat$lat)
  
  }
  locations
}