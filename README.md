## Visualisierung der ScrapeEuCalendarAPP
CSV Dateien mit den gesammelten Terminen soll auf einer Karte visualisiert werden

Die Position eines jeden EU Kommissionsmitglied soll auf einer Karte angezeigt werden

### TODO
  - neue spalte in python hinzugefügt(TimeAppoint,TimeSeen)
    - existierender csv file muss angepasst werden bevor das nächste mal das skript läuft
    - alte zeitbeschreibungen sind eigentlich redundant
  - in R müsste System locale muss geändert werden, damit auf englisch abgekürzte Monate von strptime()
    erkannt werden können
    - Monat kan  vielleicht auch direkt beim Scrapen durchgeführt werden
      - manuelles gsub
      
### Daten Scrapen
- Jahreszahl muss noch hinzugefügt werden
  - muss zum zeitpunkt des scrapings gemacht werden
  - liegt das gefundene Datum ohne Jahr vor oder nach dem aktuellen Datum
    - Wenn vorher, muss es sich um das folgende Jahr handeln
    - wenn nachher handelt es sich um das aktuelle jahr

### Daten einlesen
  - csv einlesen
  
### Daten verändern
  - Wochentage in der csv sind auch manchmal "von bis"
    - also: Thu-Fri
    - muss abgefangen werden
  - Teilweise keine Orte angegeben
    - Was ist da los?
      - Meist handelt es sich bei diesen Terminen um Einladungen von den jeweiligen Kommissionsmitgliedern, Somit scheint das Treffen am Ort des jeweiligen Kommisionsbüros statt zu finden. ABer welches. Luxemburg oder Belgien???
      
      
# NTN
mögliche locales des Systems über bash:``locale -a`` herausfinden
    