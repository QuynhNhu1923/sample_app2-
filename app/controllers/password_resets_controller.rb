class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t(".create.email_sent")
      redirect_to root_url
    else
      flash.now[:danger] = t(".create.email_not_found")
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if user_params[:password].empty?
      @user.errors.add(:password, t(".update.cannot_empty_password"))
      render :edit, status: :unprocessable_entity
    elsif @user.update(user_params)
      @user.forget
      reset_session
      log_in @user
      flash[:success] = t(".update.password_reset_success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t(".load_user.user_not_found")
    redirect_to root_url
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset,
                                                         params[:id])

    flash[:danger] = t(".valid_user.user_not_activated")
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t(".check_expiration.password_reset_expired")
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
