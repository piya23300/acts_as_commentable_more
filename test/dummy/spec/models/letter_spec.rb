require 'rails_helper'

RSpec.describe Letter, :type => :model do
  it { should have_many(:hide_comments).dependent(:destroy).class_name('CustomComment').conditions(role: 'hide') }
  it { should have_many(:show_comments).dependent(:destroy).class_name('CustomComment').conditions(role: 'show') }
end
