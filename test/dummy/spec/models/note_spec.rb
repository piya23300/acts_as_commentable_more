require 'rails_helper'

RSpec.describe Note, :type => :model do
  describe "managed comment that specific type" do
    it "has all_comments scope to get all comment" do
      note = create(:note)
      5.times { |i| note.private_comments.create(message: 'private message') }
      3.times { |i| note.publish_comments.create(message: 'publish message') }

      other_note = create(:note)
      5.times { |i| other_note.private_comments.create(message: 'private message') }
      
      expect(note.all_comments.count).to eq 8
    end
    it "doesn't have comments scope to get all comment" do
      note = create(:note)
      expect{ note.comments }.to raise_error(NoMethodError)
    end
    it "gets comment specific role by {role}_comments method" do
      note = create(:note)
      5.times { |i| note.private_comments.create(message: 'private message') }
      3.times { |i| note.publish_comments.create(message: 'publish message') }
      expect(note.private_comments.count).to eq 5
      expect(note.publish_comments.count).to eq 3
    end
    it "add comment specific role" do
      note = create(:note)

      private_note = note.private_comments.build(message: 'private message')
      expect{private_note.save}.to change(Comment, :count).by(1)
      expect(private_note.role).to eq 'private'

      publish_note = note.publish_comments.build(message: 'publish message')
      expect{publish_note.save}.to change(Comment, :count).by(1)
      expect(publish_note.role).to eq 'publish'
    end

    describe "class helper" do
      it "self.find_comments_by_user(user, role: nil)" do
        note_1 = create(:note)
        note_2 = create(:note)
        admin = create(:admin)
        user = create(:user)
        user_private_comment_note_1 = note_1.private_comments.create(message: 'my message', user: user)
        user_publish_comment_note_2 = note_1.publish_comments.create(message: 'my message', user: user)
        admin_comment_note_1 = note_1.publish_comments.create(message: 'my message', user: admin)

        Comment.find_comments_by_user(user).each do |comment|
          expect(comment.user).to eq user
          expect(comment.role).to eq('private').or eq('publish')
        end

        expect(Comment.find_comments_by_user(user)).to eq 1
        Comment.find_comments_by_user(user, 'publish').each do |comment|
          expect(comment.user).to eq user
          expect(comment.role).to eq('publish')
        end
      end
    end

  end

  

end
