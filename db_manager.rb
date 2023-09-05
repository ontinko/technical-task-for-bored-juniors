# frozen_string_literal: true

require 'sequel'

class DbManager
  attr_reader :activities, :failure

  DB_NAME = './bored.db'

  def initialize
    @failure = false
    @message = ''
    @db = Sequel.sqlite(DB_NAME)
    setup_db
    @activities = @db[:activities]
  end

  def add_activity(activity)
    return handle_error('Activity already saved!') unless @activities[{ key: activity['key'] }].nil?

    @activities.insert(**activity)
  end

  def list_activities
    @activities.each do |a|
      puts "activity: #{a[:activity]}"
      puts "accessibility: #{a[:accessibility]}"
      puts "type: #{a[:type]}"
      puts "participants: #{a[:participants]}"
      puts "price: #{a[:price]}"
      puts "\n"
    end
  end

  def error
    puts "Error: #{@message}"
  end

  private

  def setup_db
    return if @db.table_exists?(:activities)

    @db.create_table :activities do
      primary_key :key
      String :activity
      String :type
      Integer :participants
      Float :price
      String :link
      Float :accessibility
    end
  end

  def handle_error(message)
    @failure = true
    @message = message
  end
end
