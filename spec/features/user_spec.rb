require 'rails_helper'

describe 'User authorization' do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user_id: user.id) }

  context 'Accessing page' do
    context 'when user log in' do
      before { login(user.email) }

      it 'shows Username on page' do
        visit root_path
        expect(page).to have_content(user.name)
      end

      it 'allows edit cards_mailer' do
        create_card
        click_link 'Редактировать'
        fill_in :card_original_text, with: 'Another word'
        click_button 'Создать'
        expect(page).to have_content('Карточка успешно отредактирована!')
      end

      it 'allows to edit profile' do
        click_link user.name
        fill_in :user_name, with: 'qwerty'
        fill_in :user_password, with: 123456
        fill_in :user_password_confirmation, with: 123456
        click_button 'Обновить'
        expect(page).to have_content('Данные обновлены')
      end

      let(:another_user) do create :user, name: 'another_name',
                                  email: 'another_email@gmail.com'
      end

      let(:another_deck) { create(:deck, user_id: another_user.id) }

      it 'grants access only to user\'s cards_mailer' do
        card = another_deck.cards.push(build(:card))

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
      it 'denies access to cards_mailer' do
        visit cards_path
        expect(current_path).to eq log_in_path
      end
    end
  end
end

describe 'User authentication' do
  it 'signs in after registration' do
    visit sign_up_path
    register_user
    expect(page).to have_content('Добро пожаловать!')
  end

  it 'not allows to create user with wrong data' do
    visit sign_up_path
    click_button 'Регистрация'
    expect(page).to have_content('Заполните все поля!')
  end

  it 'not allows to create user with already existing name or email' do
    visit sign_up_path
    register_user
    click_link 'Выйти'
    visit sign_up_path
    register_user
    expect(page).to have_content('has already been taken')
  end
end