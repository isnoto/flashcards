class ReviewsController < ApplicationController
  before_action :require_login

  def show
    @card = current_user.random_card
  end

  def create
    @card = Card.find(review_params[:card_id])
    result = @card.check_answer(review_params[:answer], params[:time])

    case result
    when :correct_answer
      redirect_to root_path, notice: t('flash.review_correct_answer')
    when :typo_in_word
      flash.now[:remind] = t('flash.review_hint',
                             your_word:review_params[:answer],
                             expected_word: @card.original_text)
      render :show
    when :wrong_answer
      redirect_to root_path, alert: t('flash.review_wrong_answer')
    end
  end


  private

  def review_params
    params.permit(:card_id, :answer, :time)
  end
end
