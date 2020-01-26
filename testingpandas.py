import pandas as pd

df_all = pd.read_csv("Kalender.csv", sep = ";",quotechar='"')
seenall = set()

for row in range(1,len(df_all["EventHash"])):
    seenall.add(df_all.loc[row,"EventHash"])

#df.loc[df['column_name'] == some_value]
index = df_all[df_all['EventHash']=="36be70cce95153304a563f6037a6cc48e91ada4c"].index.item()
#print(index)
print(df_all.loc[0,"EventHash"])
print(df_all)
