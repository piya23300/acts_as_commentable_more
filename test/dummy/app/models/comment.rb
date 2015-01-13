class Comment < ActiveRecord::Base
  acts_as_commentable
  
  belongs_to :commentable, polymorphic: true
  belongs_to :user, polymorphic: true
end
