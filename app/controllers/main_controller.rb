class MainController < ApplicationController

  def index
    # add_email_to_account
    @user_email = params[:user_email]
  end

  private

  def add_email_to_account
    return if @account.email
    insales_account = InsalesApi::Account.find
    @account.update_attributes(email: insales_account.email)
  end
end
