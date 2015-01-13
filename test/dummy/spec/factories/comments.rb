# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    sequence(:message) { |n| "my massage #{n}" }
  end
end
