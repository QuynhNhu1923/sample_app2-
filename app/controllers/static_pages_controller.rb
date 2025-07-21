class StaticPagesController < ApplicationController
  def home
    @user_name = Settings.user_name
    @app_name = Settings.app_name
    @admin_email = Settings.admin_email
    @items_per_page = Settings.items_per_page
  end

  def help; end

  def about; end

  def contact; end
end
