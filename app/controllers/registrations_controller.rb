class RegistrationsController < ApplicationController

  # NOTE: we might want to prevent changing or viewing any of the
  # step_x pages after the registration has been submitted.
  #
  # Reason being, we are using a uuid to save the customer
  # progress throughout the registration process...even though
  # guessing a uuid would be hard, we still don't want to leave
  # this open indefinitely since the Registration has sensitive
  # data.
  before_filter :load_registration, :on => [:edit, :update]
  before_filter :continue_registration, only: :new

  def new
    @registration = build_registration
  end

  def create
    @registration = build_registration(params[:registration])
    @registration.set_attributes_to_validate_for_step!(params[:step])

    if @registration.save
      redirect_to edit_registration_path(@registration.uuid)
    else
      render 'new'
    end
  end

  def edit
    @registration.user = User.new unless @registration.user
  end

  def update
    set_attributes_to_validate_for_step!(@registration, params[:step])

    validate = params[:commit] == 'Save your progress' ? false : true

    if update_registration(validate)
      if @registration.step_complete?(:registration_small) || step_complete?(:registration_large)
        save_session_uuid(@registration) # cookie set after registration is complete
        redirect_to confirmation_registration_path(@registration.id)
      else
        redirect_to edit_registration_path(@registration.uuid)
      end
    else
      copy_user_errors_back_to_merchant(@registration)
      render 'edit'
    end
  end

  def confirmation
    @registration = Merchant.find(params[:id])
  end

  private

  def build_registration(parameters = nil)
    RegistrationDecorator.new(Merchant.new(parameters))
  end

  def lookup_registration_by_uuid(uuid)
    merchant = Merchant.find_by_uuid(uuid)
    @registration = RegistrationDecorator.new(merchant) if merchant
  end

  def load_registration
    @registration = lookup_registration_by_uuid(params[:id])
  end

  def set_attributes_to_validate_for_step!(registration, step)
    return if step.blank?
    registration.attrs_to_validate = RegistrationDecorator::STEP_ATTRS[step]
  end

  def save_session_uuid(registration)
    cookies[:uuid] = registration.uuid
  end

  def session_uuid
    cookies[:uuid]
  end

  def continue_registration
    registration = lookup_registration_by_uuid(session_uuid) if session_uuid
    redirect_to edit_registration_path(registration.uuid) if registration
  end

  def update_registration(validate)
    if params[:registration].present? && @registration.small?
      (params[:registration][:user_attributes] ||= HashWithIndifferentAccess.new).tap do |user_params|
        user_params[:username] ||= params[:registration][:contact_work_email_address]
        user_params[:email] ||= params[:registration][:contact_work_email_address]
        user_params[:first_name] ||= params[:registration][:contact_first_name]
        user_params[:last_name] ||= params[:registration][:contact_last_name]
        user_params[:is_merchant] = true
        user_params[:active] = true
      end
    end

    @registration.attributes = params[:registration]
    @registration.save validate: validate
  end

  def copy_user_errors_back_to_merchant(merchant)
    errors = merchant.user && (merchant.user.errors[:encrypted_email] + merchant.user.errors[:email])
    merchant.errors.add(:contact_work_email_address,  errors.first) if errors.present?
  end
end

