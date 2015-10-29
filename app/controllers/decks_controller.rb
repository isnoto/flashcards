class DecksController < ApplicationController
  before_action :find_deck, only: [:show, :edit, :update, :destroy]

  def index
    @decks = current_user.decks
  end

  def show
    @deck_cards = @deck.cards
  end

  def new
    @deck = Deck.new
  end

  def edit
  end

  def create
    @deck = current_user.decks.build(decks_params)

    if @deck.save
      redirect_to decks_path, notice: 'Колода создана'
    else
      flash.now[:alert] = 'Проверьте правильность заполнения поля!'
      render :new
    end
  end

  def update
    if @deck.update(decks_params)
      redirect_to decks_path, notice: 'Имя колоды успешно измененно'
    else
      render :edit
    end
  end

  def destroy

  end

  private

  def decks_params
    params.require(:deck).permit(:name)
  end

  def find_deck
   @deck = Deck.find(params[:id])
  end
end

