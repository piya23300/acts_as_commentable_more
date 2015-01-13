require 'rails_helper'

RSpec.describe Comment, :type => :model do

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
  end

  describe "class helper" do
    it "self.find_comments_by_user(user, role: nil)" do
      post_1 = create(:post)
      post_2 = create(:post)
      admin = create(:admin)
      user = create(:user)
      user_comment_post_1 = post_1.comments.create(message: 'my message', user: user)
      admin_comment_post_1 = post_1.comments.create(message: 'my message', user: admin)
      user_comment_post_2 = post_2.comments.create(message: 'my message', user: user)

      Comment.find_comments_by_user(user).each do |comment|
        expect(comment.user).to eq user
        expect(comment.role).to eq 'comment'
      end
      Comment.find_comments_by_user(admin).each do |comment|
        expect(comment.user).to eq admin
        expect(comment.role).to eq 'comment'
      end
    end
  end


end
