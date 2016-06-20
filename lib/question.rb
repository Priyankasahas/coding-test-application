class Question
  attr_accessor :id, :theme, :type, :text

  def self.avg_each_rating_question(questions, submitted_responses)
    rating_question_ids = rating_questions(questions).map(&:id)
    rating_question_responses = submitted_responses.select { |r| rating_question_ids.include?(r.question_id) }
    hashed_avg_each_rating_question(rating_question_responses)
  end

  def self.rating_questions(questions)
    questions.select { |s| s.type == 'ratingquestion' }
  end

  def self.hashed_avg_each_rating_question(rating_question_responses)
    hashed_rating_questions_with_response(rating_question_responses)
      .each_with_object({}) do |(question_id, value_array), m|
      m[question_id] = ((value_array.inject(:+)).to_f / value_array.count.to_f)
    end
  end

  def self.hashed_rating_questions_with_response(rating_question_responses)
    rating_question_responses.each_with_object({}) do |response, n|
      filtered_responses = rating_question_responses.select do |r|
        r.question_id == response.question_id && r.text.respond_to?(:to_i)
      end
      n[response.question_id] = filtered_responses.collect { |r| r.text.to_i }
    end
  end
  private_class_method :hashed_avg_each_rating_question, :hashed_rating_questions_with_response
end
