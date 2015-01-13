class Post < ActiveRecord::Base
  acts_as_commentable
  # has_many :comments, as: :commentable
end

