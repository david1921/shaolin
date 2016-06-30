class OffersController < ApplicationController

  before_filter :authorize
  before_filter :set_merchant
  before_filter :set_offer, except: [:new, :create]
  before_filter :set_steps, except: [:new, :create]

  helper :addresses, :offer_targeting_criteria

  def new
    @offer = @merchant.offers.build
    @view_step = 1
  end

  def create
    @offer = @merchant.offers.build
    @offer.user = current_user
    if @offer.update_step_and_attributes(1, params[:offer])
      redirect_to edit_offer_url(@offer)
    else
      render :new
    end
  end

  def update
    if @offer.update_step_and_attributes(@view_step, sanitized_offer_params, reset_later_attributes: true)
      redirect_to edit_offer_url(@offer)
    else
      render :edit
    end
  end

  def save_progress
    saved = @offer.update_step_and_attributes(@prev_step, sanitized_offer_params)
    respond_to do |format|
      format.js { render nothing: true, status: saved ? 200 : 500 }
    end
  end

  private

  def set_merchant
    if current_user.is_merchant? && current_user.merchant.present?
      @merchant = current_user.merchant
    else
      render nothing: true, status: :forbidden
    end
  end

  def set_offer
    @offer = Offer.find(params[:id])
    render nothing: true, status: :forbidden unless @merchant == @offer.merchant
  end

  def set_steps
    @view_step = params[:view_step].try(:to_i) || @offer.step + 1
    @view_step = 4 if @offer.free? && 3 == @view_step

    @prev_step = @view_step - 1
    @prev_step = 2 if @offer.free? && 3 == @prev_step
  end

  def sanitized_offer_params
    params.try(:fetch, :offer, nil).tap do |offer_params|
      if offer_params.present?
        [
          :target_age_ranges,
          :target_genders,
          :target_annual_incomes,
          :target_distance_from_location,
          :target_spend_per_transaction_with_merchant,
          :target_spend_per_transaction_in_sector,
          :target_spend_frequency_per_week_with_merchant,
          :target_spend_frequency_per_week_in_sector
        ].each do |target_param|
          offer_params[target_param].presence.try :select!, &:present?
        end
      end
    end
  end
end
