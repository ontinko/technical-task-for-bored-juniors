# frozen_string_literal: true

require_relative 'setup'
require_relative 'cli_handler'

CliHandler.new(ARGV).call
