class Note < ActiveRecord::Base
  acts_as_commentable :comments, types: [:private, :public]
end
