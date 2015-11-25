class ProfileController < ApplicationController
  before_action :require_login

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to edit_profile_path, notice: t('flash.data_updated')
    else
      flash.now[:alert] = t('flash.wrong_filling')
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :locale)
  end
end
