class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login(params[:user][:email], params[:user][:password])
      redirect_to root_path, notice: 'Добро пожаловать!'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to edit_user_path, notice: 'Данные обновленны'
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
