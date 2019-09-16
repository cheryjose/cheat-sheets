### How to create a new dataframe
```
from pandas import pandas as pd

df = pd.DataFrame(columns=['A', 'B', 'C'])
```

### Get the rows where one of the column value is not null
```
df.loc[~df['A'].isnull()]
```
### Get the rows when multiple conditions are met
```
df.loc[(df['sex']=='Male') & (df['smoker'] == 'Yes') & (df['day'] == 'Sat')]
```
### Find a column value satisfying a condition
```
df.loc[df['total_bill'] > 40, 'total_bill']
```
### Find sum of a column value
```
sum(df.loc[df['total_bill'] > 40, 'total_bill'])
```
