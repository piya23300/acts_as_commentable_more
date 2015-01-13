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
    it "any type of user" do
      post = create(:post)
      admin = create(:admin)
      user = create(:user)
      user_comment = post.comments.create(message: 'my message', user: user)
      admin_comment = post.comments.create(message: 'my message', user: admin)
      expect(user_comment.user).to eq user
      expect(admin_comment.user).to eq admin
    end
  end



end
