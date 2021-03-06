class Home::OauthsController < ApplicationController
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    @user = login_from(provider)

    if @user
      redirect_to root_path, notice: t('flash.ouath_log_in',
                                       provider: provider.titleize)
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to root_path, notice: t('flash.ouath_log_in',
                                         provider: provider.titleize )
      rescue
        redirect_to root_path, alert: t('flash.ouath_wrong',
                                        provider: provider.titleize )
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
