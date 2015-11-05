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
    @card = Card.create_card_in_deck(current_user.id, card_params)

    if @card.save
      redirect_to cards_path, notice: 'Карточка создана'
    else
      flash.now[:alert] = 'Заполните все поля!'
      render :new
    end
  end

  def update
    if @card.update(card_params)
      redirect_to cards_path, notice: 'Карточка успешно отредактирована!'
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

  def not_authenticated
    flash[:alert] = 'У вас нету доступа до этой страницы! Войдите в свой профиль или зарегистрируйтесь'
    redirect_to log_in_path
  end
end
