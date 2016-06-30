class Sales::MerchantKeyInformationAgreementsController < SalesController
  respond_to :html

  before_filter :set_merchant

  helper :all

  def show
    @key_information_agreement = KeyInformationAgreement.find(params[:id])
  end

  def new
    @key_information_agreement = @merchant.key_information_agreements.new
    respond_with @key_information_agreement
  end

  def create
    if (@key_information_agreement = @merchant.key_information_agreements.create(params[:key_information_agreement]))
      @merchant.status = 'submitted'
      @merchant.save!
    end
    respond_with @key_information_agreement, location: sales_merchants_url
  end

  def signature
    key_information_agreement = @merchant.key_information_agreements.find(params[:id])
    send_file key_information_agreement.signature_file, disposition: "inline"
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
