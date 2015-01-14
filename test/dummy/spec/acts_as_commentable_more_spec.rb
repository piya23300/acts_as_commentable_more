require 'rails_helper'

RSpec.describe ActsAsCommentableMore do

  describe "managed basic comment" do
    it "add a comment" do
      post = create(:post)
      expect{post.comments.create(message: 'my message')}.to change(Comment, :count).by(1)
    end

    it "gets all comment" do
      posts = create_list(:post, 2)
      posts.each do |post|
        5.times { |i| post.comments.create(message: "message #{i}") }
        expect(post.comments.count).to eq 5
      end
      expect(Comment.count).to eq 10
    end

    it "any role of user" do
      post = create(:post)
      admin = create(:admin)
      user = create(:user)
      user_comment = post.comments.create(message: 'my message', user: user)
      admin_comment = post.comments.create(message: 'my message', user: admin)
      expect(user_comment.user).to eq user
      expect(admin_comment.user).to eq admin
    end

    describe "class helper" do
      context "self.find_comments_by_user(user, role: nil)" do
        before do
          post_1 = create(:post)
          post_2 = create(:post)
          @admin = create(:admin)
          @user = create(:user)
          user_comment_post_1 = post_1.comments.create(message: 'my message', user: @user)
          admin_comment_post_1 = post_1.comments.create(message: 'my message', user: @admin)
          user_comment_post_2 = post_2.comments.create(message: 'my message', user: @user)
        end

        it "findby user and role=nil" do
          Comment.find_comments_by_user(@user).each do |comment|
            expect(comment.user).to eq @user
            expect(comment.role).to eq 'comment'
          end
          Comment.find_comments_by_user(@admin).each do |comment|
            expect(comment.user).to eq @admin
            expect(comment.role).to eq 'comment'
          end
        end

        it "find by user and role can find" do
          Comment.find_comments_by_user(@user, :comment).each do |comment|
            expect(comment.user).to eq @user
            expect(comment.role).to eq 'comment'
          end
          Comment.find_comments_by_user(@admin, :comment).each do |comment|
            expect(comment.user).to eq @admin
            expect(comment.role).to eq 'comment'
          end
        end

        it "find by user and role doesn't have" do
          expect(Comment.find_comments_by_user(@user, :any_role).count).to eq 0
          expect(Comment.find_comments_by_user(@admin, :any_role).count).to eq 0
        end

      end
    end
    
  end

  describe "managed comments with association options :class_name and :as" do
    it "add a comment" do
      topic = create(:topic)
      expect{topic.comments.create(message: 'my message')}.to change(CustomComment, :count).by(1)
    end
    it "gets all comment" do
      topics = create_list(:topic, 2)
      topics.each do |topic|
        5.times { |i| topic.comments.create(message: "message #{i}") }
        expect(topic.comments.count).to eq 5
      end
      expect(CustomComment.count).to eq 10
    end
    it "any type of user" do
      topic = create(:topic)
      admin = create(:admin)
      user = create(:user)
      user_comment = topic.comments.create(message: 'my message', user: user)
      admin_comment = topic.comments.create(message: 'my message', user: admin)
      expect(user_comment.user).to eq user
      expect(admin_comment.user).to eq admin
    end
  end

  describe "managed comment that specific type" do
    describe "socpe all_comments" do

      it "default association options" do
        note = create(:note)
        5.times { |i| note.private_comments.create(message: 'private message') }
        3.times { |i| note.publish_comments.create(message: 'publish message') }

        other_note = create(:note)
        5.times { |i| other_note.private_comments.create(message: 'private message') }
        
        expect(note.all_comments.count).to eq 8
      end

      it "custom association options" do
        letter = create(:letter)
        5.times { |i| letter.hide_comments.create(message: 'hide message') }
        8.times { |i| letter.show_comments.create(message: 'show message') }

        other_letter = create(:letter)
        5.times { |i| other_letter.show_comments.create(message: 'show message') }
        
        expect(letter.all_comments.count).to eq 13
      end
      
    end

    it "doesn't have comments association to get all comment" do
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
      context "self.find_comments_by_user(user, role: nil)" do
        before do
          note_1 = create(:note)
          note_2 = create(:note)
          @admin = create(:admin)
          @user = create(:user)
          user_private_comment_note_1 = note_1.private_comments.create(message: 'private message user', user: @user)
          user_publish_comment_note_2 = note_2.publish_comments.create(message: 'publish message user', user: @user)
          admin_comment_note_1 = note_1.publish_comments.create(message: 'publish message admin', user: @admin)
        end

        it "findby user and role=nil" do
          Comment.find_comments_by_user(@user).each do |comment|
            expect(comment.user).to eq @user
            expect(comment.role).to eq('private').or eq('publish')
          end
          Comment.find_comments_by_user(@admin).each do |comment|
            expect(comment.user).to eq @admin
            expect(comment.role).to eq('private').or eq('publish')
          end
        end

        it "find by user and role can find" do
          Comment.find_comments_by_user(@user, :private).each do |comment|
            expect(comment.user).to eq @user
            expect(comment.role).to eq 'private'
          end
          Comment.find_comments_by_user(@admin, :publish).each do |comment|
            expect(comment.user).to eq @admin
            expect(comment.role).to eq 'publish'
          end
        end

        it "find by user and role doesn't have" do
          expect(Comment.find_comments_by_user(@user, :any_role).count).to eq 0
          expect(Comment.find_comments_by_user(@admin, :any_role).count).to eq 0
        end
      end

    end
  end

end
