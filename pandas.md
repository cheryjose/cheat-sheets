### How to create a new dataframe
```
from pandas import pandas as pd

df = pd.DataFrame(columns=['A', 'B', 'C'])
```

### Get the rows where one of the column value is not null
```
df.loc[~df['A'].isnull()]
```

### Disply top 100 results from a dataframe
```
df.head(100)
```
### Display last 100 results from a dataframe
```
df.tail(100)
```
### Display top 10 results of a dataframe column
```
df.top(10)['A']
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
### Display selected columns in dataframe
```
df[['total_bill', 'tip', 'tip%']]
```
### Create a new column from result of calculation using exiting columns
```
df['tip%'] = (df['tip'] % df['total_bill']) * 100
```
### Drop a column from dataframe
```
df_new.drop('tip%', axis=1)
```
### Drop multiple columns from dataframe
```
df_new.drop(['tip%','tip'], axis=1)
```
### Find Min, Max, Median, Mean, Sum of a column
```
import numpy as np
np.sum(df_new['tip'])
```
### Check if any of the column value satisfies a condition
```
import numpy as np
np.any((df_new['tip'] > 2) & (df_new['tip'] <10))
```
### Check if all of the column value satisfies a condition
```
import numpy as np
np.all((df_new['tip'] > 0.1) & (df_new['tip'] <100))
```
### Apply a formula to all rows in a column
```
df['tip'] =  df['tip'].apply(lambda x: x + 10)
```
