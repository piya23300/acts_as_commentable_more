
class CustomComment < ActiveRecord::Base
  ###################################################################
  ### To implement commentable add the following line to your model
  ### acts_as_commentable types: [:hide, :show], options: { class_name: 'CustomComment', as: :custom_commentable }
  
  ### types is an array of possible comment type
  ### for example if you have public and private comment
  ### your types would be [:public, :private]

  include ActsAsCommentableMore::Finders

  belongs_to :custom_commentable, polymorphic: true, counter_cache: true
  belongs_to :user, polymorphic: true

  ###################################################################
end