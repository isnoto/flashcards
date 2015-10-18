class UserSessionsController < ApplicationController
  def new
  end

  def create
    if login(params[:email], params[:password])
      redirect_back_or_to root_path, notice: 'Добро пожаловать!'
    else
      flash.now[:alert] = 'Пароль или E-mail введен неверно!'
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to log_in_path, notice: 'До скорой встречи!'
  end
end
