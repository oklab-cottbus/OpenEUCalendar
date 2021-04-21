library(ggmap)
library(jsonlite)
library(gganimate)
library(leaflet)
library(ggiraph)
library(dplyr)

vis_times <- function(data){
  plot_df <- subset(data,!is.na(data$TimeLastSeen))
  plot_df <- subset(plot_df,max(round_date(plot_df$TimeLastSeen,"10min")) != round_date(plot_df$TimeLastSeen,"10min"))
  plot_df$TimeFirst <- format(round_date(plot_df$TimeFirstSeen,"10 min"),"%H:%M")
  plot_df$TimeLast <- format(round_date(plot_df$TimeLastSeen,"10 min"),"%H:%M")
  
  p <- ggplot(plot_df)+
    #geom_bar_interactive(mapping = aes(tooltip = format(TimeFirstSeen,"%Y-%m-%d"),x = TimeFirst, fill = "FirstSeen"))+
    geom_bar_interactive(mapping = aes(tooltip = format(TimeLastSeen,"%Y-%m-%d"),x = TimeLast, fill = "LastSeen"), color = "black",position = "stack")+
    theme(axis.text.x=element_text(angle = 70, hjust = 1))
  girafe(code = print(p))
  # ggplot(plot_df)+
  #   geom_point(mapping = aes(x = TimeFirst,
  #                            y = TimeLast))
}

vis_amount <- function(data){
  ggplot(data = data)+
    geom_bar(mapping = aes(x = Personen,
                           fill = Type))+
    theme(axis.text.x=element_text(angle = 90, hjust = 1))
}

vis_locations <- function(data){
  #data <- add_coordinates(data)
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
              size = 1)
    # transition_time(as.numeric(as.Date(TimeAppoint))) +
    # ease_aes('linear')
# animate(p, nframes = 100, fps=3)
}

vis_locations_leaflet <- function(data){
  data <- subset(data,!is.na(data$lon))
  rainbow_pallet <- rainbow(n = 21)
  Color <- rainbow_pallet[as.numeric(factor(data$Personen))]
  
  icons <- awesomeIcons(
    icon = 'ios-close',
    iconColor = Color,
    library = 'ion',
    markerColor = "blue"
  )
  m <- leaflet() %>%
    addTiles() %>%  # Add default OpenStreetMap map tiles
    addAwesomeMarkers(lng=data$lon,
               lat=data$lat,
               label=data$Personen,
               popup = paste(data$Titel,data$TagZahl,data$Monat),
               icon = icons,
               clusterOptions = markerClusterOptions())
  m
}

vis_locations_amount <- function(data){
  p <- ggplot(data)+
    geom_bar_interactive(mapping = aes(x = Land,
                                       tooltip = Ort))+
    #scale_y_log10()+
    theme(axis.text.x=element_text(angle = 60, hjust = 1))
  girafe(code = print(p),width_svg = 15,height_svg = 10)
}

get_lonlat <- function(Ort, Land){
  if(Ort == "Frankfourt"){
    Ort <- "Frankfurt"
  }
  if(Ort == "BRUSELS"){
    Ort <- "BRUSSELS"
  }
  else if(Ort == "" || Land =="")
  {
    return(data.frame(lon = NA, lat = NA))
  }
  longlat <- tryCatch({
    
  
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
  },
  error = function(cond){
    debugprint("Fehler bei Abfrage")
    debugprint(cond)
    return(data.frame(lon = NA, lat = NA))
  })
  
  return(longlat)
}

add_coordinates <- function(data){
  locations <- unique(data.frame(data$Ort,data$Land))
  locations <- subset(locations,!is.na(locations$data.Ort))
  print(locations)
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

vis_canceled <- function(data){
  data <- data %>%
    mutate(TimeAppoint = as.Date(TimeAppoint)) %>%
    mutate(canceled = ifelse(TimeLastSeen<=TimeAppoint,T,F))
  
  ggplot(data)+
    geom_bar_interactive(mapping = aes(x = canceled))
  
}

vis_LastSeendiff <- function(data){
  
  
  ggplot(data)+
    geom_point(mapping = aes(x = TimeLastSeen,
                             y = difftime(data$TimeLastSeen,data$TimeFirstSeen,units = "hours"),
                             color = format(TimeLastSeen,"%U")))
}
vis_FirstSeendiff <- function(data){
  
  
  ggplot(data)+
    geom_point(mapping = aes(x = TimeFirstSeen,
                             y = difftime(data$TimeLastSeen,data$TimeFirstSeen,units = "hours"),
                             color = format(TimeFirstSeen,"%U")))
}

vis_LastSeenVsAppoint <- function(data){
  data <- data %>%
    mutate(TimeAppoint = as.Date(TimeAppoint)) %>%
    mutate(canceled = ifelse(TimeLastSeen<=TimeAppoint,T,F))
  
  ggplot(data)+
    geom_point(mapping = aes(x = as.Date(TimeLastSeen),
                             y = difftime(as.Date(TimeAppoint),TimeLastSeen,units = "days"),
                             color = canceled))
}

vis_FirstSeenVsAppoint <- function(data){
  ggplot(data)+
    geom_point(mapping = aes(x = as.Date(TimeFirstSeen),
                             y = difftime(as.Date(TimeAppoint),as.Date(TimeFirstSeen),units = "hours")))
}


vis_AppointVsPerson <- function(data){
  #normalisieren
  data <- data %>%
    mutate()
  ggplot(data)+
    geom_bar(mapping = aes(x = Personen))+
    facet_grid(rows = vars(format(as.Date(TimeAppoint),"%u")))+
    theme(axis.text.x=element_text(angle = 60, hjust = 1))
}

vis_appointmensperday <- function(data){
    data <- subset(data, !is.na(as.Date(data$TimeAppoint)))
    counts <- as.data.frame(table(as.Date(data$TimeAppoint)))
    data <- data %>% add_count(TimeAppoint)
    ggplot(data, aes(x=format(as.Date(TimeAppoint),"%u"),
                     y=format(as.Date(TimeAppoint),"%Y-%U"))) + 
    geom_tile(mapping = aes(fill = n))
    #geom_bar(data, mapping = aes(x = as.Date(TimeAppoint)))
}