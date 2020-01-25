root_path <- "/Users/Sebastian/Google_Drive/Dokumente/Programmieren/JupyterNotebook/ScrapeEUCommissionCalendar/"
Sys.setlocale("LC_TIME", "de")

get_calendar_csv <- function(){
  cal <- read.csv(paste(root_path,"Kalender.csv",sep=""),sep = ";")
  Jahr <- 2020
  Monat <- cal$Monat
  Tag <- cal$TagZahl
  cal$Datum <- as.POSIXct(strptime(paste(Jahr,Monat,Tag,sep="-"),"%Y-%b-%e"))
  
  return(cal)
}
