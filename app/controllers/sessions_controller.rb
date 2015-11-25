class SessionsController < ApplicationController
  def new
  end

  def create
    if login(params[:email], params[:password])
      redirect_back_or_to root_path, notice: t('flash.log_in')
    else
      flash.now[:alert] = t('flash.wrong_email_or_password')
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to log_in_path, notice: t('flash.log_out')
  end
end
