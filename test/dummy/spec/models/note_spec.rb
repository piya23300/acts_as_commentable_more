require 'rails_helper'

RSpec.describe Note, :type => :model do
  it { should have_many(:private_comments).dependent(:destroy).class_name('Comment').conditions(role: 'private') }
  it { should have_many(:public_comments).dependent(:destroy).class_name('Comment').conditions(role: 'public') }
end
