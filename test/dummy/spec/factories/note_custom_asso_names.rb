# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note_custom_asso_name do
    sequence(:title) { |n| "my title #{n}" }
  end
end
