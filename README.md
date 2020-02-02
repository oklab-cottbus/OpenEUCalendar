# OpenEuCalendar
Die Eu Kommission stellt Termine der Kommissionsmitglieder*innen auf einer Website online
Scrape.py sammelt alle 10 min alle verfügbaren Termine von der Seite und speichert sie in eine CSV

## Visualisierung der ScrapeEuCalendar
CSV Dateien mit den gesammelten Terminen soll auf einer Karte visualisiert werden

Die Position eines jeden EU Kommissionsmitglied soll auf einer Karte angezeigt werden

### TODO

    - Rechtsgrundlage für die Veröffentlichung der Termine?
      - Warum haben einige Kommissare keine Termine
    - Pandas kann nicht einfach auf Samsung isntalliert werden.
      - pip install pandas scheitert wegen der instsallation von numpy
        - numpy über "its-pointless" repo installieren
          - https://wiki.termux.com/wiki/Package_Management#its-pointless_.28live_the_dream.29

### Daten Scrapen
  - Scrape.py säubern und übersichtlicher machen

### Daten verändern
  - Wochentage in der csv sind auch manchmal "von bis"
    - also: Thu-Fri
      - Termintag wird momentan ignoriert
  - Teilweise keine Orte angegeben
    - Was ist da los?
      - Meist handelt es sich bei diesen Terminen um Einladungen von den jeweiligen Kommissionsmitgliedern, somit scheint das Treffen am Ort des jeweiligen Kommisionsbüros statt zu finden. Noch nicht ganz klar


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
