class ReviewsController < ApplicationController
  def show
    @card = Card.random_for_review.first
  end

  def create
    @card = Card.find(reviews_params[:card_id])

    if @card.check_user_answer(reviews_params[:answer])
      flash[:success] = 'Верно!'
      redirect_to root_path
    else
      flash.now[:wrong_answer] = 'Ваш ответ не правильный'
      render :show
    end
  end


  private

  def reviews_params
    params.permit(:card_id, :answer)
  end
end
