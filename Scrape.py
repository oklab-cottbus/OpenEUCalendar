# !pip3 install requests
import time
import requests
import csv
import hashlib
import os
from bs4 import BeautifulSoup
from datetime import datetime
import locale
import pandas as pd

#pastebin
api_dev_key = "012922d95854551f49006bd3efd75401"
api_paste_key = "gCbVU8zM"
api_user_key = "75bfb663bdb1eea2f70bcb8b782da84e"
api_paste_code = ""
api_option = "paste"
api_paste_expire_date 	= '10M'
api_paste_name = "OpenEuCalendar"


locale.setlocale(locale.LC_ALL,'en_US.UTF-8')
print(locale.getlocale())
#while True:
pagenr = 0

df_all = pd.read_csv("Kalender.csv", sep = ";",quotechar='"')
#print(df_all["EventHash"])
df_new = {  "TagName":[],
            "TagZahl":[],
            "Monat":[],
            "Titel":[],
            "Personen":[],
            "Ort":[],
            "Land":[],
            "EventHash":[],
            "TimeAppoint":[],
            "TimeFirstSeen":[],
            "TimeLastSeen":[]}
seenall = set()

for row in range(1,len(df_all["EventHash"])):
    seenall.add(df_all.loc[row,"EventHash"])

while True:
    url = "https://ec.europa.eu/commission/commissioners/2019-2024/calendar_en?page=" + str(pagenr)
    Seite = requests.get(url)
    print("hole Seite:" + str(pagenr))
    print(url)
    SeiteText = BeautifulSoup(Seite.text)
    Eintraege = SeiteText.select(".listing__item")

    if(len(Eintraege) == 0):
        break

    #CSV Datei erstellen


    #Alle Einträge der Seite einlesen
    for Eintrag in Eintraege:
        TagName = Eintrag.select(".date-block__day-text")[0].getText()

        TagZahl = Eintrag.select(".date-block__day")[0].getText()
        Monat = Eintrag.select(".date-block__month")[0].getText()
        Jahr = datetime.today().strftime("%Y")
        if(len(Eintrag.select(".meta__item--type")) == 1):
            Type = Eintrag.select(".meta__item--type")[0].getText()
        else:
            Type = "NA"
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
        try:
            TimeAppoint = datetime.strptime(Jahr+"-"+Monat+"-"+TagZahl+" "+TempTime,"%Y-%b-%d %H:%M:%S")
            pass
        except Exception as e:
            TimeAppoint = "NA"

        if(TimeAppoint != "NA"):
            if(TimeAppoint < TimeNow):
                Jahr = str(int(Jahr)+1)
        if(TimeAppoint != "NA"):
            TimeAppoint = datetime.strptime(Jahr+"-"+Monat+"-"+TagZahl,"%Y-%b-%d")
        TimeFirstSeen = datetime.timestamp(datetime.now())
        TimeLastSeen = datetime.timestamp(datetime.now())

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

        if EventHash in seenall:
            index = df_all[df_all['EventHash']==EventHash].index.item()
            #print(index)
            df_all.loc[index,"TimeLastSeen"] = TimeLastSeen
            print(EventHash+" schon geloggt")
        else:
            #print(EventHash +" neu")
            new_row = {  "TagName":TagName,
                        "TagZahl":TagZahl,
                        "Monat":Monat,
                        "Titel":Titel,
                        "Personen":Personen,
                        "Ort":Ort,
                        "Land":Land,
                        "EventHash":EventHash,
                        "TimeAppoint":TimeAppoint,
                        "TimeFirstSeen":TimeFirstSeen,
                        "TimeLastSeen":TimeLastSeen,
                        "Type":Type}
            print(new_row)
            df_all = df_all.append(new_row, ignore_index=True)
            seenall.add(EventHash)


# #Duplikate entfernen
# with open('Kalender_new.csv', mode='r') as csvnew,open('Kalender.csv', mode='r') as csvall,open('Kalender_filtered.csv', mode='w') as csvwrite:
#     eunew = csv.reader(csvnew,delimiter=';', quotechar='"', quoting = csv.QUOTE_MINIMAL)
#     euall = csv.reader(csvall,delimiter=';', quotechar='"', quoting = csv.QUOTE_MINIMAL)
#     euwrite = csv.writer(csv,delimiter=';', quotechar='"', quoting = csv.QUOTE_MINIMAL)
#     #euwrite.writerow(["TagName","TagZahl","Monat","Titel","Personen","Ort","Land","EventHash"])
#     seenall = set()
#     seennew = set()
#     for row in euall:
#         seenall.add(row[7])
#     for row in eunew:
#         seennew.add(row[7])
#     for row in euall:
#         if row[7] not in seennew:



    #os.rename('Kalender_filtered.csv', 'Kalender.csv')
    pagenr = pagenr+1

print(df_all)
df_all.to_csv("Kalender.csv", sep=';', quoting = 1,quotechar='"',index=False)

api_paste_code = open("Kalender.csv", mode = "r").read()
userdata = {"api_paste_name":api_paste_name,"api_paste_expire_date":api_paste_expire_date,"api_dev_key":api_dev_key,"api_user_key": api_user_key, "api_paste_key": api_paste_key, "api_paste_code": api_paste_code, "api_option": api_option }
resp = requests.post('https://pastebin.com/api/api_post.php', data=userdata)
print(resp.text)
#   time.sleep(600)
