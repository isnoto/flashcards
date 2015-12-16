# Implementation of SuperMemo2 algorithm with Levenshtein distance
# description SuperMemo2 at https://www.supermemo.com/english/ol/sm2.htm
# e_factor - easiness factor reflecting the easiness of memorizing and retaining a given item in memory

class SuperMemo
  def initialize(e_factor, answer, original_text, repetitions_number, time, interval)
    @e_factor = e_factor
    @comparison_result = compare_words(prepare_word(original_text), prepare_word(answer))
    @original_text = original_text
    @quality = get_quality(time)
    @repetitions_number = repetitions_number + 1
    @interval = interval
  end

  def calculate_interval
    interval = if @quality < 4
                 0
               else
                 get_new_interval(@repetitions_number)
               end

    reset_repetitions_number if @quality < 3

    {
      interval: interval,
      comparison_result: @comparison_result,
      review_date: Time.zone.now + interval.days,
      e_factor: e_factor,
      repetitions_number: @repetitions_number
    }
  end

  private

  def get_new_interval(repetition_number)
    case repetition_number
    when 1 then 1
    when 2 then 6
    else
      (@interval * @e_factor).round
    end
  end

  def e_factor
    @e_factor += 0.1 - (5 - @quality) * (0.08 + (5 - @quality) * 0.02)

    [1.3, @e_factor].max
  end

  def reset_repetitions_number
    @repetitions_number = 0
  end

  def get_quality(time)
    time = time.to_i / 1000

    if @comparison_result == :wrong_answer
      return 0
    elsif @comparison_result == :typo_in_word
      time += (@typos + 5) * 2
    end

    case time
    when 0..5   then 5
    when 6..10  then 4
    when 11..15 then 3
    when 16..20 then 2
    else 1
    end
  end

  def compare_words(original_text, answer)
    result = original_text == answer
    @typos = number_of_typos(original_text, answer)

    if result
      :correct_answer
    elsif @typos <= 2
      :typo_in_word
    else
      :wrong_answer
    end
  end

  def number_of_typos(original_text, answer)
    DamerauLevenshtein.distance(original_text, answer, 0)
  end

  def prepare_word(word)
    word.squish.mb_chars.downcase.to_s
  end
end
