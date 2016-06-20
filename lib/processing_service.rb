require 'csv'
require 'rainbow'
require './lib/response'
require './lib/question'

class ProcessingService
  def self.process!(survey_file_name, response_file_name)
    @survey_questions = import_survey(survey_file_name)
    @question_count = @survey_questions.count
    @survey_responses = import_responses(response_file_name)
  end

  def self.import_survey(survey_file_name)
    questions = []
    i = 1
    CSV.foreach("example-data/survey-files/#{survey_file_name}", headers: true) do |row|
      questions << build_question(i, row)
      i += 1
    end
    questions
  end

  def self.import_responses(response_file_name)
    responses = []
    CSV.read("example-data/response-files/#{response_file_name}").each do |row|
      i = 0
      until i == @question_count
        r = build_response(i, row)
        responses << r
        i += 1
      end
    end
    responses
  end

  def self.display_results!
    display_participation_results
    display_avg_for_rating_questions
  end

  def self.display_participation_results
    total_participants = Response.total_participants(@survey_responses)
    total_participation_percentage = Response.total_participation_percentage(@survey_responses)
    puts Rainbow("Total Participants: #{total_participants}").blue
    puts Rainbow("Total Participation Percentate: #{total_participation_percentage}%").yellow
  end

  def self.display_avg_for_rating_questions
    submitted_responses = Response.submitted_responses(@survey_responses)
    avg_each_rating_question = Question.avg_each_rating_question(@survey_questions, submitted_responses)
    avg_each_rating_question.each do |question_id, avg|
      q = @survey_questions.find { |s| s.id == question_id }
      puts Rainbow("Average for question '#{q.text}' - #{avg}").cyan
    end
  end

  def self.build_response(i, row)
    r = Response.new
    r.question_id = i + 1
    r.email = row[0]
    r.employee_id = row[1]
    r.submitted_at = row[2]
    r.text = row[i + 3]
    r
  end

  def self.build_question(i, row)
    r = Question.new
    r.id = i
    r.theme = row['theme']
    r.type = row['type']
    r.text = row['text']
    r
  end
  private_class_method :build_response, :build_question
end
