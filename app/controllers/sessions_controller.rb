class SessionsController < ApplicationController
<<<<<<< HEAD
  before_action :find_user, only: [:create]

  # GET /login
  def new; end
  
  # POST /login
  def create
    if @user && authenticate_user(@user)
      handle_success(@user)
=======
  def new; end

  def create
    user = User.find_user
    if user && authenticate_user
      handle_success(user)
>>>>>>> 11aa80d (Completed chapter 8)
    else
      handle_failure
    end
  end

<<<<<<< HEAD
  #DELETE /logout
=======
>>>>>>> 11aa80d (Completed chapter 8)
  def destroy
    log_out if logged_in?
    flash[:success] = t("flash.logged_out")
    redirect_to root_path, status: :see_other
  end
<<<<<<< HEAD
  private
  def find_user
    @user = User.find_by(email: params[:session][:email].downcase)
  end

  def authenticate_user(user)
    user&.authenticate(params[:session][:password])
  end

  def handle_success(user)
=======

  def find_user
    User.find_by(email: params[:session][:email].downcase)
  end

  def authenticate_user
    user&.authenticate(params[:session][:password])
  end

  def handle_success user
>>>>>>> 11aa80d (Completed chapter 8)
    reset_session
    log_in user
    flash[:success] = t("flash.logged_in")
    redirect_to user
  end

  def handle_failure
    flash.now[:danger] = t("flash.danger").to_s
    render :new, status: :unprocessable_entity
  end
end
