## Visualisierung der ScrapeEuCalendarAPP
CSV Dateien mit den gesammelten Terminen soll auf einer Karte visualisiert werden

Die Position eines jeden EU Kommissionsmitglied soll auf einer Karte angezeigt werden

### TODO
  - System locale muss geändert werden, damit auf englisch abgekürzte Monate von strptime()
    erkannt werden können
### Daten Scrapen
- Jahreszahl muss noch hinzugefügt werden

### Daten einlesen
  - csv einlesen
  
### Daten verändern
  - Wochentage in der csv sind auch manchmal "von bis"
    - also: Thu-Fri
    - muss abgefangen werden
  - Teilweise keine Orte angegeben
    - Was ist da los?
    