require 'rails_helper'

describe Card do
  let(:card) { Card.create(original_text: 'Привет', translated_text: 'ПриВЕТ') }

  context '#words_cannot_be_equal' do
    let(:card) { Card.new(original_text: 'Good', translated_text: 'GoOd') }

    it 'does not pass the same words' do
      expect(card).not_to be_valid
    end
  end

  context '#add_review_date' do
    it 'equals time now + 3days' do
      expect(card.review_date).to eq(Date.today + 3.days)
    end
  end

  context '#prepare_word' do
    it 'work with cyrillic' do
      expect(card).not_to be_valid
    end
  end

  context '#check_answer' do
    let(:answer) { 'Привет' }

    it 'user\'s answer equals to original text' do
      expect(answer).to eq(card.original_text)
    end
  end

  context ''
end