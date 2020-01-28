## Visualisierung der ScrapeEuCalendarAPP
CSV Dateien mit den gesammelten Terminen soll auf einer Karte visualisiert werden

Die Position eines jeden EU Kommissionsmitglied soll auf einer Karte angezeigt werden

### TODO
    - Speicherort der Kalender.csv ändern, damit remote zugriff möglich
      - zumbeispiel NAS
    - Rechtsgrundlage für die Veröffentlichung der Termine?
      - Warum haben einige Kommissare keine Termine
    - Pandas kann nicht einfach auf Samsng isntalliert werden.
      - pip install pandas scheitert wegen der instsallation von numpy
        - numpy über "its-pointless" repo installieren
          - https://wiki.termux.com/wiki/Package_Management#its-pointless_.28live_the_dream.29

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
