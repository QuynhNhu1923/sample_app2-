class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show]
  before_action :load_user, only: [:show]

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

  private
  def user_params
    params.require(:user).permit(User::USER_PERMIT)
  end

  def handle_success _user
    reset_session
    log_in @user
    flash[:success] = t(".create_success")
    redirect_to @user
  end

  def handle_failure _user
    flash.now[:error] = t(".create_failed")
    render :new, status: :unprocessable_entity
  end

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:warning] = t(".error.not_found")
    redirect_to root_path
  end
end
