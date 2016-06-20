require 'response'

RSpec.describe Response do
  let(:response_1) do
    double(:response_1, question_id: 1, email: 'abc@test.com', employee_id: 123,
                        submitted_at: '2014-07-28T20:35:41+00:00', text: '5')
  end
  let(:response_2) do
    double(:response_2, question_id: 1, email: 'abcd@test.com', employee_id: 124,
                        submitted_at: '2014-07-28T20:35:41+00:00', text: '4')
  end

  let(:responses) { [response_1, response_2] }

  context '.total_participants' do
    let(:response_2) do
      double(:response_2, question_id: 1, email: 'abcd@test.com', employee_id: 124,
                          submitted_at: nil, text: '4')
    end

    subject { Response.total_participants(responses) }

    it 'should return total participants that have submitted the survey' do
      expect(subject).to eq 1
    end
  end

  context '.total_participation_percentage' do
    let(:response_2) do
      double(:response_2, question_id: 1, email: 'abcd@test.com', employee_id: 124,
                          submitted_at: nil, text: '4')
    end

    subject { Response.total_participation_percentage(responses) }

    it 'should return total participant percentage' do
      expect(subject).to eq 50
    end
  end

  context '.total_employees' do
    subject { Response.total_employees(responses) }

    it 'should return total employees' do
      expect(subject).to eq 2
    end
  end

  context '.submitted_responses' do
    let(:response_2) do
      double(:response_2, question_id: 1, email: 'abcd@test.com', employee_id: 124,
                          submitted_at: nil, text: '4')
    end

    subject { Response.submitted_responses(responses) }

    it 'should return all submitted responses' do
      expect(subject).to eq [response_1]
    end
  end

  context '.rating_question_responses' do
    let(:response_2) do
      double(:response_2, question_id: 2, email: 'abcd@test.com', employee_id: 124,
                          submitted_at: nil, text: '4')
    end

    let(:rating_question_ids) { [1] }

    subject { Response.rating_question_responses(responses, rating_question_ids) }

    it 'should return all rating question responses' do
      expect(subject).to eq [response_1]
    end
  end

  context '.hashed_responses_per_rating_question' do
    subject { Response.hashed_responses_per_rating_question(responses) }

    it 'should return hash of responses per rating question' do
      expect(subject[1]).to eq([5,4])
    end
  end
end
