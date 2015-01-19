# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post_disable_cach, :class => 'PostDisableCache' do
    sequence(:title) { |n| "my title #{n}" }
  end
end
