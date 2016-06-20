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
end
