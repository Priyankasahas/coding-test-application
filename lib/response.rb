class Response
  attr_accessor :question_id, :email, :employee_id, :submitted_at, :text

  def self.total_participants(responses)
    submitted_responses(responses).map(&:employee_id).uniq.count
  end

  def self.total_participation_percentage(responses)
    total_participants(responses) * 100 / total_employees(responses)
  end

  def self.total_employees(responses)
    responses.map(&:employee_id).uniq.count
  end

  def self.submitted_responses(responses)
    responses.select { |r| !r.submitted_at.nil? }
  end

  def self.rating_question_responses(responses, rating_question_ids)
    responses.select { |r| rating_question_ids.include?(r.question_id) }
  end

  def self.hashed_responses_per_rating_question(responses)
    responses.each_with_object({}) do |response, n|
      filtered_responses = responses.select do |r|
        r.question_id == response.question_id && r.text.respond_to?(:to_i)
      end
      n[response.question_id] = filtered_responses.collect { |r| r.text.to_i }
    end
  end
end
