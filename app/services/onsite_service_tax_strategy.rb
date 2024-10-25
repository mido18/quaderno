class OnsiteServiceTaxStrategy < TaxCalculationStrategy
  def calculate_tax(transaction)
    apply_vat(transaction, "onsite_service")
  end

  private

  def apply_vat(transaction, product_type)
    tax_rate = TaxRate.find_by(country: "Spain", product_type: product_type)
    transaction.tax_applied = tax_rate.vat_rate
    transaction.status = "completed"
    transaction.save
  end
end
