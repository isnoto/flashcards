def login(email)
  visit root_path
  fill_in :email, with: email
  fill_in :password, with: 12345
  click_button 'Log In'
end