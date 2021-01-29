FactoryBot.define do
  factory :project do
    title { "MyString" }
    description { "MyString" }

    trait :invalid do
      title { nil }
    end
  end
end
