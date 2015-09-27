class ReviewsController < ApplicationController
  def show
    @card = Card.random_for_review.first
  end

  def create
    @card = Card.find(params[:card_id])

    if @card.check_user_answer(params[:answer])
      flash[:success] = 'Верно!'
      redirect_to root_path
    else
      flash.now[:wrong_answer] = 'Ваш ответ не правильный'
      render :show
    end
  end
end
