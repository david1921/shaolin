class Sales::OfferKeyInformationAgreementsController < SalesController
  respond_to :html

  before_filter :set_offer

  helper :all

  def new
    @key_information_agreement = @offer.key_information_agreements.new
    respond_with @key_information_agreement
  end

  def create
    if @key_information_agreement = create_kif_for_offer(@offer, kif_params)
      @offer.signature_uploaded! # this calls save!
    end
    respond_with @key_information_agreement, location: sales_merchants_url
  end

  def signature
    key_information_agreement = @offer.key_information_agreements.find(params[:id])
    send_file key_information_agreement.signature_file, disposition: "inline"
  end

  private

  def set_offer
    @offer = Offer.find(params[:offer_id])
  end

  def create_kif_for_offer(offer, kif_params)
    offer.key_information_agreements.create(kif_params)
  end

  def kif_params
    params[:key_information_agreement]
  end
end
