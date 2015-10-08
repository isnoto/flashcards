require 'rails_helper'

describe 'Reviewing card' do
  subject! { create(:card) }

  context 'When there are cards for review' do
    before do
      subject.update_attributes(review_date: Date.today - 2.days)
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
end