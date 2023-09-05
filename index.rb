# frozen_string_literal: true

require_relative 'db/setup'
require_relative 'cli_handler'

begin
  CliHandler.new(ARGV).call
rescue ApplicationError => e
  puts "Error: #{e.message}"
end
