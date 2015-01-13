# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin do
    sequence(:name) { |n| "my name #{n}" }
  end
end
