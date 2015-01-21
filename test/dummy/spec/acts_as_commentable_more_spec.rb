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

  describe "managed comments with association options(:class_name and :as)" do
    it "add a comment" do
      topic = create(:topic)
      comment = topic.comments.build(message: 'my message')
      expect{comment.save}.to change(CustomComment, :count).by(1)
      expect(comment.role).to eq 'comment'
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
        3.times { |i| note.public_comments.create(message: 'public message') }

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
      3.times { |i| note.public_comments.create(message: 'public message') }
      expect(note.private_comments.count).to eq 5
      expect(note.public_comments.count).to eq 3
    end

    it "add comment specific role" do
      note = create(:note)

      private_note = note.private_comments.build(message: 'private message')
      expect{private_note.save}.to change(Comment, :count).by(1)
      expect(private_note.role).to eq 'private'

      public_note = note.public_comments.build(message: 'public message')
      expect{public_note.save}.to change(Comment, :count).by(1)
      expect(public_note.role).to eq 'public'
    end

    describe "creates_{role}_{as}s method for adding comment of role" do
      it "creates_private_comments" do
        note = create(:note)
        expect{note.creates_private_comments(message: 'new comment')}.to change(Comment, :count).by(1)
      end
      it "creates_public_comments" do
        note = create(:note)
        expect{note.creates_public_comments(message: 'new comment')}.to change(Comment, :count).by(1)
      end
    end

    describe "#to_role" do
      before do
        @note = create(:note)
        @private_comment = @note.private_comments.create(message: 'private message')
      end
      it "change only" do
        @private_comment.to_public
        expect(@private_comment.role).to eq 'public'
        @private_comment.reload
        expect(@private_comment.role).to eq 'private'
      end

      it "returns object" do
        expect(@private_comment.to_public).to be_a(Comment)
      end
    end

    describe "#to_role!" do
      before do
        @note = create(:note)
        @private_comment = @note.private_comments.create(message: 'private message')
      end
      it "change and update" do
        @private_comment.to_public!
        expect(@private_comment.role).to eq 'public'
        @private_comment.reload
        expect(@private_comment.role).to eq 'public'
      end
      it "returns object" do
        expect(@private_comment.to_public!).to be_a(Comment)
      end
    end

    describe "#is_role?" do
      it "check role value" do
        note = create(:note)
        private_comment = note.private_comments.create(message: 'private message')
        expect(private_comment.is_private?).to eq true
        expect(private_comment.is_public?).to eq false
      end
    end

    describe "class helper" do
      context "self.find_comments_by_user(user, role: nil)" do
        before do
          note_1 = create(:note)
          note_2 = create(:note)
          @admin = create(:admin)
          @user = create(:user)
          user_private_comment_note_1 = note_1.private_comments.create(message: 'private message user', user: @user)
          user_public_comment_note_2 = note_2.public_comments.create(message: 'public message user', user: @user)
          admin_comment_note_1 = note_1.public_comments.create(message: 'public message admin', user: @admin)
        end

        it "find by user and role=nil" do
          Comment.find_comments_by_user(@user).each do |comment|
            expect(comment.user).to eq @user
            expect(comment.role).to eq('private').or eq('public')
          end
          Comment.find_comments_by_user(@admin).each do |comment|
            expect(comment.user).to eq @admin
            expect(comment.role).to eq('private').or eq('public')
          end
        end

        it "find by user and role can find" do
          Comment.find_comments_by_user(@user, :private).each do |comment|
            expect(comment.user).to eq @user
            expect(comment.role).to eq 'private'
          end
          Comment.find_comments_by_user(@admin, :public).each do |comment|
            expect(comment.user).to eq @admin
            expect(comment.role).to eq 'public'
          end
        end

        it "find by user and role doesn't have" do
          expect(Comment.find_comments_by_user(@user, :any_role).count).to eq 0
          expect(Comment.find_comments_by_user(@admin, :any_role).count).to eq 0
        end
      end

    end
  end

  describe "record related attributes" do
    it "can update related_attributes feild with hash array" do
      post = create(:post)
      comment = post.comments.create(related_attributes: {user_id: 1, location_name: 'Thailand'})
      expect(comment.related_attributes['user_id']).to eq nil
      expect(comment.related_attributes['location_name']).to eq nil
      expect(comment.related_attributes[:user_id]).to eq '1'
      expect(comment.related_attributes[:location_name]).to eq 'Thailand'
    end

  end

  describe "setting :as to custom association name" do
    it "role= :as.singulize" do
      post_custom = create(:post_custom_asso_name)
      comment = post_custom.creates_custom_comments
      expect(comment.role).to eq 'custom_comment'
    end
    it "doen't have any roles" do
      post_custom = create(:post_custom_asso_name)
      expect{post_custom.custom_comments}.not_to raise_error
      expect{post_custom.creates_custom_comments()}.not_to raise_error

      expect{post_custom.comments}.to raise_error(NoMethodError)
      expect{post_custom.creates_comments()}.to raise_error(NoMethodError)
    end

    it "has roles" do
      note_custom = create(:note_custom_asso_name)
      expect{note_custom.all_custom_comments}.not_to raise_error
      expect{note_custom.private_custom_comments}.not_to raise_error
      expect{note_custom.public_custom_comments}.not_to raise_error
      expect{note_custom.creates_public_custom_comments()}.not_to raise_error
      expect{note_custom.creates_private_custom_comments()}.not_to raise_error

      expect{note_custom.all_comments}.to raise_error(NoMethodError)
      expect{note_custom.private_comments}.to raise_error(NoMethodError)
      expect{note_custom.public_comments()}.to raise_error(NoMethodError)
      expect{note_custom.creates_public_comments()}.to raise_error(NoMethodError)
      expect{note_custom.creates_private_comments()}.to raise_error(NoMethodError)
    end

  end

  describe "STI Subclass" do
    it "add class_name not base_name for owner type" do
      sub_model = SubModel.create
      comment = sub_model.comments.create(message: 'sub post')
      expect(comment.commentable_type).to eq sub_model.class.name
    end
  end

  describe "cache comment counts" do

    it "counter fields read only" do
      post = Post.create
      comment = post.comments.create
      post.update(comments_count: 999)
      post.reload
      expect(post.comments_count).to eq 1
    end

    it "disable" do
      post = create(:post_disable_cach)
      comment = post.comments.create
      post.reload
      expect(post.disable_cache_commentable_count).to eq 0
    end

    it "doesn't have any counter fields" do
      post_not_counter_field = create(:post_not_counter_field)
      expect{ post_not_counter_field.comments.create }.not_to raise_error
    end

    context "counter all comments counter" do
      context "not roles" do
        before do
          @post = create(:post)
          @comments = @post.comments.create([{message: 'comment 1'}, {message: 'comment 2'}])
          @post.reload
        end
        it "increased", dd: true do
          expect(@post.comments_count).to eq 2
        end
        it "decreased" do
          @comments.last.destroy
          @post.reload
          expect(@post.comments_count).to eq 1
        end
      end

      context "association options class_name" do
        before do
          @letter = create(:letter)
          @hide_comments = @letter.hide_comments.create([{message: 'hide letter 1'}, {message: 'hide letter 2'}])
          @show_comments = @letter.show_comments.create([{message: 'show letter 1'}, {message: 'show letter 2'}])
          @letter.reload
        end
        it "increased" do
          expect(@letter.hide_custom_comments_count).to eq 2
          expect(@letter.show_custom_comments_count).to eq 2
          expect(@letter.custom_comments_count).to eq 4
        end
        it "decreased" do
          @hide_comments.last.destroy
          @letter.reload
          expect(@letter.hide_custom_comments_count).to eq 1
          expect(@letter.show_custom_comments_count).to eq 2
          expect(@letter.custom_comments_count).to eq 3
        end
      end

    end

    context "counter many roles" do
      before do
        @note = create(:note)
        @private_comments = @note.private_comments.create([{message: 'private comment 1'}, {message: 'private comment 2'}])
        @public_comments = @note.public_comments.create([{message: 'public comment 1'}, {message: 'public comment 2'}])
        @note.reload
      end
      it "increased" do
        expect(@note.private_comments_count).to eq 2
        expect(@note.public_comments_count).to eq 2
        expect(@note.comments_count).to eq 4
      end
      it "decreased" do
        @private_comments.last.destroy
        @note.reload
        expect(@note.private_comments_count).to eq 1
        expect(@note.public_comments_count).to eq 2
        expect(@note.comments_count).to eq 3
      end
    end
    
  end

end
