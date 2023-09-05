# frozen_string_literal: true

require_relative '../models/activity'
require_relative 'base_action'

class List < BaseAction
  def call
    return puts 'Error: list command does not take arguments' unless @args.empty?

    activities = Activity.all

    return puts 'No activities saved!' if activities.empty?

    Activity.all.each do |a|
      puts ''
      puts "activity: #{a[:activity]}"
      puts "accessibility: #{a[:accessibility]}"
      puts "type: #{a[:type]}"
      puts "participants: #{a[:participants]}"
      puts "price: #{a[:price]}"
      puts "\n"
    end
  end
end
