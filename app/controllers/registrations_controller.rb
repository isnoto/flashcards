class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login(params[:user][:email], params[:user][:password])
      redirect_to root_path, notice: 'Добро пожаловать!'
    else
      flash.now[:alert] = 'Заполните все поля!'
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
