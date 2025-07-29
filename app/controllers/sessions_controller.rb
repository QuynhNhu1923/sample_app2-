class SessionsController < ApplicationController
  # POST /login
  before_action :redirect_if_logged_in, only: [:new, :create]
  before_action :find_user, only: [:create]

  # GET /login
  def new; end

  # POST /login
  def create
    if @user && authenticate_user(@user)
      handle_success(@user)
    else
      handle_failure
    end
  end

  # DELETE /logout
  def destroy
    log_out if logged_in?
    flash[:success] = t("flash.logged_out")
    redirect_to root_path, status: :see_other
  end

  private
  def find_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
  end

  def authenticate_user user
    user&.authenticate(params.dig(:session, :password))
  end

  def redirect_if_logged_in
    return unless logged_in?

    flash[:info] = t(".logged_in")
    redirect_to current_user
  end

  def handle_success user
    forwarding_url = session[:forwarding_url]
    reset_session
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    flash[:success] = t("flash.logged_in")
    redirect_to forwarding_url || user
  end

  def handle_failure
    flash.now[:danger] = t("flash.danger")
    render :new, status: :unprocessable_entity
  end
end
