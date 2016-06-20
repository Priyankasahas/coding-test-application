require 'application'

RSpec.describe Application do
  let(:cli_service_class) { class_double('CliService').as_stubbed_const }
  let(:cli_service) { double(:cli_service) }

  before do
    allow(cli_service_class).to receive(:new) { cli_service }
  end

  subject { Application.new.survey_file_name }

  context '.survey_file_name' do
    context 'given a valid file name' do
      let(:file_name) { 'survey-1.csv' }

      it 'should return the file name' do
        expect(cli_service).to receive(:get_input) { file_name }
        expect(subject).to eq file_name
      end
    end

    context 'given an invalid file name' do
      let(:file_name) { 'survey.csv' }

      it 'should return the file name' do
        expect(cli_service).to receive(:get_input).exactly(4).times { file_name }
        expect(subject).to eq file_name
      end
    end
  end

  context '.response_file_name' do
    context 'given a valid file name' do
      let(:file_name) { 'survey-1-responses.csv' }

      it 'should return the file name' do
        expect(cli_service).to receive(:get_input) { file_name }
        expect(subject).to eq file_name
      end
    end

    context 'given an invalid file name' do
      let(:file_name) { 'response.csv' }

      it 'should return the file name' do
        expect(cli_service).to receive(:get_input).exactly(4).times { file_name }
        expect(subject).to eq file_name
      end
    end
  end
end
