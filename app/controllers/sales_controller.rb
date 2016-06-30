class SalesController < ApplicationController

  before_filter :authorize, :authorize_sales_user

private

  def authorize_sales_user
    deny_access unless current_user.try(:is_sales?)
  end
end
