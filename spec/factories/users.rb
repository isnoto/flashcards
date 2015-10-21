FactoryGirl.define do
  factory :user do
    name 'test'
    email 'qwerty@gmail.com'
    password 12345
    password_confirmation { password }
  end
end
