# !pip3 install requests
import requests
import csv
import hashlib
import os
from bs4 import BeautifulSoup
from datetime import datetime
import locale
locale.setlocale(locale.LC_ALL,'en_US.UTF-8')
print(locale.getlocale())
pagenr = 0

while True:
    Seite = requests.get("https://ec.europa.eu/commission/commissioners/2019-2024/calendar_en?page="+ str(pagenr))

    SeiteText = BeautifulSoup(Seite.text)
    Eintraege = SeiteText.select(".listing__item")

    if(len(Eintraege) == 0):
        break

    #CSV Datei erstellen
    with open('Kalender.csv',mode='a') as csvwrite:
        euwriter = csv.writer(csvwrite,delimiter=';', quotechar='"', quoting = csv.QUOTE_MINIMAL)
        #euwriter.writerow(["TagName","TagZahl","Monat","Titel","Personen","Ort","Land","EventHash"])
        #Alle Einträge der Seite einlesen
        for Eintrag in Eintraege:
            TagName = Eintrag.select(".date-block__day-text")[0].getText()
            TagZahl = Eintrag.select(".date-block__day")[0].getText()
            Monat = Eintrag.select(".date-block__month")[0].getText()
            Jahr = datetime.today().strftime("%Y")
            #Temporäre Zeit für den vergleich der Aktuellen und der Teminzeit um die Jahreszahl zu ermitteln
            TempTime ="23:59:59"

            Titel = Eintrag.select(".listing__title")[0].getText()
            Personen = Eintrag.select(".listing__author")[0].getText()
            #Datetime Objekt erstellen
            # definiere Jahr als aktuelles jahr
            # Konvertierung des Termins mit aktueller Jahreszahl als datetime objekt
            # vergleichen dieses objekts mit dem aktuellem Datum
            # wenn termin vor aktuellem datum dann ist jahr = jahr+1
            # wenn nicht dann ist jahr = jahr

            TimeNow = datetime.today()
            TimeAppoint = datetime.strptime(Jahr+"-"+Monat+"-"+TagZahl+" "+TempTime,"%Y-%b-%d %H:%M:%S")
            if(TimeAppoint < TimeNow):
                Jahr = str(int(Jahr)+1)

            TimeAppoint = datetime.strptime(Jahr+"-"+Monat+"-"+TagZahl,"%Y-%b-%d")
            TimeSeen = datetime.timestamp(datetime.now())
            TimeDeleted = "NA"

            #Erkennen von fehlenden Klassen
            if(len(Eintrag.select(".locality")) == 1):
                Ort = Eintrag.select(".locality")[0].getText()
                Land = Eintrag.select(".country")[0].getText()
            else:
                Ort = "NA"
                Land = "NA"
            #Erstellen einen Hashs, um später Duplikate entfernen zu können
            EventString = TagName+TagZahl+Monat+Titel+Personen+Ort+Land
            EventHash = hashlib.sha1(EventString.encode('utf-8')).hexdigest()
            euwriter.writerow([TagName,TagZahl,Monat,Titel,Personen,Ort,Land,EventHash,TimeAppoint,TimeSeen,TimeDeleted])

    #Duplikate entfernen
    with open('Kalender.csv', mode='r') as csvread,open('Kalender_filtered.csv', mode='w') as csvwrite:
        euread = csv.reader(csvread,delimiter=';', quotechar='"', quoting = csv.QUOTE_MINIMAL)
        euwrite = csv.writer(csvwrite,delimiter=';', quotechar='"', quoting = csv.QUOTE_MINIMAL)
        #euwrite.writerow(["TagName","TagZahl","Monat","Titel","Personen","Ort","Land","EventHash"])
        seen = set()
        for row in euread:
            if row[7] not in seen:
                euwrite.writerow(row)
                seen.add(row[7])


    os.rename('Kalender_filtered.csv', 'Kalender.csv')
    pagenr = pagenr+1
