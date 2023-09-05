# frozen_string_literal: true

FactoryBot.define do
  factory :activity do
    to_create(&:save)
  end
end
