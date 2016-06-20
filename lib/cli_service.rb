require 'highline'
require 'rainbow'

class CliService
  def initialize
    @service = HighLine.new
  end

  def get_input(message)
    @service.ask Rainbow(message).green
  end
end
