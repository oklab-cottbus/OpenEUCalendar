# OpenEuCalendar
Die Eu Kommission stellt Termine der Kommissionsmitglieder*innen auf einer Websit zur Verfügung.
https://ec.europa.eu/commission/commissioners/calendar/commission/commissioners/2019-2024%3Fpage%3D1_en

Diese werden jedoch nach eineiger Zeit gelöscht und sind somit nicht mehr zugänglich.

Das Script Scrape.py sammelt alle aktuell verfügbaren Termine und speichert sie in eine CSV-Datei


#Docker
Das Script läuft in einem Dockercontainer auf dem oklabcottbu experimentalserver.
über crontab wird das script ausgeführt und der output in die cronjob.txt geschrieben:

```
50 * * * * docker run openeucalendar > ~/cronjob.txt
```

## Visualisierung der ScrapeEuCalendar
CSV Dateien mit den gesammelten Terminen soll auf einer Karte visualisiert werden

Die Position eines jeden EU Kommissionsmitglied soll auf einer Karte angezeigt werden


### Daten analysieren
Ideen:
  - Beschreibungstexte analysieren
    - zusätzliche Teilnehmer von Terminen herausfinden
    - Themen der Termine herausfinden
  - Orte analysieren/Visualisieren
    - Koordinaten der Orte herausfinden
  - Termin Zeitpunkte herausfinden
    - Termine enthalten nur Tag und Ort, Uhrzeit ist vielleicht aus den Zeitpunkten ersichtlich an denen die Termine eingestellt und rausgenommen werden
  -
# NTN
- mögliche locales des Systems über bash:``locale -a`` herausfinden
- - Pandas kann nicht einfach auf Samsung installiert werden.
  - pip install pandas scheitert wegen der instsallation von numpy
    - numpy über "its-pointless" repo installieren
      - https://wiki.termux.com/wiki/Package_Management#its-pointless_.28live_the_dream.29
