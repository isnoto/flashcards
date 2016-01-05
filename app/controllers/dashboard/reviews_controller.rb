class Dashboard::ReviewsController < ApplicationController
  before_action :require_login
  after_action { flash.discard if request.xhr? }

  def show
    @card = current_user.random_card

    respond_to do |format|
      if @card
        format.json { render json: @card }
      else
        format.json { render json: { review_done: t('review.done') } }
      end

      format.html
    end
  end

  def create
    @card = Card.find(review_params[:card_id])
    review_result = @card.check_answer(review_params[:answer], params[:time])

    case review_result
    when :correct_answer
      flash[:notice] = t('flash.review_correct_answer')
    when :typo_in_word
      flash[:remind] = t('flash.review_hint',
                         your_word: review_params[:answer],
                         expected_word: @card.original_text)
    when :wrong_answer
      flash[:alert] = t('flash.review_wrong_answer',
                        answer: review_params[:answer],
                        original: @card.original_text )
    end

    respond_to do |format|
      format.json { render json: { message: flash.to_h } }
    end
  end


  private

  def review_params
    params.permit(:card_id, :answer, :time)
  end
end
