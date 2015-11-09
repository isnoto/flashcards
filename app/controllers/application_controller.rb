class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def not_authenticated
    flash[:alert] = 'У вас нету доступа до этой страницы! Войдите в свой профиль или зарегистрируйтесь'
    redirect_to log_in_path
  end
end
