class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

  def index
    @microposts = Micropost.recent_posts
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t(".success")
      redirect_to root_path, status: :see_other
    else
      @pagy, @feed_items = pagy(current_user.feed,
                                items: Settings.items_per_page)
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t(".success")
      redirect_to request.referer || root_path, status: :see_other
    else
      flash[:error] = t(".failure")
      redirect_to request.referer || root_path, status: :unprocessable_entity
    end
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    return if @micropost

    flash[:error] = t(".not_found")
    redirect_to request.referer || root_url, status: :not_found
  end
end
