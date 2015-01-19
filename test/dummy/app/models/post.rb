class Post < ActiveRecord::Base
  # attr_readonly :comments_count
  
  acts_as_commentable 

end
