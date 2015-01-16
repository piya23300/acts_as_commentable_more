class PostCustomAssoName < ActiveRecord::Base
  acts_as_commentable as: :custom_comments

end

