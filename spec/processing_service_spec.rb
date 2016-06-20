require 'processing_service'

RSpec.describe ProcessingService do
  let(:survey_file) { 'survey-1.csv' }
  let(:response_file) { 'survey-1-responses.csv' }

  context '.import_survey' do
    subject { ProcessingService.import_survey(survey_file) }

    it 'should be and array of 5 survey questions' do
      expect(subject.count).to eq 5
    end

    it 'should include question with attribute id' do
      expect(subject.first.id).to eq 1
    end

    it 'should include question with attribute theme' do
      expect(subject.first.theme).to eq 'The Work'
    end

    it 'should include question with attribute type' do
      expect(subject.first.type).to eq 'ratingquestion'
    end

    it 'should include question with attribute text' do
      expect(subject.first.text).to eq 'I like the kind of work I do.'
    end
  end

  context '.import_responses' do
    subject { ProcessingService.import_responses(response_file) }

    before do
      ProcessingService.import_survey(survey_file)
    end

    it 'should be an array of 30 responses' do
      expect(subject.count).to eq 30
    end

    it 'should include response with attribute question_id' do
      expect(subject.first.question_id).to eq 1
    end

    it 'should include response with attribute email' do
      expect(subject.first.email).to eq 'employee1@abc.xyz'
    end

    it 'should include response with attribute employee_id' do
      expect(subject.first.employee_id).to eq '1'
    end

    it 'should include response with attribute submitted_at' do
      expect(subject.first.submitted_at).to eq '2014-07-28T20:35:41+00:00'
    end

    it 'should include response with attribute text' do
      expect(subject.first.text).to eq '5'
    end
  end

  context '.display_results' do
    subject { ProcessingService.display_results! }

    before do
      ProcessingService.process!(survey_file, response_file)
    end

    it 'should return a hash with key is question_id and value is average' do
      expect(subject.is_a? Hash).to eq true
    end
  end

  context '.display_participation_results' do
    let(:participation_output) { "\e[34mTotal Participants: 5\e[0m\n\e[33mTotal Participation Percentate: 83%\e[0m\n" }
    subject { ProcessingService.display_participation_results }

    before do
      ProcessingService.process!(survey_file, response_file)
    end

    it 'should return a hash with key is question_id and value is average' do
      expect { subject }.to output(participation_output).to_stdout
    end
  end

  context '.display_avg_for_rating_questions' do
    let(:rating_avg_output) do
      "\e[36mAverage for question 'I like the kind of work I do.'" \
      " - 4.6\e[0m\n\e[36mAverage for question 'In general, I have the " \
      'resources (e.g., business tools, information, facilities, IT or ' \
      "functional support) I need to be effective.' " \
      "- 5.0\e[0m\n\e[36mAverage for question 'We are working at " \
      "the right pace to meet our goals.' - 5.0\e[0m\n\e[36mAverage " \
      "for question 'I feel empowered to get the work done for which " \
      "I am responsible.' - 3.6\e[0m\n\e[36mAverage for question " \
      "'I am appropriately involved in decisions that affect my work.' " \
      "- 3.6\e[0m\n"
    end

    subject { ProcessingService.display_avg_for_rating_questions }

    before do
      ProcessingService.process!(survey_file, response_file)
    end

    it 'should return a hash with key is question_id and value is average' do
      expect { subject }.to output(rating_avg_output).to_stdout
    end
  end
end
