#TODO: This whole controller is going to be pretty much the same as the admin controller.  DRY it up.
class Sales::MerchantsController < SalesController
  include MerchantBinder
  
  before_filter :get_merchant, except: [:index, :new, :create]

  def index
    @merchants = Merchant.search default_pagination_params, params[:search]
  end

  def new
    @merchant = Merchant.new_by_sales_person
  end

  def edit
    @merchant = Merchant.find params[:id]
  end

  def create
    @merchant = Merchant.new merchant_params
    @merchant.set_attrs_to_validate_on_save(params[:merchant]) if save_only?
    if @merchant.save
      if save_only?
        redirect_to sales_merchants_path
      else
        # NOTE: Per Gareth/Sharon, paper applications don't require the terms and conditions or KIF pages, but they need to be marked as submitted.        
        if @merchant.paper_application?
          @merchant.status = "submitted"
          @merchant.save!
          redirect_to sales_merchants_path
        else
          redirect_to terms_and_conditions_sales_merchant_url(@merchant)
        end
      end
    else
      render :new
    end
  end

  def update
    @merchant.set_attrs_to_validate_on_save(params[:merchant]) if save_only?
    if @merchant.update_attributes merchant_params
      if submit_only?
        redirect_to terms_and_conditions_sales_merchant_url(@merchant)
      else
        redirect_to sales_merchants_path
      end
    else
      render 'edit'
    end
  end

  def accept_terms_and_conditions
    redirect_to new_sales_merchant_key_information_agreement_url(@merchant)
  end

  def reject_terms_and_conditions
    @merchant.status = 'cancelled'
    @merchant.save!
    redirect_to sales_merchants_url
  end

private

  def get_merchant
    @merchant = Merchant.find_by_id params[:id]
  end

end
