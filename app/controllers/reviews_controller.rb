class ReviewsController < ApplicationController
  before_action :require_login

  def show
    @card = current_user.random_card
  end

  def create
    @card = Card.find(review_params[:card_id])

    case @card.check_answer(review_params[:answer])
      when :correct_answer
        redirect_to root_path, notice: 'Верно!'
      when :wrong_answer
        redirect_to root_path, alert: 'Ваш ответ не правильный'
      when :wrong_answers_streak
        flash[:remind] = 'Вы ввели три раза не правильно!
                            Сделующая дата пересмотра карточки через 12 часов.'
        redirect_to root_path
      else
        redirect_to cards_path
    end

  end


  private

  def review_params
    params.permit(:card_id, :answer)
  end
end
