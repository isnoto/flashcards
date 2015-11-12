class ReviewsController < ApplicationController
  before_action :require_login

  def show
    @card = current_user.random_card
  end

  def create
    @card = Card.find(review_params[:card_id])

    if @card.check_answer(review_params[:answer])
      redirect_to root_path, notice: 'Верно!'
    else
      redirect_to root_path, alert: 'Ваш ответ не правильный'
    end
  end


  private

  def review_params
    params.permit(:card_id, :answer)
  end
end
