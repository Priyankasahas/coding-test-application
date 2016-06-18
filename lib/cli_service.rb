require 'highline'

class CliService
  def initialize
    @service = HighLine.new
  end

  def get_input(message)
    @service.ask message
  end
end
