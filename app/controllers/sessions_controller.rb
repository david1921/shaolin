class SessionsController < Clearance::SessionsController
  
  def create
    @user = authenticate(params)

    if @user.nil?
      flash_failure_after_create
      redirect_to new_session_path
    else
      sign_in @user
      redirect_back_or current_user_home_path
    end
  end

  def destroy
    redirect_to url_after_destroy_for current_user
    sign_out
  end

  private

  def url_after_create
    if signed_in? && current_user.is_sales?
      sales_url
    else
      root_url
    end
  end

  def url_after_destroy_for user
    user.is_merchant? ? root_url : sign_in_url
  end
end
