class ReviewsController < ApplicationController
  before_action :require_login

  def show
    if current_user.current_deck_id
      @card = find_current_deck.cards.random_for_review.first
    else
      @card = current_user.cards.random_for_review.first
    end
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

  def find_current_deck
    current_user.decks.find(current_user.current_deck_id)
  end
end
