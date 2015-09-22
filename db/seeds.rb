require 'nokogiri'
require 'open-uri'

source = "http://www.languagedaily.com/learn-german/vocabulary/common-german-words"
doc = Nokogiri::HTML(open(source))

words = doc.css("tbody tr")[1..-1]
words.each do |word|
  Card.create(original_text: word.children[3].text,
              translated_text: word.children[5].text)
end
