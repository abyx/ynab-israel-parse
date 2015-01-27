require_relative './ynab'

lines = File.open(ARGV[0], 'r:windows-1255').read().encode('utf-8').lines()

domestic = lines[4..-1].take_while do |line|
  line !~ /^\t/
end.map do |line|
  line.split(/\t/)
end.map do |line|
  [line[1], line[0], line[3].sub(/,/, '')]
end

abroad = (lines.drop_while do |line|
  line !~ /תאריך חיוב/
end[1..-2] || []).map do |line|
  line.split(/\t/)
end.map do |line|
  [line[2], line[1], line[7].sub(/,/, '')]
end

expense_rows = (domestic + abroad).map do |line|
  outflow = line.last.start_with? '-'
  if line.last.start_with? '-'
    inflow = line.last[1..-1]
    outflow = ''
  else
    outflow = line.last[1..-1]
    inflow = ''
  end

  ExpenseRow.new(:name => line[0], :date => line[1], :outflow => outflow,
                 :inflow => inflow)
end

ExpenseWriter.write(ARGV[1], expense_rows)
