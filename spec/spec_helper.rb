# frozen_string_literal: true

require_relative 'support/factory_bot'
require 'webmock/rspec'
require 'sequel'

DB = Sequel.connect('sqlite://db/test.sqlite3')

unless DB.table_exists?(:activities)
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

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.around do |example|
    DB.transaction(rollback: :always, auto_savepoint: true) { example.run }
  end
end
