require 'rails_helper'

describe Card do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user_id: user.id) }
  let!(:card) { create(:card, deck_id: deck.id) }
  let!(:wrong_card) { Card.create(original_text: 'Привет', ranslated_text: 'ПривЕТ') }
  let(:review_time) { 5_000 }

  context '#words_cannot_be_equal' do
    it 'does not pass the same words' do
      expect(wrong_card).not_to be_valid
    end
  end

  context '#prepare_word' do
    it 'work with cyrillic' do
      expect(wrong_card).not_to be_valid
    end
  end

  context '#check_answer' do
    context 'when answer is correct' do
      let!(:correct_ans) { card.check_answer('Hello', review_time) }

      it 'user\'s answer equals to original text' do
        expect(correct_ans).to be :correct_answer
      end
    end

    context 'when answer is incorrect after correct answer' do
      let!(:correct_ans)   { card.check_answer('Hello', review_time) }
      let!(:incorrect_ans) { card.check_answer('Aloha', review_time) }

      it 'review date equals "Time.zone.now"' do
        expect(card.review_date).to eq (Time.zone.now).to_date
      end

      it 'reset repetitions_number to 0' do
        expect(card.repetitions_number).to eq 0
      end
    end

    context 'when user made typo in word' do
      let(:typo_answer) { card.check_answer('ehllo', review_time) }

      it 'return symbol ":typo_in_word"' do
        expect(typo_answer).to eq :typo_in_word
      end
    end
  end

  context '#add_review_date' do
    it 'equals date today' do
      expect(card.review_date).to eq (Time.zone.now).to_date
    end
  end
end
