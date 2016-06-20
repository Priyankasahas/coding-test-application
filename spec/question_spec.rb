require 'question'

RSpec.describe Question do
  let(:question_1) do
    double(:question_1, id: 1, theme: 'The Work',
                        type: 'ratingquestion', text: 'I like the kind of work I do.')
  end
  let(:question_2) do
    double(:question_2, id: 2, theme: 'The Place', type: 'ratingquestion',
                        text: 'I feel empowered to get the work done for which I am responsible.')
  end

  let(:questions) { [question_1, question_2] }

  let(:response_1) do
    double(:response_1, question_id: 1, email: 'abc@test.com', employee_id: 123,
                        submitted_at: '2014-07-28T20:35:41+00:00', text: '5')
  end
  let(:response_2) do
    double(:response_2, question_id: 1, email: 'abcd@test.com', employee_id: 124,
                        submitted_at: '2014-07-28T20:35:41+00:00', text: '4')
  end

  let(:responses) { [response_1, response_2] }

  context '.avg_each_rating_question' do
    subject { Question.avg_each_rating_question(questions, responses) }

    it 'should return hash where key is rating question and value is average of responses' do
      expect(subject[1]).to eq 4.5
    end
  end

  context '.rating_questions' do
    let(:question_3) { double(:question_3, id: 3, theme: 'The Place', type: 'singleselect', text: 'Priyanka') }

    subject { Question.rating_questions(questions) }

    it 'should return an array containing rating questions' do
      expect(subject).to include(question_1, question_2)
    end

    it 'should not return array with singleselect questions' do
      expect(subject).to_not include(question_3)
    end
  end
end
