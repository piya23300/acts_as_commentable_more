require 'rails_helper'

RSpec.describe CustomComment, :type => :model do

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

end
