require 'rails_helper'

RSpec.describe NoteCustomAssoName, :type => :model do
  it { should have_many(:private_custom_comments).dependent(:destroy).class_name('Comment').conditions(role: 'private') }
  it { should have_many(:public_custom_comments).dependent(:destroy).class_name('Comment').conditions(role: 'public') }
end
