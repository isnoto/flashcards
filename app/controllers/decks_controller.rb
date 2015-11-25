class DecksController < ApplicationController
  before_action :find_deck, only: [:show, :edit, :update, :destroy, :set_current]

  def index
    @decks = current_user.decks
  end

  def show
  end

  def new
    @deck = Deck.new
  end

  def edit
  end

  def create
    @deck = current_user.decks.build(decks_params)

    if @deck.save
      redirect_to decks_path, notice: t('flash.deck_created')
    else
      flash.now[:alert] = t('flash.wrong_filling')
      render :new
    end
  end

  def update
    if @deck.update(decks_params)
      redirect_to decks_path, notice: t('flash.deck_updated')
    else
      render :edit
    end
  end

  def destroy
    if @deck.current?
      current_user.update_attributes(current_deck_id: nil)
    end

    @deck.destroy
    redirect_to decks_path, notice: t('flash.deck_deleted', deck: @deck.name)
  end

  def set_current
    if current_user.update_attributes(current_deck_id: @deck.id)
      redirect_to decks_path, notice: t('flash.deck_current', deck: @deck.name)
    else
      redirect_to decks_path, alert: t('flash.deck_current_error')
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
