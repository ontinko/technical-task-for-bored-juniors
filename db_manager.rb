# frozen_string_literal: true

require 'sequel'

class DbManager
  attr_reader :activities

  DB_NAME = './bored.db'

  def initialize
    @db = Sequel.sqlite(DB_NAME)
    setup_db
    @activities = @db[:activities]
  end

  def add_activity(activity)
    return unless @activities[{ key: activity['key'] }].nil?

    @activities.insert(**activity)
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
end
