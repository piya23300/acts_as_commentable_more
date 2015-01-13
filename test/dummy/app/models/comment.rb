class Comment < ActiveRecord::Base
  include ActsAsCommentableMore::Finders
  
  belongs_to :commentable, polymorphic: true
  belongs_to :user, polymorphic: true

  belongs_to :post
end
