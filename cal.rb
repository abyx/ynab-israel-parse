require_relative './ynab'
require 'roo'
require 'spreadsheet'

xls = Roo::Spreadsheet.open(ARGV[0])

headers = ['תאריך עסקה', 'שם בית העסק', 'סכום חיוב ₪']
rows = (xls.longest_sheet.drop_while do |row|
  row.first != 'העסקה'
end.take_while do |row|
  row.first != 'סה"כ:'
end[1..-1] || []).map do |row|
  if row[0].kind_of? Date
    date = row[0].strftime('%d/%m/%Y')
  else
    date = row[0]
  end
  [row[1], date, row[4]]
end

expense_rows = rows.map do |row|
  amount = row[2]
  outflow = amount > 0 ? amount : ''
  inflow = amount < 0 ? -amount : ''
  ExpenseRow.new(:name => row[0],
                 :date => row[1],
                 :outflow => outflow,
                 :inflow => inflow)
end

ExpenseWriter.write(ARGV[1], expense_rows)
