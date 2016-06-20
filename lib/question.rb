require 'response'

class Question
  attr_accessor :id, :theme, :type, :text

  def self.avg_each_rating_question(questions, submitted_responses)
    rating_question_ids = rating_questions(questions).map(&:id)
    rating_question_responses = Response.rating_question_responses(submitted_responses, rating_question_ids)
    hashed_avg_each_rating_question(rating_question_responses)
  end

  def self.rating_questions(questions)
    questions.select { |s| s.type == 'ratingquestion' }
  end

  def self.hashed_avg_each_rating_question(rating_question_responses)
    Response.hashed_responses_per_rating_question(rating_question_responses)
      .each_with_object({}) do |(question_id, value_array), m|
      m[question_id] = ((value_array.inject(:+)).to_f / value_array.count.to_f)
    end
  end
  private_class_method :hashed_avg_each_rating_question
end
