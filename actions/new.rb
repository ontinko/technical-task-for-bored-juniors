# frozen_string_literal: true

require_relative '../db_manager'
require_relative '../api_caller'
require 'pry'

class New
  PERMITTED_ARGS_NEW = %i[type participants price_min price_max accessibility_min accessibility_max].freeze

  def self.call(args)
    instance = new(args)
    instance.call
  end

  def initialize(args)
    @db_manager = DbManager.new
    @failure = false
    @message = ''
    @args = args
  end

  def call
    parse(@args)

    return puts @message if @failure

    api_caller = ApiCaller.new(@args)

    api_caller.call
    return api_caller.error if api_caller.failure

    print_new_activity(api_caller.activity)

    @db_manager.add_activity(api_caller.activity)
    return @db_manager.error if @db_manager.failure

    puts 'New activity added!'
  end

  private

  def print_new_activity(a)
    puts "Activity: \n"
    puts "activity: #{a['activity']}"
    puts "accessibility: #{a['accessibility']}"
    puts "type: #{a['type']}"
    puts "participants: #{a['participants']}"
    puts "price: #{a['price']}"
    puts "\n"
  end

  def handle_error(message)
    @failure = true
    @message = message
  end

  def parse(args)
    return if args.empty?

    parsed_args = {}

    args.each_key do |key|
      return handle_error("Unknown parameter #{key} for new") unless PERMITTED_ARGS_NEW.include?(key)
      return handle_error("Unspeficied value for #{key}") if args[key].nil?

      parsed_args[transform_key(key)] = args[key]
    end

    @args = parsed_args
  end

  def transform_key(key)
    {
      type: :type,
      participants: :participants,
      price_min: :minprice,
      price_max: :maxprice,
      accessibility_min: :minaccessibility,
      accessibility_max: :maxaccessibility
    }[key]
  end
end
