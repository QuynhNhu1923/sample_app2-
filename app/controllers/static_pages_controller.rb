class StaticPagesController < ApplicationController
  # GET /home
  def home
    @user_name = Settings.user_name
    @app_name = Settings.app_name
    @admin_email = Settings.admin_email
    @items_per_page = Settings.items_per_page

    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy(current_user.feed,
                              items: Settings.items_per_page)
  end

  # GET /help
  def help; end

  # GET /about
  def about; end

  # GET /contact
  def contact; end
end
