class CardsController < ApplicationController
  before_action :require_login
  before_action :find_card, only: [:edit, :update, :destroy]

  def index
    @cards = current_user.cards
  end

  def new
    @card = Card.new
  end

  def show
  end

  def edit
  end

  def create
    @card = Card.create_card_in_deck(current_user, card_params)

    if @card.save
      redirect_to cards_path, notice: t('flash.card_created')
    else
      flash.now[:alert] = t('flash.fill_in_fields')
      render :new
    end
  end

  def update
    if @card.update(card_params)
      redirect_to cards_path, notice: t('flash.card_updated')
    else
      render :edit
    end
  end

  def destroy
    @card.destroy
    redirect_to cards_path
  end

  private

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :image, :deck_name)
  end

  def find_card
    @card = Card.find(params[:id])
  end
end
