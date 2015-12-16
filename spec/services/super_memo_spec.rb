require 'rails_helper'

describe SuperMemo do
  let(:card) { build(:card) }
  let(:review_time) { 5_000 }
  let(:correct_answer) { card.check_answer('Hello', review_time) }
  subject { SuperMemo.new(2.5, 'Hello', card.original_text, 0, review_time, 0) }

  describe '#calculate_interval' do
    context 'when answer is correct' do
      let(:first_check) { subject.calculate_interval }

      it 'increments field repetitions_number by 1' do
        expect(first_check[:repetitions_number]).to eq 1
      end

      it 'sets the review date of "Time.zone.now + 1.day"' do
        expect(first_check[:review_date].to_date).to eq (Time.zone.now + 1.day).to_date
      end

      context 'after two repetitions' do
        before do
          correct_answer
        end

        let!(:another_check) { card.check_answer('Hello', review_time) }

        it 'field repetitions_number equals 2' do
          expect(card.repetitions_number).to eq 2
        end

        it 'field interval equals 6' do
          expect(card.interval).to eq 6
        end

        it 'sets the review date of "Time.zone.now + 6.days"' do
          expect(card.review_date).to eq (Time.zone.now + 6.days).to_date
        end
      end

      context 'when answer is incorrect' do
        let!(:incorrect_ans) { card.check_answer('Aloha', review_time) }

        it 'user\'s answer not equals to original text' do
          expect(incorrect_ans).to be :wrong_answer
        end

        it 'not changes review date' do
          expect(card.review_date).to eq (Time.zone.now).to_date
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
    end
  end

  describe '#reset_repetitions_number' do
    subject { SuperMemo.new(2.5, 'Hello', card.original_text, 1, 16_000, 1) }

    it 'resets repetitions number if quality is fewer than 3' do
      expect(subject.calculate_interval[:repetitions_number]).to eq 0
    end
  end

  describe '#compare_words' do
    context 'when the answer is correct' do
      let!(:correct_answer) { card.check_answer(card.original_text, review_time) }

      it 'returns :correct_answer' do
        expect(correct_answer).to be :correct_answer
      end
    end

    context 'when the answer is correct but with a few typos' do
      # Original text is "Hello"
      let!(:answer_with_typos) { card.check_answer('ehllo', review_time) }

      it 'returns :with_typos' do
        expect(answer_with_typos).to be :typo_in_word
      end
    end

    context 'when the answer is wrong' do
      let!(:wrong_answer) { card.check_answer('Wrong', review_time) }

      it 'returns :wrong_answer' do
        expect(wrong_answer).to be :wrong_answer
      end
    end
  end
end