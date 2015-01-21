require 'rails_helper'

RSpec.describe Topic, :type => :model do
  it { should have_many(:custom_comments).dependent(:destroy).class_name('CustomComment').conditions(role: 'custom_comment') }
end
