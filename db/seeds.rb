require 'nokogiri'
require 'open-uri'

user = User.create(email: 'test@gmail.com',
                   password: '123456')

source = "http://www.languagedaily.com/learn-german/vocabulary/common-german-words"
doc = Nokogiri::HTML(open(source))

words = doc.css("tbody tr")[1..-1]
words.each do |word|
  Card.create(original_text: word.children[3].text,
              translated_text: word.children[5].text,
              user_id: user.id)
end
