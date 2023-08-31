# frozen_string_literal: true

require 'pry'

class CliParser
  PERMITTED_ARGS_NEW = %i[type participants price_min price_max accessibility_min accessibility_max].freeze
  LIST_COMMAND = :list
  NEW_COMMAND = :new

  attr_reader :args, :failure, :message, :command

  def initialize(argv)
    @argv = argv
    @args = {}
    @command = nil
    @failure = false
    @message = ''
  end

  def call
    return handle_error('Unspecified action') if @argv.empty?

    parse_params

    case @argv.first.to_sym
    when LIST_COMMAND then handle_list
    when NEW_COMMAND then handle_new
    else
      puts handle_error('Invalid agruments')
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

  def handle_list
    @command = LIST_COMMAND
    return unless @argv.size > 1

    error_message = "Unknown parameters for list: #{@argv[1..].join(' ')}"
    handle_error(error_message)
  end

  def handle_new
    @command = NEW_COMMAND
    return if @args.empty?

    @args.each_key do |key|
      return handle_error("Unknown parameter #{key} for new") unless PERMITTED_ARGS_NEW.include?(key)
      return handle_error("Unspeficied value for #{key}") if @args[key].nil?
    end
  end

  def handle_error(message)
    @failure = true
    @mesage = message
  end
end
