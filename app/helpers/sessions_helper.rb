module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user = user_from_cookie)
      @current_user = user
    end
  end

  def user_from_cookie
    user_id = cookies.signed[:user_id]
    user = User.find_by(id: user_id)
    return unless user&.authenticated?(cookies[:remember_token])

    log_in user
    user
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end
end
