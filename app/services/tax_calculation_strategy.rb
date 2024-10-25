class TaxCalculationStrategy
  def calculate_tax(transaction)
    raise NotImplementedError, 'You must implement the calculate_tax method'
  end
end