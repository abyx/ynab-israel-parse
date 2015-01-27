Utilities for converting output files from different Israeli financial institutions into a CSV that can be imported into YNAB.

1. `ruby leumicard.rb input.xls output.csv`
1. `ruby amex_isracard.rb input.txt output.csv`
1. `ruby cal.rb input.xls output.csv`
1. `ruby discount.rb input.xls output.csv`

XLS files from CAL and Leumi Card need to be opened with Excel and saved again as xls 2007-2013 format before they can be processed.
