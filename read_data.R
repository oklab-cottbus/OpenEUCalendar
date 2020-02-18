library(RCurl)
library(jsonlite)
library(XML)
library(ggplot2)
library(lubridate)

root_path <- ""
Sys.setlocale("LC_TIME", "en_US.UTF-8")

get_calendar_csv <- function(){
  cal <- read.csv(paste(root_path,"Kalender.csv",sep=""),sep = ";")
  cal$TimeFirstSeen <- as.POSIXct(cal$TimeFirstSeen,origin = "1970-01-01",tz = "CET")
  cal$TimeLastSeen <- as.POSIXct(cal$TimeLastSeen,origin = "1970-01-01",tz = "CET")
  
  return(cal)
}

get_pastebin_csv <- function(){
  pastebin_pastes <- postForm(
    uri = 'http://pastebin.com/api/api_post.php',
    api_user_name = "scholzsebastian",
    api_dev_key = "012922d95854551f49006bd3efd75401",
    api_user_key = "75bfb663bdb1eea2f70bcb8b782da84e",
    api_option = "list")
  #root node hinzufügen
  pastebin_pastes <- paste("<div>",pastebin_pastes,"</div>",sep="")
  pastebin_pastes <- xmlToDataFrame(pastebin_pastes)
  
  paste_key <- as.character(pastebin_pastes$paste_key[pastebin_pastes$paste_title=="OpenEuCalendar"])
  
  eu_paste <- postForm(uri = 'http://pastebin.com/api/api_raw.php',
                       api_dev_key = "012922d95854551f49006bd3efd75401",
                       api_user_key = "75bfb663bdb1eea2f70bcb8b782da84e",
                       api_paste_key = paste_key,
                       api_option = "show_paste")
  
  cal <- read.csv(text = eu_paste,sep=";",na.strings=c("","NA"))
  cal$TimeFirstSeen <- as.POSIXct(cal$TimeFirstSeen,origin = "1970-01-01",tz = "CET")
  cal$TimeLastSeen <- as.POSIXct(cal$TimeLastSeen,origin = "1970-01-01",tz = "CET")
  
  return(cal)
}

reformat_csv <- function(){
  Jahr <- 2020
  cal <- read.csv(paste(root_path,"Kalender.csv",sep=""),sep = ";")
  cal$TimeAppoint <- as.POSIXlt((strptime(paste(Jahr,"-",cal$Monat,"-",cal$TagZahl,sep=""),"%Y-%b-%e")))
  cal$TimeAppoint$year[cal$TimeAppoint > as.POSIXlt(as.Date("2020-03-01"))] <- cal$TimeAppoint$year[cal$TimeAppoint > as.POSIXlt(as.Date("2020-03-01"))]-1
  cal$TimeFirstSeen <- as.numeric(cal$TimeAppoint)
  cal$TimeLastSeen <- as.numeric("Test")
  cal$Type <- as.numeric("Test")
  write.csv2(cal, "Kalender.csv", row.names = F, quote = T)
    
  return(cal)
  
}

extract_members <- function(data){
  data$Members <- gsub("^with\\s","", str_extract(data$Titel,"(?<=[mM]eets\\s)[^,]*"))
  return(data)
}
