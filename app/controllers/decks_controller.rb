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
    if @deck.current?
      current_user.update_attributes(current_deck_id: nil)
    end

    flash[:notice] = "Вы удалили колоду #{ current_deck_name }"
    @deck.destroy
    redirect_to decks_path
  end

  def set_current_deck
    if current_user.update_attributes(current_deck_id: params[:deck_id])
      redirect_to decks_path, notice: "Вы сделали колоду #{ current_deck_name } текущей"
    else
      redirect_to decks_path, alert: 'Ошибка'
    end
  end

  private

  def decks_params
    params.require(:deck).permit(:name)
  end

  def find_deck
   @deck = Deck.find(params[:id])
  end

  def current_deck_name
    id = params[:deck_id] || params[:id]

    Deck.find(id).name
  end
end
