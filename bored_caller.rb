# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'

require_relative 'cli_parser'
require_relative 'db_manager'

class Caller
  BASE_URI = 'https://www.boredapi.com/api/activity/'
  PERMITTED_ARGS_NEW = %i[type participants price_min price_max accessibility-min accessibility_max].freeze

  def initialize(args)
    @args = args
    @query = build_query
    @db_manager = DbManager.new
  end

  def call
    query = @query.empty? ? '' : "?#{@query}"
    final_uri = URI("#{BASE_URI}#{query}")
    response = Net::HTTP.get_response(final_uri)
    activity = JSON.parse(response.body)
    @db_manager.add_activity(activity)

    puts "Response: #{response.body}"
  end

  private

  def build_query
    @args.map { |key, value| "#{transform_key(key)}=#{value}" }.join('&')
  end

  def transform_key(key)
    {
      type: 'type',
      participants: 'participants',
      price_min: 'minprice',
      price_max: 'maxprice',
      accessibility_min: 'minaccessibility',
      accessibility_max: 'maxaccessibility'
    }[key]
  end
end

def print_activities(activities)
  activities.each do |a|
    puts "Activity: #{a[:activity]}"
    puts "Accessibility: #{a[:accessibility]}"
    puts "Type: #{a[:type]}"
    puts "Participants: #{a[:participants]}"
    puts "Price: #{a[:price]}"
    puts "\n"
  end
end

def main
  cli_parser = CliParser.new(ARGV)
  cli_parser.call

  return puts cli_parser.error if cli_parser.failure

  case cli_parser.command
  when :new then Caller.new(cli_parser.args).call
  when :list
    db_manager = DbManager.new
    activities = db_manager.activities.all
    print_activities(activities)
  end
end

main
