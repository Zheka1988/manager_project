# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { 'MyString' }
    description { 'MyString' }

    trait :invalid do
      title { nil }
    end
  end
end
