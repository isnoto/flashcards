class ProfileController < ApplicationController
  before_action :require_login

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to edit_profile_path, notice: 'Данные обновлены'
    else
      flash.now[:alert] = 'Данные заполнены некорректно!'
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :locale)
  end
end
