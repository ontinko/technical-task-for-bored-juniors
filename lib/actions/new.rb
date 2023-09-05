# frozen_string_literal: true

require_relative 'base_action'
require_relative '../errors/application_error'
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

  def call
    parse(@args)

    api_caller = ApiCaller.new(@args)
    api_caller.call

    print_activity(api_caller.activity)
    save_activity(api_caller.activity)
  end

  private

  def save_activity(activity)
    Activity.create(**activity)
    puts 'New activity added!'
  rescue Sequel::UniqueConstraintViolation
    puts 'Activity already saved!'
  end

  def print_activity(activity)
    puts "activity: #{activity['activity']}"
    puts "type: #{activity['type']}"
    puts "accessibility: #{activity['accessibility']}"
    puts "participants: #{activity['participants']}"
    puts "price: #{activity['price']}"
    puts "key: #{activity['key']}"
    puts "link: #{activity['link']}"
    puts ''
  end

  def handle_error(message)
    raise ApplicationError, message
  end

  def parse(args)
    return if args.empty?

    parsed_args = {}

    args.each_key do |key|
      handle_error("Unknown parameter #{key} for new") unless ARGS_MAPPING.key?(key)
      handle_error("Unspeficied value for #{key}") if args[key].nil?

      parsed_args[ARGS_MAPPING[key]] = args[key]
    end

    @args = parsed_args
  end
end
