require 'rails_helper'

RSpec.describe Topic, :type => :model do
  it { should have_many(:comments).dependent(:destroy).class_name('CustomComment').conditions(role: 'comment') }
end
