module MerchantBinder
  include AddressBinder

  def merchant_params
    @merchant_params ||= create_merchant_params
  end

  def save_only?
    params[:save].present?
  end

  def submit_only?
    params[:submit].present?
  end

private

  def create_merchant_params
    @merchant_params = params[:merchant]

    clear_address @merchant_params[:billing_address_attributes] if billing_address_is_overridden
    clear_address @merchant_params[:trading_address_attributes] if trading_address_is_overridden
    @merchant_params[:trading_name] = nil if trading_name_is_overridden
    if registered_with_companies_house
      clear_address @merchant_params[:business_address_attributes]
      @merchant_params[:business_name] = nil
    else
      clear_address @merchant_params[:registered_company_address_attributes]
      @merchant_params[:registered_company_name] = nil
    end

    mark_empty_addresses_for_deletion @merchant_params

    if save_only?
      @merchant_params.merge! status: 'draft'
    elsif submit_only?
      @merchant_params.merge! status: 'pending signature'
    end
    @merchant_params
  end

  def billing_address_is_overridden
    @merchant_params[:billing_address_is_trading_address] == '1' || @merchant_params[:billing_address_is_registered_company_address] == '1' || @merchant_params[:billing_address_is_business_address] == '1'
  end

  def trading_address_is_overridden
    @merchant_params[:trading_address_is_registered_company_address] == '1'
  end

  def trading_name_is_overridden
    @merchant_params[:trading_name_is_registered_company_name] == '1'
  end

  def registered_with_companies_house
    @merchant_params[:registered_with_companies_house] == '1'
  end

end