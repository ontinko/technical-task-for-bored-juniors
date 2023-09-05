# frozen_string_literal: true

require_relative 'actions/list'
require_relative 'actions/new'

class CliHandler
  NEW_COMMAND = :new
  LIST_COMMAND = :list

  def initialize(argv)
    @argv = argv
    @args = {}
  end

  def call
    raise ApplicationError, 'Unspecified action' if @argv.empty?

    parse_params

    case @argv.first.to_sym
    when LIST_COMMAND then List.call(@args)
    when NEW_COMMAND then New.call(@args)
    else
      raise ApplicationError, 'Invalid agruments'
    end
  end

  private

  def parse_params
    i = 1
    while i < @argv.size
      key = @argv[i]
      value = @argv[i + 1]
      @args[key[2..].to_sym] = value
      i += 2
    end
  end
end
