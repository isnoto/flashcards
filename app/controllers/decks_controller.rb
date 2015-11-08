class DecksController < ApplicationController
  before_action :find_deck, only: [:show, :edit, :update, :destroy, :set_current]

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
    if @deck.current?
      current_user.update_attributes(current_deck_id: nil)
    end

    @deck.destroy
    redirect_to decks_path, notice: "Вы удалили колоду #{ @deck.name }"
  end

  def set_current
    if current_user.update_attributes(current_deck_id: @deck.id)
      redirect_to decks_path, notice: "Вы сделали колоду #{ @deck.name } текущей"
    else
      redirect_to decks_path, alert: 'Ошибка'
    end
  end

  private

  def decks_params
    params.require(:deck).permit(:name)
  end

  def find_deck
    id = params[:deck_id] || params[:id]

   @deck = Deck.find(id)
  end
end
