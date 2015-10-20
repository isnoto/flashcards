def login(email)
  visit root_path
  fill_in :email, with: email
  fill_in :password, with: 12345
  click_button 'Log In'
end

def create_card
  click_link 'Добавить карточку'
  fill_in :card_original_text, with: 'Hello'
  fill_in :card_translated_text, with: 'Привет'
  click_button 'Создать'
end

def register_user
  fill_in :user_name, with: 'name'
  fill_in :user_email, with: 'email@gmail.com'
  fill_in :user_password, with: 'password'
  fill_in :user_password_confirmation, with: 'password'
  click_button 'Регистрация'
end
