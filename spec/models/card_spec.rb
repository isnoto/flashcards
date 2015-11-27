require 'rails_helper'

  describe Card do
    let!(:card) { build(:card) }
    let!(:wrong_card) { Card.create(original_text: 'Привет',
                                   translated_text: 'ПривЕТ') }

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
        let!(:correct_ans) { card.check_answer('Hello') }

        it 'user\'s answer equals to original text' do
          expect(correct_ans).to be :correct_answer
        end

        it 'increment field correct_answers by 1' do
          expect(card.correct_answers).to eq 1
        end
      end

      context 'when answer is incorrect' do
        let!(:incorrect_ans) { card.check_answer('Aloha') }

        it 'user\'s answer not equals to original text' do
          expect(incorrect_ans).to be :wrong_answer
        end

        it 'increment field incorrect_answers by 1' do
          expect(card.incorrect_answers).to eq 1
        end
      end

      context 'when user made typo in word' do
        let(:typo_answer) { card.check_answer('ehllo') }

        it 'return symbol ":typo_in_word"' do
          expect(typo_answer).to eq :typo_in_word
        end
      end
    end

    before do
      card.save
    end

    context '#set_review_interval' do
      context 'when 1 correct answer given' do
        before do
          card.check_answer(card.original_text)
        end

        it 'sets review date +12 hours from now' do
          expect(card.review_date).to eq (Time.zone.now + 12.hours).to_date
        end

        context 'and then gives one more correct answer' do
          it 'set review date +3 days from now' do
            card.check_answer(card.original_text)
            expect(card.review_date).to eq (Time.zone.now + 3.days).to_date
          end
        end

        context 'and then give 3 incorrect answers' do
          it 'set review date +12 hours from now' do
            3.times { card.check_answer(card.translated_text) }
            expect(card.review_date).to eq (Time.zone.now + 12.hours).to_date
          end
        end
      end

      context 'when gives 3 times correct answer' do
        it 'set review date +1 week from now' do
          3.times { card.check_answer(card.original_text) }
          expect(card.review_date).to eq (Time.zone.now + 1.week).to_date
        end
      end

      context 'when gives 4 times correct answer' do
        it 'set review date +2 weeks from now' do
          4.times { card.check_answer(card.original_text) }
          expect(card.review_date).to eq (Time.zone.now + 2.week).to_date
        end
      end

      context 'when gives 5 times correct answer' do
        it 'set review date +1 month from now' do
          5.times { card.check_answer(card.original_text) }
          expect(card.review_date).to eq (Time.zone.now + 1.month).to_date
        end
      end
    end

    context '#add_review_date' do
      it 'equals date today' do
        expect(card.review_date).to eq (Time.zone.now).to_date
      end
    end
  end