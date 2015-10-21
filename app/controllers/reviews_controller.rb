class ReviewsController < ApplicationController
  before_action :require_login

  def show
    @card = current_user.cards.random_for_review.first
  end

  def create
    @card = Card.find(review_params[:card_id])

    if @card.check_answer(review_params[:answer])
      redirect_to root_path, notice: 'Верно!'
    else
      flash.now[:alert] = 'Ваш ответ не правильный'
      render :show
    end
  end


  private

  def review_params
    params.permit(:card_id, :answer)
  end

  def not_authenticated
    flash[:alert] = 'У вас нету доступа до этой страницы! Войдите в свой профиль или зарегистрируйтесь'
    redirect_to log_in_path
  end
end
