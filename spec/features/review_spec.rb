require 'rails_helper'

describe 'Reviewing card' do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user_id: user.id) }

  before do
    login(user.email)
  end

  context 'When there are cards for review' do
    subject! { create(:card, deck_id: deck.id, deck_name: deck.name) }

    before do
      subject.update_attributes(review_date: Time.zone.now - 2.days)
    end

    it 'card show on page' do
      visit root_path
      expect(page).to have_content(subject.translated_text)
    end

    context 'and submit correct answer' do
      it 'shows success message' do
        visit root_path
        fill_in :answer, with: subject.original_text
        click_button 'Подтвердить'
        expect(page).to have_content('Верно!')
      end
    end

    context 'and submit wrong answer' do
      it 'shows error message' do
        visit root_path
        fill_in :answer, with: 'wrong'
        click_button 'Подтвердить'
        expect(page).to have_content('Ваш ответ не правильный')
      end
    end
  end

  context 'When there are not card for review' do
    it 'shows message "All cards reviewed"' do
      visit root_path
      expect(page).to have_content('Все карточки пересмотрены')
    end
  end
end