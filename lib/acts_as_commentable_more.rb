module ActsAsCommentableMore
  require_relative 'acts_as_commentable_more/commentable_methods'
  ActiveRecord::Base.send(:include, ActsAsCommentableMore)
end
