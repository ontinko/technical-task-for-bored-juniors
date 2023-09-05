# frozen_string_literal: true

require 'sequel'

class Activity < Sequel::Model(:activities)
  def before_create
    super
    self.created_at ||= Time.now
  end
end
