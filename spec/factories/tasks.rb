# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    project { nil }
    body { 'MyText' }
    priority { 1 }
    deadline { '2021-01-28 20:36:18' }
    completed { false }

    trait :invalid do
      body { nil }
    end
  end
end
