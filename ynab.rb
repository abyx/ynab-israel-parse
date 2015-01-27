require 'csv'

ExpenseRow = Struct.new(:name, :date, :outflow, :inflow) do
  def initialize(params = {})
    self.name = params[:name]
    self.date = params[:date]
    self.outflow = params[:outflow]
    self.inflow = params[:inflow]
  end
end

class ExpenseWriter
  def self.write(filename, expenses)
    CSV.open(filename, 'wb') do |csv|
      csv << %w(Payee Date Outflow Inflow)
      expenses.each do |expense|
        csv << [expense.name, expense.date, expense.outflow, expense.inflow]
      end
    end
  end
end
