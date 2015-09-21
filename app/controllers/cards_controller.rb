class CardsController < ApplicationController
  def index
    @cards = Card.all
  end

  def show
    @card = find_card
  end

  def new
    @card = Card.new
  end

  def edit
    @card = find_card
    render :show
  end

  def create
    @card = Card.new(card_params)

    if @card.save
      redirect_to cards_path
    else
      render :new
    end
  end

  def update
    @card = find_card

    if @card.update(card_params)
      redirect_to card_path
    else
      render :edit
    end
  end

  def destroy
    @card = find_card
    @card.destroy
    redirect_to cards_path
  end

  private

  def card_params
    params.require(:card).permit(:original_text, :translated_text)
  end

  def find_card
    Card.find(params[:id])
  end
end
