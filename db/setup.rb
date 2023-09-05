# frozen_string_literal: true

require 'sequel'

DB = Sequel.sqlite('./db/db.sqlite3')

def setup_db
  return if DB.table_exists?(:activities)

  DB.create_table :activities do
    primary_key :id
    String :key
    unique :key
    String :activity
    String :type
    Integer :participants
    Float :price
    String :link
    Float :accessibility
  end
end

setup_db
