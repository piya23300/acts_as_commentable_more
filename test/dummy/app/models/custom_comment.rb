class CustomComment < ActiveRecord::Base
  include ActsAsCommentableMore::Finders
  
  belongs_to :customable, polymorphic: true
  belongs_to :user, polymorphic: true
end
