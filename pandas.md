### How to create a new dataframe
```
from pandas import pandas as pd

df = pd.DataFrame(columns=['A', 'B', 'C'])
```

### Get the rows where one of the column value is not null
df.loc[~df['A'].isnull()]
