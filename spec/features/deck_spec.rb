require 'rails_helper'

describe 'Deck' do
  let!(:user) { create(:user) }

  before do
    login(user.email)
  end

  context 'When user has no decks' do
    it 'shows message has no decks' do
      click_link 'Все колоды'
      expect(page).to have_content('У вас пока нет колод.')
    end

    it 'allows to create deck' do
      click_link 'Все колоды'
      click_link 'Добавить колоду'
      fill_in :deck_name, with: 'Тест'
      click_button 'Создать колоду'
      expect(page).to have_content('Колода создана')
    end
  end

  context 'When user has some decks' do
    let!(:deck) { create(:deck, user_id: user.id) }
    context 'and has no current deck' do
      it 'shows message "choose current deck"' do
        click_link 'Все колоды'
        expect(page).to have_content('Нужно выбрать текущую колоду!')
      end

      it 'allows to choose current deck' do
        click_link 'Все колоды'
        click_link 'Сделать текущей'
        expect(page).to have_content("Вы сделали колоду #{deck.name} текущей")
      end
    end
  end
end
