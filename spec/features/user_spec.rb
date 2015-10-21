require 'rails_helper'

describe 'User authorization' do
  let!(:user) { create(:user) }

  context 'Accessing page' do
    context 'when user log in' do
      before { login(user.email) }

      it 'shows Username on page' do
        visit root_path
        expect(page).to have_content(user.name)
      end

      it 'allows create cards' do
        create_card
        expect(page).to have_content('Карточка создана')
      end

      it 'not allows create empty cards' do
        click_link 'Добавить карточку'
        click_button 'Создать'
        expect(page).to have_content('Заполните все поля!')
      end

      it 'allows edit cards' do
        create_card
        visit cards_path
        click_link 'Редактировать'
        fill_in :card_original_text, with: 'Another word'
        click_button 'Создать'
        expect(page).to have_content('Карточка успешно отредактирована!')
      end

      it 'allows edit profile' do
        click_link user.name
        expect(page).to have_button('Обновить')
      end

      let(:another_user) { create :user, name: 'another_name', email: 'another_email@gmail.com' }

      it 'grants access only to user\'s cards' do
        card = another_user.cards.push(build(:card))

        expect {
          visit edit_card_path(card)
        }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'allows logout from account' do
        visit root_path
        click_link 'Выйти'
        expect(page).to have_content('До скорой встречи!')
      end
    end

    context 'when user not logged in' do
      it 'denies access to cards' do
        visit cards_path
        expect(current_path).to eq log_in_path
      end
    end
  end
end

describe 'Authentication' do
  it 'signs in after registration' do
    visit sign_up_path
    register_user
    expect(page).to have_content('Добро пожаловать!')
  end
end