class PhysicalProductTaxStrategy < TaxCalculationStrategy
  def calculate_tax(transaction)
    if transaction.user.country == "Spain"
      apply_vat(transaction, "good")
    elsif transaction.eu_country?(transaction.user.country)
      transaction.user.user_type == "individual" ? apply_local_vat(transaction, "good") : transaction.mark_reverse_charge
    else
      transaction.mark_export
    end
  end

  private

  def apply_vat(transaction, product_type)
    tax_rate = TaxRate.find_by(country: "Spain", product_type: product_type)
    set_tax_and_status(transaction, tax_rate.vat_rate, "completed")
  end

  def apply_local_vat(transaction, country, product_type)
    tax_rate = TaxRate.find_by(country: country, product_type: product_type)
    set_tax_and_status(transaction, tax_rate.vat_rate, "completed")
  end

  def set_tax_and_status(transaction, tax_rate, status)
    transaction.tax_applied = tax_rate
    transaction.status = status
    transaction.save
  end
end
