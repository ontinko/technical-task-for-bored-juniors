# frozen_string_literal: true

require_relative '../errors/application_error'
require_relative '../models/activity'
require_relative 'base_action'

class List < BaseAction
  # can't avoid the warning without unnecessary splitting the functionality, disabling the cop
  # rubocop:disable Metrics/AbcSize
  def call
    raise ApplicationError, 'List command takes no arguments!' unless @args.empty?

    activities = Activity.order(Sequel.desc(:created_at)).limit(5)

    return puts 'No activities saved!' if activities.empty?

    puts 'Activities:'
    activities.order(Sequel.desc(:created_at)).limit(5).each do |a|
      puts ''
      puts "activity: #{a[:activity]}"
      puts "type: #{a[:type]}"
      puts "accessibility: #{a[:accessibility]}"
      puts "participants: #{a[:participants]}"
      puts "price: #{a[:price]}"
      puts "key: #{a[:key]}"
      puts "link: #{a[:link]}"
    end
  end
  # rubocop:enable Metrics/AbcSize
end
