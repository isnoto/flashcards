require 'nokogiri'
require 'open-uri'

user = User.create(name: 'Test', email: 'test@gmail.com',
                   password: 123456, password_confirmation: 123456)
deck = Deck.create(name: 'test', user_id: user.id)

source = "http://www.languagedaily.com/learn-german/vocabulary/common-german-words"
doc = Nokogiri::HTML(open(source))

words = doc.css("tbody tr")[1..-1]
words.each do |word|
  Card.create(original_text: word.children[3].text,
              translated_text: word.children[5].text,
              deck_id: deck.id)
end
