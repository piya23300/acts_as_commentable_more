
class DisableCacheComment < ActiveRecord::Base
  ###################################################################
  ### To implement commentable add the following line to your model
  ### acts_as_commentable types: [:hide, :show], options: { class_name: 'DisableCacheComment', as: :disable_cache_commentable }, as: :disablecachecomments
  
  ### types is an array of possible comment type
  ### for example if you have public and private comment
  ### your types would be [:public, :private]

  include ActsAsCommentableMore::Finders

  belongs_to :disable_cache_commentable, polymorphic: true, counter_cache: false
  belongs_to :user, polymorphic: true

  ###################################################################
end