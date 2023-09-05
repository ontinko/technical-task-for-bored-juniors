# frozen_string_literal: true

require_relative 'base_action'
require_relative '../models/activity'
require_relative '../api_caller'

class New < BaseAction
  ARGS_MAPPING = {
    type: :type,
    participants: :participants,
    price_min: :minprice,
    price_max: :maxprice,
    accessibility_min: :minaccessibility,
    accessibility_max: :maxaccessibility
  }.freeze

  def initialize(args)
    super
    @failure = false
    @message = ''
  end

  def call
    parse(@args)
    return puts @message if @failure

    api_caller = ApiCaller.new(@args)
    api_caller.call
    return api_caller.error if api_caller.failure

    print_activity(api_caller.activity)
    save_activity(api_caller.activity)
    return puts @message if @failure

    puts 'New activity added!'
  end

  private

  def save_activity(activity)
    Activity.create(**activity)
  rescue Sequel::UniqueConstraintViolation
    handle_error('Activity already saved!')
  end

  def print_activity(activity)
    puts "Activity: \n"
    puts "activity: #{activity['activity']}"
    puts "accessibility: #{activity['accessibility']}"
    puts "type: #{activity['type']}"
    puts "participants: #{activity['participants']}"
    puts "price: #{activity['price']}"
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
      return handle_error("Unknown parameter #{key} for new") unless ARGS_MAPPING.key?(key)
      return handle_error("Unspeficied value for #{key}") if args[key].nil?

      parsed_args[ARGS_MAPPING[key]] = args[key]
    end

    @args = parsed_args
  end
end
