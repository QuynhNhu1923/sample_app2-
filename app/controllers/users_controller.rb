class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :load_user, only: [:show, :edit, :update, :destroy] 
  before_action :correct_user, only: [:edit, :update, :show]
  before_action :admin_user, only: [:index, :destroy]


  def index
    @pagy, @users = pagy(User.order(:name), items: Settings.items_per_page)
  end

  # GET /signup
  def new
    @user = User.new
  end

  # POST /signup
  def show; end

  # POST /create
  def create
    @user = User.new(user_params)
    if @user.save
      handle_success(@user)
    else
      handle_failure(@user)
    end
  end

  def edit
    # @user = User.find_by(id: params[:id])
    return if @user

    flash[:warning] = t(".error.not_found")
    redirect_to root_path
  end

  def update
   # @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      flash[:success] = t(".edit.update_success")
      redirect_to @user
    else
      flash[:error] = t(".edit.update_failed")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t(".destroy.success")
    else
      flash[:error] = t(".destroy.failed")
    end
    redirect_to users_url, status: :see_other
  end

  private
  def user_params
    params.require(:user).permit(User::USER_PERMIT)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t(".error.please_login")
    redirect_to login_url, status: :see_other
  end

  # def correct_user
  #   @user = User.find_by(id: params[:id])
  #   redirect_to(root_url, status: :see_other) unless @user == current_user
  # end

  def correct_user
    return if current_user?(@user)

    flash[:error] = t(".error.not_correct_user")
    redirect_to root_url
  end 

  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end

  def handle_success _user
    reset_session
    log_in @user
    flash[:success] = t(".new.create_success")
    redirect_to @user
  end

  def handle_failure _user
    flash.now[:error] = t(".new.create_failed")
    render :new, status: :unprocessable_entity
  end

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:warning] = t(".error.not_found")
    redirect_to root_path
  end
end
