class ProfileController < ApplicationController
  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to edit_profile_path, notice: 'Данные обновленны'
    else
      flash.now[:alert] = 'Данные заполнены некорректно!'
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
