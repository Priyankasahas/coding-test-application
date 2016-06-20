require 'rainbow'
require './lib/cli_service'
require './lib/processing_service'

class Application
  def initialize
    @cli_service = CliService.new
  end

  def survey_file_name
    i = 0
    valid = false
    until valid == true
      i += 1
      file_name = @cli_service.get_input("Please provide a survey file from the list below: #{survey_files_list}")
      valid = file_name && survey_files_list.include?(file_name)
      show_exit_message('Find out the survey file name!! Exiting...') if i == 4
      puts Rainbow("Invalid file #{file_name}. Please try again..").red unless valid
    end
    file_name
  end

  def response_file_name
    i = 0
    valid = false

    until valid == true
      i += 1
      file_name = @cli_service.get_input("Please provide a response file from the list below: #{response_files_list}")
      valid = file_name && response_files_list.include?(file_name)
      show_exit_message('Find out the response file name!! Exiting...') if i == 4
      puts Rainbow("Invalid file #{file_name}. Please try again..").red unless valid
    end
    file_name
  end

  def process_survey(survey_file, response_file)
    ProcessingService.process!(survey_file, response_file)
    ProcessingService.display_results!
  end

  private

  def survey_files_list
    Dir.glob('example-data/survey-files/**/*.csv').collect { |f| File.basename f }
  end

  def response_files_list
    Dir.glob('example-data/response-files/**/*.csv').collect { |f| File.basename f }
  end

  def show_exit_message(message)
    puts Rainbow(message).underline.red
    exit
  end
end
