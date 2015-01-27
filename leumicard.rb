require_relative './ynab'
require 'roo'
require 'spreadsheet'

xls = Roo::Spreadsheet.open(ARGV[0])

headers = ['תאריך עסקה', 'שם בית העסק', 'סכום חיוב ₪']
rows = xls.parse(:header_search => headers)[1..-1].take_while do |row|
  row.values.first != nil
end

expense_rows = rows.map do |row|
  amount = row['סכום חיוב ₪']
  outflow = amount > 0 ? amount : ''
  inflow = amount < 0 ? -amount : ''
  date = row['תאריך עסקה'].strftime('%d/%m/%Y')
  ExpenseRow.new(:name => row['שם בית העסק'],
                 :date => date,
                 :outflow => outflow,
                 :inflow => inflow)
end

ExpenseWriter.write(ARGV[1], expense_rows)
