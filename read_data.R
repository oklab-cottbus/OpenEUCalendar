root_path <- ""
Sys.setlocale("LC_TIME", "en_US.UTF-8")

get_calendar_csv <- function(){
  cal <- read.csv(paste(root_path,"Kalender.csv",sep=""),sep = ";")
  
  
  return(cal)
}

reformat_csv <- function(){
  Jahr <- 2020
  cal <- read.csv(paste(root_path,"Kalender.csv",sep=""),sep = ";")
  cal$TimeAppoint <- as.POSIXlt((strptime(paste(Jahr,"-",cal$Monat,"-",cal$TagZahl,sep=""),"%Y-%b-%e")))
  cal$TimeAppoint$year[cal$TimeAppoint > as.POSIXlt(as.Date("2020-03-01"))] <- cal$TimeAppoint$year[cal$TimeAppoint > as.POSIXlt(as.Date("2020-03-01"))]-1
  cal$TimeSeen <- as.numeric(cal$TimeAppoint)
  cal$TimeDeleted <- as.numeric("Test")
  write.csv2(cal, "Kalender.csv", row.names = F, quote = F)
    
  return(cal)
  
}
