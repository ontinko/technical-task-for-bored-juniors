# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :activity do
    to_create(&:save)
    key { FFaker::Lorem.word }
    activity { FFaker::Lorem.sentence }
    accessibility { rand.round(2) }
    type { FFaker::Lorem.word }
    participants { rand(1..10) }
    price { rand.round(2) }
  end
end
