import pandas as pd

data = {  "TagName":[1,2,3],
            "TagZahl":[1,2,3],
            }
df_all = pd.DataFrame(data)

new_row = {  "TagName":"4",
            "TagZahl":"4",
            }
df_all.append(new_row, ignore_index = True)

print(df_all)
