require 'rails_helper'

describe 'Managing cards', js: true do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user_id: user.id) }

  before do
    login(user.email)
    visit new_card_path
  end

  context 'When user try to create card' do
    it 'not allows create empty cards' do
      visit_create_card_path
      click_button 'Создать'
      expect(page).to have_content('Заполните все поля!')
    end

    it 'allows to create cards in deck' do
      visit_create_card_path
      card_fill_in
      select deck.name, from: 'Deck'
      click_button 'Создать'
      expect(page).to have_content('Карточка создана')
    end

    it 'allows to create a new deck along with a new card' do
      visit new_card_path
      card_fill_in
      select2_fill_in '.card_deck_name', with: 'Test'
      click_button 'Создать'
      expect(page).to have_content('Карточка создана')
    end
  end
end
