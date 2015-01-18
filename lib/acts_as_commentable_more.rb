module ActsAsCommentableMore
  require 'acts_as_commentable_more/commentable_methods'
  require 'acts_as_commentable_more/comment_methods'

  ActiveRecord::Base.send(:include, ActsAsCommentableMore)

end
