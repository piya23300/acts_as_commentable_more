# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post_not_counter_field, :class => 'PostNotCounterField' do
    sequence(:title) { |n| "my title #{n}" }
  end
end
