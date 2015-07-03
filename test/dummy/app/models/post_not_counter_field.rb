class PostNotCounterField < ActiveRecord::Base
  acts_as_commentable :comments
end
