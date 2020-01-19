from datetime import datetime as dt

# Time operations
## Get current time

dt.now()

## Create datetime object from string
date = dt.strptime('2020-01-01 16:10:20', '%Y-%m-%d %H:%M:%S.%f')

## Get string from datetime object
dateString = dt.now().strftime('%Y-%m-%d %H:%M:%S.%f')

## Add or substract time
### for days, hours, minutes and seconds use timedelta
from datetime import timedelta
time_days = dt.now() + timedelta(days=2)
time_hours = dt.now() + timedelta(hours=5)

### for months, years use relativedelta
from dateutil.relativedelta import relativedelta
time_months = dt.now() + relativedelta(months=2)
time_years = dt.now() + relativedelta(years=1)


