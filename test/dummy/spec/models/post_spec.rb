require 'rails_helper'

RSpec.describe Post, :type => :model do
  it { should have_many(:comments).dependent(:destroy).class_name('Comment').conditions(role: 'comment') }

end
