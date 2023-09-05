# frozen_string_literal: true

require_relative '../db_manager'

class List
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
    return puts 'Error: list command does not take arguments' unless @args.empty?

    @db_manager.list_activities
  end
end
