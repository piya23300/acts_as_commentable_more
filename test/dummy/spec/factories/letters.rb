# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :letter do
    sequence(:title) { |n| "my title #{n}" }
  end
end
