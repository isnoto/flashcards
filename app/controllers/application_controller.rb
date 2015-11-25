class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :set_locale

  def set_locale
    locale = if current_user
               current_user.locale
             elsif params[:locale]
               session[:locale] = params[:locale]
             elsif session[:locale]
               session[:locale]
             else
               http_accept_language.compatible_language_from(I18n.available_locales)
             end


    if locale && I18n.available_locales.include?(locale.to_sym)
      session[:locale] = I18n.locale = locale.to_sym
    end
  end

  def not_authenticated
    flash[:alert] = t('flash.not_authenticated')
    redirect_to log_in_path
  end
end
