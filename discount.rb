require 'roo'
require 'spreadsheet'
require_relative './ynab'

xls = Roo::Spreadsheet.open(ARGV[0])

headers = ['תאריך הפעולה', 'יום ערך', 'תיאור הפעולה', 'אסמכתה', 'זכות / חובה', 'יתרה']
rows = xls.parse(:header_search => headers)[1..-1].take_while do |row|
  row.values.first != nil
end

expense_rows = rows.map do |row|
  amount = row['זכות / חובה']
  outflow = amount < 0 ? -amount : ''
  inflow = amount > 0 ? amount : ''
  ExpenseRow.new(:name => row['תיאור הפעולה'],
                 :date => row['תאריך הפעולה'],
                 :outflow => outflow,
                 :inflow => inflow)
end

ExpenseWriter.write(ARGV[1], expense_rows)
