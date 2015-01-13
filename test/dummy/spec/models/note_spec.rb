require 'rails_helper'

RSpec.describe Note, :type => :model do
  describe "managed comment that specific type" do
    it "has all_comments scope to get all comment" do
      note = create(:note)
      5.times { |i| note.private_comments.create(message: 'private message') }
      3.times { |i| note.publish_comments.create(message: 'publish message') }
      expect(note.all_comments.count).to eq 8
    end
    it "doesn't have comments scope to get all comment" do
      note = create(:note)
      expect{ note.comments }.to raise_error(NoMethodError)
    end
    it "gets comment specific type by {type}_comments method" do
      note = create(:note)
      5.times { |i| note.private_comments.create(message: 'private message') }
      3.times { |i| note.publish_comments.create(message: 'publish message') }
      expect(note.private_comments.count).to eq 5
      expect(note.publish_comments.count).to eq 3
    end
    it "add comment specific type" do
      note = create(:note)
      private_note = note.private_comments.create(message: 'private message')
      expect(private_note.type).to eq 'private'
      publish_note = note.publish_comments.create(message: 'publish message')
      expect(publish_note.type).to eq 'publish'
    end
  end
end
