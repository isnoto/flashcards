class ReviewsController < ApplicationController
  def show
    @card = Card.random_for_review.first
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
end
