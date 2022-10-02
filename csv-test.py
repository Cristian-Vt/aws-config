import pandas as pd
import json
import json_normalize

with open('pandas.json') as project_file:
   d = json.load(project_file)


df = json_normalize(d, 'result').assign( ** d['status'])
# df.to_csv('csvfile.csv', encoding='utf-8', index=False)
print(df)