require 'rails_helper'

RSpec.describe PostCustomAssoName, :type => :model do
  it { should have_many(:custom_comments).dependent(:destroy).class_name('Comment').conditions(role: 'custom_comment') }
end
